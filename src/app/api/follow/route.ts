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
    const { limit, offset, id_artist, start_date, end_date }: any = params;
    let currentUser;
    if (id_artist === undefined) {
      currentUser = await getCurrentUser(request, true);
    } else currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const queryParams: any[] = [];

    const id_user = currentUser.id_user;
    Checker.checkDate(start_date);
    Checker.checkDate(end_date);

    const query = `
    SELECT 
      f.id_follow,
      f.created_at,
      ${Parser.queryObject([
        "'id_user', u.id_user",
        "'id_user', u.id_user",
        "'id_user', u.id_user",
      ])} AS user
    FROM Follow f
    LEFT JOIN 
      User u on u.id_user = f.id_user 
    WHERE TRUE
      ${id_artist !== undefined ? `AND f.id_artist = '${id_artist}'` : ""}
      ${id_user !== undefined ? `AND f.id_user = '${id_user}'` : ""}
      ${start_date !== undefined ? `AND f.created_at >= '${start_date}'` : ""}
      ${end_date !== undefined ? `AND f.created_at <= '${end_date}'` : ""}

      ${limit !== undefined ? ` LIMIT ${limit}` : ""}
      ${offset !== undefined ? ` OFFSET ${offset}` : ""}
    `;

    const [followList]: Array<any> = await connection.query(query, queryParams);
    Parser.convertJson(followList as Array<any>, "user");
    return objectResponse({ data: followList });
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
