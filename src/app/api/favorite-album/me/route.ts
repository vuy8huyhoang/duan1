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
      fa.last_update as favor_at,
      al.id_album,
      al.name,
      al.slug,
      al.url_cover,
      al.release_date,
      al.publish_by,
      al.last_update,
      al.is_show,
      ${Parser.queryObject([
        "'id_artist', ar.id_artist",
        "'name', ar.name",
        "'slug', ar.slug",
        "'url_cover', ar.url_cover",
        "'created_at', ar.created_at",
        "'last_update', ar.last_update",
        "'is_show', ar.is_show",
      ])} as artist
    FROM FavoriteAlbum fa
    LEFT JOIN
      Album al
        on al.id_album = fa.id_album
        ${role === "admin" ? "" : "AND al.is_show = 1"}
    LEFT JOIN
      Artist ar
        on ar.id_artist = al.id_artist
        ${role === "admin" ? "" : "AND ar.is_show = 1"}
    WHERE TRUE
      AND fa.id_user = '${id_user}'
      ${getByRole(role, "al.is_show")}
      ${getByEqual(id_music, "fa.id_music")}
      ${getByLimitOffset(limit, offset, "fa.last_update")}
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
    const { id_album } = body;
    const id_user = currentUser.id_user;

    // Validate
    Checker.checkString(id_album, true);

    // Check followed artist
    const [favoriteResult]: any[] = await connection.query(
      `select id_user from FavoriteAlbum where id_user = '${id_user}' and id_album = '${id_album}'`
    );
    if (favoriteResult.length !== 0)
      throwCustomError("The album is already in your favorites", 400);

    // Check existing album
    const [album]: any[] = await connection.query(
      `select id_album from Album where id_album = '${id_album}'`
    );
    if (album.length === 0) throwCustomError("Album not found", 404);

    // Update DB
    const [result] = await connection.query(
      `
      insert into FavoriteAlbum (id_user, id_album) 
      values ('${id_user}', '${id_album}')
    `,
      []
    );

    return objectResponse({ message: "Album favorited successfully" }, 201);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const DELETE = async (request: Request) => {
  try {
    const body = await request.json();
    const currentUser = await getCurrentUser(request, true);
    const { id_album } = body;
    const id_user = currentUser.id_user;

    // Validate
    Checker.checkString(id_album, true);

    // Check existing album
    const [album]: any[] = await connection.query(
      `select id_album from Album where id_album = '${id_album}'`
    );
    if (album.length === 0) throwCustomError("Album not found", 404);

    // Check followed artist
    const [favoriteResult]: any[] = await connection.query(
      `select id_user from FavoriteAlbum where id_user = '${id_user}' and id_album = '${id_album}'`
    );
    if (favoriteResult.length === 0)
      throwCustomError("The album is already unfavorited", 400);

    // Update DB
    const [result] = await connection.query(
      `
      delete from FavoriteAlbum 
      where id_user = '${id_user}' and id_album = '${id_album}'
    `,
      []
    );

    return objectResponse({ message: "Album unfavorited successfully" }, 201);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
