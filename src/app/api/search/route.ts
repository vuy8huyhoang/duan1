import connection from "@/lib/connection";
import { getByLimitOffset, getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import Parser from "@/utils/Parser";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const { limit, offset, search_text }: any = params;
    const queryParams: any[] = [];

    if (!search_text) throwCustomError("Missing search_text", 400);

    // search music
    const musicQuery = `
    SELECT 
      m.id_music,
      m.name,
      m.slug,
      m.total_duration,
      m.release_date,
      m.created_at,
      m.last_update,
      m.is_show,
      (select count(*) from MusicHistory mh where mh.id_music = m.id_music) as view,
      (select count(*) from FavoriteMusic fm where fm.id_music = m.id_music) as favorite,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_lyrics', l.id_lyrics",
          "'txt', l.lyrics",
          "'start_time', l.start_time",
          "'end_time', l.end_time",
        ])
      )} AS lyrics,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_type', ty.id_type",
          "'name', ty.name",
          "'slug', ty.slug",
          "'created_at', ty.created_at",
          "'is_show', ty.is_show",
        ])
      )} AS types,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_artist', art.id_artist",
          "'name', art.name",
          "'slug', art.slug",
          "'url_cover', art.url_cover",
          "'created_at', art.created_at",
          "'last_update', art.last_update",
          "'is_show', art.is_show",
        ])
      )} AS artists
    FROM 
      Music m
    LEFT JOIN
      Lyrics l ON l.id_music = m.id_music
    LEFT JOIN
      MusicArtistDetail mad
        on mad.id_music = m.id_music
    LEFT JOIN
      Artist art
        on art.id_artist = mad.id_artist
    LEFT JOIN
      MusicTypeDetail mtd
        on mtd.id_music = m.id_music
    LEFT JOIN
      Type ty
        on ty.id_type = mtd.id_type
    WHERE
      (l.lyrics LIKE CONCAT('%', '${search_text}', '%')
      OR l.id_lyrics = '${search_text}'
      OR m.name LIKE CONCAT('%', '${search_text}', '%')
      OR m.id_music = '${search_text}')
      ${role === "admin" ? "" : "AND m.is_show = 1"}
    GROUP BY 
      m.id_music
    ${getByLimitOffset(limit, offset, "m.created_at")}
    `;
    const [musicList]: Array<any> = await connection.query(
      musicQuery,
      queryParams
    );
    Parser.convertJson(musicList as Array<any>, "lyrics", "types", "artists");
    musicList.forEach((item: any, index: number) => {
      item.lyrics = Parser.removeNullObjects(item.lyrics);
    });

    const artistQuery = `
    SELECT
      id_artist,
      name,
      slug,
      url_cover,
      created_at,
      last_update,
      is_show
    FROM 
      Artist
    WHERE   
      (name LIKE CONCAT('%', '${search_text}', '%')
      OR id_artist = '${search_text}')
      ${role === "admin" ? "" : "AND is_show = 1"}
    ${
      limit !== undefined || offset !== undefined ? " ORDER BY a.id_artist" : ""
    }
    ${limit !== undefined ? ` LIMIT ${limit}` : ""}
    ${offset !== undefined ? ` OFFSET ${offset}` : ""}
    `;
    const [artistList]: Array<any> = await connection.query(
      artistQuery,
      queryParams
    );

    const albumQuery = `
    SELECT
      id_album,
      id_artist,
      name,
      slug,
      url_cover,
      release_date,
      created_at,
      last_update,
      is_show
    FROM 
      Album
    WHERE   
      (name LIKE CONCAT('%', '${search_text}', '%')
      OR id_album = '${search_text}')
      ${role === "admin" ? "" : "AND is_show = 1"}
    ${limit !== undefined || offset !== undefined ? " ORDER BY a.id_album" : ""}
    ${limit !== undefined ? ` LIMIT ${limit}` : ""}
    ${offset !== undefined ? ` OFFSET ${offset}` : ""}
    `;
    const [albumList]: Array<any> = await connection.query(
      albumQuery,
      queryParams
    );

    return objectResponse({ data: { musicList, artistList, albumList } });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
