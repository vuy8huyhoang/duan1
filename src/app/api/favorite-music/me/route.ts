import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import {
  getByEqual,
  getByLimitOffset,
  getByRole,
  getCurrentUser,
} from "@/utils/Get";
import Parser from "@/utils/Parser";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, true);
    const role = currentUser.role;
    const { limit, offset, id_music }: any = params;
    const queryParams: any[] = [];
    const id_user = currentUser.id_user;

    const query = `
    SELECT 
        fm.last_update as favor_at,
        m.id_music,
        m.name,
        m.slug,
        m.url_path,
        m.url_cover,
        m.total_duration,
        m.producer,
        m.composer,
        m.release_date,
        m.created_at,
        m.last_update,
        m.is_show,
        ${Parser.queryArray(
          Parser.queryObject([
            "'id_artist', ar.id_artist",
            "'name', ar.name",
            "'slug', ar.slug",
            "'url_cover', ar.url_cover",
            "'created_at', ar.created_at",
            "'last_update', ar.last_update",
            "'is_show', ar.is_show",
          ])
        )} as artist
    FROM FavoriteMusic fm
    LEFT JOIN
        Music m on m.id_music = fm.id_music
    LEFT JOIN
        MusicArtistDetail mad on mad.id_music = m.id_music
    LEFT JOIN
        Artist ar on ar.id_artist = mad.id_artist
    LEFT JOIN
        MusicTypeDetail mtd on mtd.id_music = m.id_music
    LEFT JOIN
        Type ty on ty.id_type = mtd.id_type      
    WHERE TRUE
        AND fm.id_user = '${id_user}'
        ${getByRole(role, "m.is_show")}
        ${getByEqual(id_music, "fm.id_music")}
        ${getByLimitOffset(limit, offset, "fm.last_update")}
    GROUP BY 
        fm.last_update, m.id_music
    `;

    const [favoriteMusic]: Array<any> = await connection.query(
      query,
      queryParams
    );
    Parser.convertJson(favoriteMusic as Array<any>, "artist");
    // favoriteMusic.data.map((item: any) => {});
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
    const currentUser = await getCurrentUser(request, true);
    const { id_music } = body;
    const id_user = currentUser.id_user;

    // Validate
    Checker.checkString(id_music, true);

    // Check followed artist
    const [favoriteResult]: any[] = await connection.query(
      `select id_user from FavoriteMusic where id_user = '${id_user}' and id_music = '${id_music}'`
    );
    if (favoriteResult.length !== 0)
      throwCustomError("The music is already in your favorites", 400);

    // Check existing music
    const [music]: any[] = await connection.query(
      `select id_music from Music where id_music = '${id_music}'`
    );
    if (music.length === 0) throwCustomError("Music not found", 404);

    // Update DB
    const [result] = await connection.query(
      `
      insert into FavoriteMusic (id_user, id_music) 
      values ('${id_user}', '${id_music}')
    `,
      []
    );

    return objectResponse({ message: "Music favorited successfully" }, 201);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const DELETE = async (request: Request) => {
  try {
    const body = await request.json();
    const currentUser = await getCurrentUser(request, true);
    const { id_music } = body;
    const id_user = currentUser.id_user;

    // Validate
    Checker.checkString(id_music, true);

    // Check existing music
    const [music]: any[] = await connection.query(
      `select id_music from Music where id_music = '${id_music}'`
    );
    if (music.length === 0) throwCustomError("Music not found", 404);

    // Check followed artist
    const [favoriteResult]: any[] = await connection.query(
      `select id_user from FavoriteMusic where id_user = '${id_user}' and id_music = '${id_music}'`
    );
    if (favoriteResult.length === 0)
      throwCustomError("The music is already unfavorited", 400);

    // Update DB
    const [result] = await connection.query(
      `
      delete from FavoriteMusic 
      where id_user = '${id_user}' and id_music = '${id_music}'
    `,
      []
    );

    return objectResponse({ message: "Music unfavorited successfully" }, 201);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
