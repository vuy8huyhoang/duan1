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
    const {
      limit,
      offset,
      id_music_history,
      id_music,
      play_duration,
      start_date,
      end_date,
    }: any = params;
    const queryParams: any[] = [];

    // Check permisstion
    const id_user = currentUser.id_user;
    if (role !== "admin" && currentUser.id_user !== id_user)
      throwCustomError("Not enough permission", 401);

    const query = `
    SELECT 
      mh.id_music_history,
      mh.play_duration,
      mh.created_at,
      mh.id_music
    FROM MusicHistory mh
    WHERE TRUE
        
      ${
        (id_music_history !== undefined &&
          `AND id_music_history LIKE '%${id_music_history}%'`) ||
        ""
      }
      ${(id_user !== undefined && `AND id_user LIKE '%${id_user}%'`) || ""}
      ${(id_music !== undefined && `AND id_music LIKE '%${id_music}%'`) || ""}
      ${
        (play_duration !== undefined &&
          `AND id_music_history LIKE '%${id_music_history}%'`) ||
        ""
      }
      ${start_date !== undefined ? `AND mh.created_at >= '${start_date}'` : ""}
      ${end_date !== undefined ? `AND mh.created_at <= '${end_date}'` : ""}

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
