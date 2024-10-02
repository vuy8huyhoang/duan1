import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import {
  getByEqual,
  getByLike,
  getByLimitOffset,
  getByRole,
  getCurrentUser,
} from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const { limit, offset, id_type, name, slug, created_at, is_show }: any =
      params;
    const queryParams: any[] = [];

    const query = `
    SELECT 
      id_type,
      name,
      slug,
      created_at,
      is_show
    FROM Type
    WHERE TRUE
    ${getByRole(role, "is_show")}
    
    ${getByEqual(id_type, "id_type")}
    ${getByLike(name, "name")}
    ${getByLike(slug, "slug")}
    ${getByEqual(is_show, "is_show")}

    ${getByLimitOffset(limit, offset, "created_at")}
    `;

    const [typeList]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: typeList }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const { name, slug, is_show = 1 } = body;

    // Validation
    Checker.checkString(name, true);
    Checker.checkString(slug);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request, true);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        "select id_type from Type where slug = ?",
        [slug]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 409);
    }

    // Check slug not empty
    if (slug === "") throwCustomError("Slug cannot be empty string", 400);

    // Update DB
    const newId = uuidv4();
    const [result]: Array<any> = await connection.query(
      `
      insert into Type
        (
          id_type,
          name,
          slug,
          is_show
        )  
      values 
        (?, ?, ?, ?)
      `,
      [newId, name, slug, is_show]
    );

    return objectResponse({ newID: newId });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
