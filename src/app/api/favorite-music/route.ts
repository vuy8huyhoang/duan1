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
    const { limit, offset, id_music, last_update, id_favorite_music }: any =
      params;
    const queryParams: any[] = [];

    const id_user = currentUser.id_user;

    const query = `
    SELECT 
      fm.id_favorite_music,
      fm.last_update,
      ${Parser.queryObject([
        "'id_music', m.id_music",
        "'name', m.name",
        "'slug', m.slug",
        "'total_duration', m.total_duration",
        "'publish_time', m.publish_time",
        "'release_date', m.release_date",
        "'last_update', m.last_update",
        "'membership_permission', m.membership_permission",
        "'is_show', m.is_show",
      ])} as music
    FROM FavoriteMusic fm
    LEFT JOIN
      Music m 
        on m.id_music = fm.id_music
        ${role === "admin" ? "" : "AND m.is_show = 1"}
    WHERE TRUE
      AND fm.id_user = '${id_user}'
      ${id_music !== undefined ? `AND fm.id_music = '${id_music}'` : ""}
      ${
        id_favorite_music !== undefined
          ? `AND fm.id_favorite_music = '${id_favorite_music}'`
          : ""
      }
      ${
        last_update !== undefined ? `AND fm.last_update = '${last_update}'` : ""
      }

      ${limit !== undefined ? ` LIMIT ${limit}` : ""}
      ${offset !== undefined ? ` OFFSET ${offset}` : ""}
    `;

    return objectResponse(query);

    const [favoriteMusic]: Array<any> = await connection.query(
      query,
      queryParams
    );
    Parser.convertJson(favoriteMusic as Array<any>, "music");
    // favoriteMusic.forEach((item: any, index: number) => {
    //   item.music = Parser.removeNullObjects(item.music);
    //   if (item.music.length !== 0) item.music = item.music[0];
    // });
    return objectResponse({
      data: favoriteMusic,
    });
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
