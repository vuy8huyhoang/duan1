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
    let query = "";

    if (role === "admin") {
      query += `SELECT * FROM Artist WHERE id_artist = '${id}'`;
    } else {
      query += `
        SELECT 
          id_artist,
          name,
          description,
          slug,
          url_cover,
          birthday,
          country,
          gender,
          created_at,
          last_update
        FROM Artist
        WHERE is_show = 1
        AND id_artist = '${id}'
      `;
    }

    const [artist]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: artist });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const PATCH = async (request: Request, context: any) => {
  try {
    const body = await request.json();
    const {
      name,
      description,
      slug,
      url_cover,
      birthday,
      country,
      gender,
      is_show,
    } = body;
    const { params } = context;
    const { id } = params;
    const id_artist = id;

    // Validation
    Checker.checkString(name);
    Checker.checkString(description);
    Checker.checkString(slug);
    Checker.checkString(url_cover);
    Checker.checkDate(birthday);
    Checker.checkString(country);
    Checker.checkIncluded(gender, ["male", "female"]);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug if slug is provided
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        "select id_artist from Artist where slug = ?",
        [slug, id_artist]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 400);
    }

    // Update DB
    const querySet = [];
    const queryParams = [];

    if (name) {
      querySet.push("name = ?");
      queryParams.push(name);
    }
    if (description) {
      querySet.push("description = ?");
      queryParams.push(description);
    }
    if (slug) {
      querySet.push("slug = ?");
      queryParams.push(slug);
    }
    if (url_cover) {
      querySet.push("url_cover = ?");
      queryParams.push(url_cover);
    }
    if (birthday) {
      querySet.push("birthday = ?");
      queryParams.push(birthday);
    }
    if (country) {
      querySet.push("country = ?");
      queryParams.push(country);
    }
    if (gender) {
      querySet.push("gender = ?");
      queryParams.push(gender);
    }
    if (is_show !== undefined) {
      querySet.push("is_show = ?");
      queryParams.push(is_show);
    }

    if (querySet.length === 0)
      throwCustomError("No valid fields to update", 400);

    queryParams.push(id_artist); // Push the ID at the end for the WHERE clause

    const [result]: Array<any> = await connection.query(
      `update Artist set ${querySet.join(", ")} where id_artist = ?`,
      queryParams
    );

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
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Delete artist from DB
    const [result]: Array<any> = await connection.query(
      "delete from Artist where id_artist = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      throwCustomError("Artist not found", 404);
    }

    return objectResponse({ message: "Deleted successfully" }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
