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
      id_music,
      name,
      slug,
      total_duration,
      producer,
      composer,
      is_show,
      id_type,
      id_artist,
    }: any = params;
    const queryParams: any[] = [];

    const query = `
    SELECT 
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
      count(mh.id_music_history) as view,
      count(fm.id_music) as favorite,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_artist', a.id_artist",
          "'name', a.name",
          "'slug', a.slug",
          "'url_cover', a.url_cover",
          "'created_at', a.created_at",
          "'last_update', a.last_update",
          "'is_show', a.is_show",
        ])
      )} AS artists,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_type', ty.id_type",
          "'name', ty.name",
          "'slug', ty.slug",
          "'created_at', ty.created_at",
          "'is_show', ty.is_show",
        ])
      )} AS types
    FROM 
      Music m
    LEFT JOIN 
      MusicArtistDetail mad 
        ON mad.id_music = m.id_music
    LEFT JOIN   
      Artist a 
        ON a.id_artist = mad.id_artist 
        ${role === "admin" ? "" : " AND a.is_show = 1"}
    LEFT JOIN 
      MusicTypeDetail mtd 
      ON mtd.id_music = m.id_music
    LEFT JOIN 
      Type ty 
        ON ty.id_type = mtd.id_type 
        ${role === "admin" ? "" : " AND ty.is_show = 1"}
    LEFT JOIN
      MusicHistory mh 
        ON mh.id_music = m.id_music
    LEFT JOIN
      FavoriteMusic fm
        on fm.id_music = m.id_music
    WHERE TRUE
    ${getByRole(role, "m.is_show")}

    ${getByEqual(id_type, "ty.id_type")}
    ${getByEqual(id_music, "m.id_music")}
    ${getByEqual(id_artist, "a.id_artist")}
    ${getByLike(name, "m.name")}
    ${getByLike(slug, "m.slug")}
    ${getByLike(composer, "m.composer")}
    ${getByLike(producer, "m.producer")}
    ${getByEqual(total_duration, "m.total_duration")}
    ${getByEqual(is_show, "m.is_show")}
    
    GROUP BY m.id_music

    ${getByLimitOffset(limit, offset, "m.created_at")}
    `;

    const [musicList]: Array<any> = await connection.query(query, queryParams);
    Parser.convertJson(musicList as Array<any>, "artists", "types");
    musicList.forEach((item: any, index: number) => {
      item.artists = Parser.removeNullObjects(item.artists);
      item.types = Parser.removeNullObjects(item.types);
    });
    return objectResponse({ data: musicList }, 200);
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
      url_cover,
      total_duration,
      producer,
      composer,
      release_date,
      is_show = 1,
      artists = [],
      types = [],
      lyrics = [],
    } = body;

    // Validation
    Checker.checkString(name, true);
    Checker.checkString(slug);
    Checker.checkString(url_path);
    Checker.checkString(url_cover);
    Checker.checkInteger(total_duration);
    Checker.checkString(producer);
    Checker.checkString(composer);
    Checker.checkDate(release_date);
    Checker.checkIncluded(is_show, [0, 1]);

    if (artists.length > 0) {
      const [artistList]: any[] = await connection.query(
        `select id_artist 
        from Artist 
        where 
        (${artists
          .map((artist: string) => {
            return `id_artist = '${artist}'`;
          })
          .join(" OR ")})`
      );
      if (artistList.length !== artists.length) {
        throwCustomError("Artist list error", 400);
      }
    }

    if (types.length > 0) {
      const [typeList]: any[] = await connection.query(
        `select id_type 
        from Type 
        where
        ${types
          .map((type: string) => {
            return `id_type = '${type}'`;
          })
          .join(" OR ")}`
      );
      if (typeList.length !== types.length) {
        throwCustomError("Type list error", 400);
      }
    }

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
          id_music,
          name,
          slug,
          url_path,
          url_cover,
          total_duration,
          producer,
          composer,
          release_date,
          is_show
        )  
      values 
        (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        newId,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        release_date,
        is_show,
      ]
    );

    // Add artists
    await Promise.all(
      artists.map(async (artist: string) => {
        await connection.query(
          `insert into MusicArtistDetail (id_artist, id_music) 
          values (?, ?)`,
          [artist, newId]
        );
      })
    );

    // Add types
    await Promise.all(
      types.map(async (type: string) => {
        await connection.query(
          `insert into MusicTypeDetail (id_type, id_music) 
          values (?, ?)`,
          [type, newId]
        );
      })
    );

    // Add lyrics
    await Promise.all(
      lyrics.map(async (lyric: any) => {
        await connection.query(
          `insert into Lyrics (id_music, lyrics, start_time, end_time) 
          values (?, ?, ?, ?)`,
          [newId, lyric.lyrics, lyric.start_time, lyric.end_time]
        );
      })
    );

    return objectResponse({ newID: newId }, 201);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
