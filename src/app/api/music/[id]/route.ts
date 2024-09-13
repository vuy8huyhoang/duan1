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
      query += `
      SELECT 
        m.*,
        COUNT(mh.id_music_history) AS total_views
      FROM Music m
      LEFT JOIN MusicHistory mh ON m.id_music = mh.id_music
      AND m.id_music = '${id}'
      GROUP BY m.id_music;
      `;
    } else if (role === "membership") {
      query += `
        SELECT 
          m.id_music,
          m.name,
          m.slug,
          m.url_path,
          m.description,
          m.total_duration,
          m.publish_time,
          m.release_date,
          m.created_at,
          m.last_update,
          COUNT(mh.id_music_history) AS total_views
        FROM Music m
        LEFT JOIN MusicHistory mh ON m.id_music = mh.id_music
        WHERE m.is_show = 1
        AND m.id_music = '${id}'
        GROUP BY m.id_music;
      `;
    } else {
      query += `
      SELECT 
        m.id_music,
        m.name,
        m.slug,
        CASE 
          WHEN m.membership_permission = 1 THEN m.url_path
          ELSE NULL
        END AS url_path,
        m.description,
        m.total_duration,
        m.publish_time,
        m.release_date,
        m.created_at,
        m.last_update,
        COUNT(mh.id) AS total_views
      FROM Music m
      LEFT JOIN MusicHistory mh ON mh.id_music = m.id_music
      WHERE m.is_show = 1
      AND m.id_music = '${id}'
      GROUP BY m.id_music;
  `;
    }

    const [music]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: music });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const PATCH = async (request: Request, context: any) => {
  try {
    const body = await request.json();
    const {
      name,
      slug,
      url_path,
      description,
      total_duration,
      publish_time,
      release_date,
      is_show,
    } = body;
    const { params } = context;
    const { id } = params;
    const id_music = id;

    // Validation
    Checker.checkString(name);
    Checker.checkString(description);
    Checker.checkString(slug);
    Checker.checkString(url_path);
    Checker.checkInteger(total_duration);
    Checker.checkDate(publish_time);
    Checker.checkDate(release_date);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug if slug is provided
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        "select id_music from Music where slug = ?",
        [slug, id_music]
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
    if (url_path) {
      querySet.push("url_path = ?");
      queryParams.push(url_path);
    }
    if (total_duration) {
      querySet.push("total_duration = ?");
      queryParams.push(total_duration);
    }
    if (release_date) {
      querySet.push("release_date = ?");
      queryParams.push(release_date);
    }
    if (publish_time) {
      querySet.push("publish_time = ?");
      queryParams.push(publish_time);
    }
    if (is_show !== undefined) {
      querySet.push("is_show = ?");
      queryParams.push(is_show);
    }

    if (querySet.length === 0)
      throwCustomError("No valid fields to update", 400);

    queryParams.push(id_music); // Push the ID at the end for the WHERE clause

    const [result]: Array<any> = await connection.query(
      `update Music set ${querySet.join(", ")} where id_music = ?`,
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

    // Delete music from DB
    const [result]: Array<any> = await connection.query(
      "delete from Music where id_music = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      throwCustomError("Music not found", 404);
    }

    return objectResponse({ message: "Deleted successfully" }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
