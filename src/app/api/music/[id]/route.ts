import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getByRole, getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { objectResponse } from "@/utils/Response";
import Parser from "@/utils/Parser";

export const GET = async (request: Request, context: any) => {
  try {
    const { params } = context;
    const { id } = params;
    const id_music = id;
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const queryParams: any[] = [];
    let query = `
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
      )} AS types,
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
      MusicArtistDetail mad ON mad.id_music = m.id_music
    LEFT JOIN   
      Artist a ON a.id_artist = mad.id_artist
    LEFT JOIN 
      MusicTypeDetail mtd ON mtd.id_music = m.id_music
    LEFT JOIN 
      Type ty ON ty.id_type = mtd.id_type
    LEFT JOIN 
      Lyrics l ON l.id_music = m.id_music
    WHERE TRUE
    AND m.id_music = '${id_music}'
    ${getByRole(role, "m.is_show")}
    GROUP BY m.id_music
    `;

    const [music]: Array<any> = await connection.query(query, queryParams);

    Parser.convertJson(music as Array<any>, "artists", "types", "lyrics");
    music.forEach((item: any, index: number) => {
      item.artists = Parser.removeNullObjects(item.artists);
      item.types = Parser.removeNullObjects(item.types);
      item.lyrics = Parser.removeNullObjects(item.lyrics);
    });

    return objectResponse({ data: music[0] });
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
      url_cover,
      total_duration,
      producer,
      composer,
      release_date,
      is_show,
      artists = [],
      types = [],
      lyrics = [],
    } = body;
    const { params } = context;
    const { id } = params;
    const id_music = id;

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

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug if slug is provided
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        `select id_music from Music where slug = ? and id_user <> '${currentUser.id_user}'`,
        [slug, id_music]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 409);
    }

    // Check music exist
    const [musicList]: any[] = await connection.query(
      "select id_music from Music where id_music = '" + id_music + "'"
    );
    if (musicList.length === 0) throwCustomError("Music not found", 400);

    // Update artist
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

    // Update type
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

    // Update DB
    const querySet = [];
    const queryParams = [];

    if (name !== undefined) {
      querySet.push("name = ?");
      queryParams.push(name);
    }
    if (slug !== undefined) {
      querySet.push("slug = ?");
      queryParams.push(slug);
    }
    if (url_path !== undefined) {
      querySet.push("url_path = ?");
      queryParams.push(url_path);
    }
    if (url_cover !== undefined) {
      querySet.push("url_cover = ?");
      queryParams.push(url_cover);
    }
    if (total_duration !== undefined) {
      querySet.push("total_duration = ?");
      queryParams.push(total_duration);
    }
    if (producer !== undefined) {
      querySet.push("producer = ?");
      queryParams.push(producer);
    }
    if (composer !== undefined) {
      querySet.push("composer = ?");
      queryParams.push(composer);
    }
    if (release_date !== undefined) {
      querySet.push("release_date = ?");
      queryParams.push(release_date);
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

    // Delete old data
    await connection.query("delete from Lyrics where id_music = ?", id_music);
    await connection.query(
      "delete from MusicTypeDetail where id_music = ?",
      id_music
    );
    await connection.query(
      "delete from MusicArtistDetail where id_music = ?",
      id_music
    );

    // Add artists
    await Promise.all(
      artists.map(async (artist: string) => {
        await connection.query(
          `insert into MusicArtistDetail (id_artist, id_music) 
          values (?, ?)`,
          [artist, id_music]
        );
      })
    );

    // Add types
    await Promise.all(
      types.map(async (type: string) => {
        await connection.query(
          `insert into MusicTypeDetail (id_type, id_music) 
          values (?, ?)`,
          [type, id_music]
        );
      })
    );

    // Add lyrics
    await Promise.all(
      lyrics.map(async (lyric: any) => {
        await connection.query(
          `insert into Lyrics (id_music, lyrics, start_time, end_time) 
          values (?, ?, ?, ?)`,
          [id_music, lyric.lyrics, lyric.start_time, lyric.end_time]
        );
      })
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
