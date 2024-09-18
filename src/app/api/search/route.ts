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
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const { limit, offset, searchText }: any = params;
    const queryParams: any[] = [];

    if (!searchText) throwCustomError("Missing searchText", 400);

    // Serach music
    const musicQuery = `
    SELECT 
      m.id_music,
      m.name,
      m.slug,
      m.total_duration,
      m.publish_time,
      m.release_date,
      m.created_at,
      m.last_update,
      m.is_show,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_lyrics', l.id_lyrics",
          "'txt', l.lyrics",
          "'start_time', l.start_time",
          "'end_time', l.end_time",
        ])
      )} AS lyrics
    FROM 
      Music m
    LEFT JOIN
      Lyrics l ON l.id_music = m.id_music
    WHERE
      (l.lyrics LIKE CONCAT('%', '${searchText}', '%')
      OR l.id_lyrics = '${searchText}'
      OR m.name LIKE CONCAT('%', '${searchText}', '%')
      OR m.id_music = '${searchText}')
      ${role === "admin" ? "" : "AND is_show = 1"}
    GROUP BY 
      m.id_music;
    ${limit !== undefined || offset !== undefined ? " ORDER BY m.id_music" : ""}
    ${limit !== undefined ? ` LIMIT ${limit}` : ""}
    ${offset !== undefined ? ` OFFSET ${offset}` : ""}
    `;
    const [musicList]: Array<any> = await connection.query(
      musicQuery,
      queryParams
    );
    Parser.convertJson(musicList as Array<any>, "lyrics");
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
      (name LIKE CONCAT('%', '${searchText}', '%')
      OR id_artist = '${searchText}')
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
      publish_date,
      publish_date,
      created_at,
      last_update,
      is_show
    FROM 
      Album
    WHERE   
      (name LIKE CONCAT('%', '${searchText}', '%')
      OR id_album = '${searchText}')
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
