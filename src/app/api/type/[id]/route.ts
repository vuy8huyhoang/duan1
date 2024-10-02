import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { objectResponse } from "@/utils/Response";

export const GET = async (request: Request, context: any) => {
  try {
    const { params } = context;
    const { id } = params;
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
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
    AND id_type = '${id}'
    ${role === "admin" ? "" : "AND is_show = 1"}
    `;

    const [type]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: type[0] });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const PATCH = async (request: Request, context: any) => {
  try {
    const body = await request.json();
    const { name, slug, description, is_show } = body;
    const { params } = context;
    const { id } = params;
    const id_type = id;

    // Validation
    Checker.checkString(name);
    Checker.checkString(slug);
    Checker.checkString(description);
    Checker.checkString(slug);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request, true);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug if slug is provided
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        `select id_type from Type where slug = ? and id_user <> ${currentUser.id_user}`,
        [slug, id_type]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 400);
    }

    // Check music exist
    const [typeList]: any[] = await connection.query(
      "select id_type from Type where id_type = '" + id_type + "'"
    );
    if (typeList.length === 0) throwCustomError("Type not found", 400);

    // Update DB
    const querySet = [];
    const queryParams = [];

    if (name !== undefined) {
      querySet.push("name = ?");
      queryParams.push(name);
    }
    if (description !== undefined) {
      querySet.push("description = ?");
      queryParams.push(description);
    }
    if (slug !== undefined) {
      querySet.push("slug = ?");
      queryParams.push(slug);
    }
    if (description !== undefined) {
      querySet.push("description = ?");
      queryParams.push(description);
    }
    if (is_show !== undefined) {
      querySet.push("is_show = ?");
      queryParams.push(is_show);
    }

    if (querySet.length === 0)
      throwCustomError("No valid fields to update", 400);

    queryParams.push(id_type); // Push the ID at the end for the WHERE clause

    const [result]: Array<any> = await connection.query(
      `update Type set ${querySet.join(", ")} where id_type = ?`,
      queryParams
    );

    if (result.affectedRows === 0) {
      throwCustomError("Type not found", 404);
    }

    return objectResponse({ success: "Updated successfully" }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const DELETE = async (request: Request, context: any) => {
  try {
    const { params } = context;
    const { id } = params;

    // Validation
    Checker.checkString(id, true);

    // Check permission
    const currentUser = await getCurrentUser(request, true);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Delete Type from DB
    const [result]: Array<any> = await connection.query(
      "delete from Type where id_type = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      throwCustomError("Type not found", 404);
    }

    return objectResponse({ message: "Deleted successfully" }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
