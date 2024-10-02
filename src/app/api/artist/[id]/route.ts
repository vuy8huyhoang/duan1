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
    a.id_artist,
    a.name,
    a.slug,
    a.url_cover,
    a.created_at,
    a.last_update,
      COUNT(f.id_user) AS followers
    FROM Artist a
    LEFT JOIN Follow f ON a.id_artist = f.id_artist
    WHERE TRUE
    ${role === "admin" ? "" : "AND a.is_show = 1"}
    AND a.id_artist = '${id}'
    GROUP BY a.id_artist
    `;

    const [artist]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: artist[0] }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const PATCH = async (request: Request, context: any) => {
  try {
    const body = await request.json();
    const { name, slug, url_cover, is_show } = body;
    const { params } = context;
    const { id } = params;
    const id_artist = id;

    // Validation
    Checker.checkString(name);
    Checker.checkString(slug);
    Checker.checkString(url_cover);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug if slug is provided
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        `select id_artist from Artist where slug = ? and id_user <> '${currentUser.id_user}'`,
        [slug]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 409);
    }

    // Check Artist exist
    const [artistList]: any[] = await connection.query(
      "select id_artist from Artist where id_Artist = '" + id_artist + "'"
    );
    if (artistList.length === 0) throwCustomError("Artist not found", 400);

    // Update DB
    const querySet = [];
    const queryParams = [];

    if (name !== undefined) {
      querySet.push("name = ?");
      queryParams.push(name);
    }
    if (slug !== undefined) {
      querySet.push("slug = ?");
      queryParams.push(slug);
    }
    if (url_cover !== undefined) {
      querySet.push("url_cover = ?");
      queryParams.push(url_cover);
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

    if (result.affectedRows === 0) {
      throwCustomError("Artist not found", 404);
    }

    return objectResponse({ message: "Updated successfully" }, 200);
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
