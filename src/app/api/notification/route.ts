import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";
import Parser from "@/utils/Parser";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, true);
    const role = currentUser.role;
    const { limit, offset, start_date, end_date, msg, type }: any = params;
    const queryParams: any[] = [];

    const id_user = currentUser.id_user;
    if (role !== "admin" && currentUser.id_user !== id_user)
      throwCustomError("Not enough permission", 401);

    const query = `
    SELECT 
      n.id_notification,
      n.msg,
      n.type,
      n.status,
      n.created_at
    FROM Notification n
    WHERE TRUE
      ${(id_user !== undefined && `AND n.id_user = '${id_user}'`) || ""}
      ${(msg !== undefined && `AND n.msg LIKE '%${msg}%'`) || ""}
      ${(type !== undefined && `AND n.type LIKE '%${type}%'`) || ""}
      ${start_date !== undefined ? `AND n.created_at >= '${start_date}'` : ""}
      ${end_date !== undefined ? `AND n.created_at <= '${end_date}'` : ""}
      
      ${limit !== undefined ? ` LIMIT ${limit}` : ""}
      ${offset !== undefined ? ` OFFSET ${offset}` : ""}
    `;

    const [typeList]: Array<any> = await connection.query(query, queryParams);

    return objectResponse({ data: typeList });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const { name, slug, description, is_show } = body;

    // Validation
    Checker.checkString(name, true);
    Checker.checkString(slug);
    Checker.checkString(description);
    Checker.checkString(slug);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        "select id_type from Type where slug = ?",
        [slug]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 400);
    }

    // Check slug not empty
    if (slug === "") throwCustomError("Slug cannot be empty string", 400);

    // Update DB
    const newId = uuidv4();
    const [result]: Array<any> = await connection.query(
      `
      insert into Type
        (
          id_type
          name,
          slug,
          description,
          is_show
        )  
      values 
        (?, ?, ?, ?, ?)
      `,
      [newId, name, slug, description, is_show]
    );

    return objectResponse({ newID: newId });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
