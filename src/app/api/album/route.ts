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
import Parser from "@/utils/Parser";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const {
      limit,
      offset,
      id_album,
      id_artist,
      name,
      slug,
      publish_by,
      is_show,
    }: any = params;
    const queryParams: any[] = [];

    const query = `
    SELECT 
      al.id_album,
      al.name,
      al.slug,
      al.url_cover,
      al.release_date,
      al.created_at,
      al.last_update,
      al.is_show,
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
      )} AS artist,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_music', m.id_music",
          "'name', m.name",
          "'slug', m.slug",
          "'url_path', m.url_path",
          "'url_cover', m.url_cover",
          "'total_duration', m.total_duration",
          "'producer', m.producer",
          "'composer', m.composer",
          "'release_date', m.release_date",
          "'created_at', m.created_at",
          "'last_update', m.last_update",
          "'is_show', m.is_show",
        ])
      )} AS musics
    FROM Album al
    LEFT JOIN 
      Artist ar ON ar.id_artist = al.id_artist ${
        role === "admin" ? "" : " AND ar.is_show = 1"
      }
    LEFT JOIN
      MusicAlbumDetail mald ON mald.id_album = al.id_album
    LEFT JOIN
      Music m on m.id_music = mald.id_music
    WHERE TRUE
      ${getByRole(role, "al.is_show")}
        
      ${getByEqual(id_album, "al.id_album")}
      ${getByEqual(id_artist, "al.id_artist")}
      ${getByLike(name, "al.name")}
      ${getByLike(slug, "al.slug")}
      ${getByLike(publish_by, "al.publish_by")}
      ${getByEqual(is_show, "al.is_show")}
      
      GROUP BY al.id_album
      
      ${getByLimitOffset(limit, offset, "al.created_at")}
    `;

    const [albumList]: Array<any> = await connection.query(query, queryParams);
    Parser.convertJson(albumList as Array<any>, "artist", "musics");
    albumList.forEach((item: any, index: number) => {
      item.artist = Parser.removeNullObjects(item.artist);
      item.artist = item.artist[0] || {};
    });
    return objectResponse({ data: albumList });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const {
      id_artist,
      name,
      slug,
      url_cover,
      release_date,
      publish_by,
      is_show = 1,
      musics = [],
    } = body;

    // Validation
    Checker.checkString(id_artist);
    Checker.checkString(name, true);
    Checker.checkString(slug);
    Checker.checkString(url_cover);
    Checker.checkDate(release_date);
    Checker.checkString(publish_by);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        "select id_album from Album where slug = ?",
        [slug]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 409);
    }
    if (slug === "") throwCustomError("Slug cannot be empty string", 400);

    // check exist artist
    if (id_artist) {
      const [artistList]: Array<any> = await connection.query(
        `select id_artist from Artist where id_artist = '${id_artist}'`
      );
    }

    // Update DB
    const newId = uuidv4();
    const [result]: Array<any> = await connection.query(
      `
      insert into Album
        (
          id_album,
          id_artist,
          name,
          slug,
          url_cover,
          release_date,
          publish_by,
          is_show
        )  
      values 
        (?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        newId,
        id_artist,
        name,
        slug,
        url_cover,
        release_date,
        publish_by,
        is_show,
      ]
    );

    if (musics.length > 0) {
      await Promise.all(
        musics.map(async (music: any) => {
          await connection.query(
            `insert into MusicAlbumDetail(id_music, id_album, index_order) 
            values (?, ?, ?)`,
            [music.id_music, newId, music.index_order || 0]
          );
        })
      );
    }

    return objectResponse({ newID: newId });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
