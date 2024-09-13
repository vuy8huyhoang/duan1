import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const {
      limit,
      offset,
      name,
      slug,
      total_duration,
      publish_time,
      release_date,
      is_show,
    }: any = params;
    const queryParams: any[] = [];
    let query = "";

    if (role === "admin") {
      query += `
      SELECT 
        m.*,
        COUNT(mh.id_music_history) AS total_views
      FROM Music m
      LEFT JOIN MusicHistory mh ON m.id_music = mh.id_music
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
        COUNT(mh.id_music_history) AS total_views
      FROM Music m
      LEFT JOIN MusicHistory mh ON mh.id_music = m.id_music
      WHERE m.is_show = 1
      GROUP BY m.id_music;
      `;
    }

    // Add filtering conditions if provided
    const filters: string[] = [];
    if (name) {
      filters.push("name = ?");
      queryParams.push(name);
    }
    if (slug) {
      filters.push("slug = ?");
      queryParams.push(slug);
    }
    if (total_duration) {
      filters.push("total_duration = ?");
      queryParams.push(total_duration);
    }
    if (publish_time) {
      filters.push("publish_time = ?");
      queryParams.push(publish_time);
    }
    if (release_date) {
      filters.push("release_date = ?");
      queryParams.push(release_date);
    }
    if (is_show) {
      filters.push("is_show = ?");
      queryParams.push(is_show);
    }

    if (filters.length > 0) {
      query += ` AND ${filters.join(" AND ")}`;
    }

    // Add limit and offset only if provided
    if (limit !== undefined || offset !== undefined) {
      query += ` ORDER BY id_music`; // Ensure there's an ORDER BY clause
      if (limit !== undefined) {
        query += ` LIMIT ?`;
        queryParams.push(parseInt(limit, 10)); // Convert limit to integer
      }
      if (offset !== undefined) {
        query += ` OFFSET ?`;
        queryParams.push(parseInt(offset, 10)); // Convert offset to integer
      }
    }

    const [musicList]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: musicList });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
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

    // Validation
    Checker.checkString(name, true);
    Checker.checkString(slug);
    Checker.checkString(url_path, true);
    Checker.checkString(description);
    Checker.checkInteger(total_duration);
    Checker.checkDate(publish_time);
    Checker.checkDate(release_date);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        "select id_music from Music where slug = ?",
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
      insert into Music
        (
          id_music
          name,
          slug,
          url_path,
          description,
          total_duration,
          publish_time,
          release_date,
          is_show
        )  
      values 
        (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        newId,
        name,
        slug,
        url_path,
        description,
        total_duration,
        publish_time,
        release_date,
        is_show,
      ]
    );

    return objectResponse({ newID: newId });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
