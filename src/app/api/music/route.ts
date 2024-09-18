import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";
import Parser from "@/utils/Parser";
import { getVariableName } from "@/utils/String";

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
      description,
      id_type,
      id_artist,
    }: any = params;
    const queryParams: any[] = [];

    const query = `
    SELECT 
      m.id_music,
      m.name,
      m.slug,
      ${
        role === "user"
          ? "m.url_path"
          : `
      CASE 
        WHEN m.membership_permission = 1 THEN m.url_path
        ELSE NULL
      END AS url_path`
      },
      m.total_duration,
      m.publish_time,
      m.release_date,
      m.created_at,
      m.last_update,
      m.membership_permission,
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
      Artist a ON a.id_artist = mad.id_artist ${
        role === "admin" ? "" : " AND a.is_show = 1"
      }
    LEFT JOIN 
      MusicTypeDetail mtd ON mtd.id_music = m.id_music
    LEFT JOIN 
      Type ty ON ty.id_type = mtd.id_type ${
        role === "admin" ? "" : " AND ty.is_show = 1"
      }
    LEFT JOIN 
      Lyrics l ON l.id_music = m.id_music
    WHERE TRUE
    ${role === "admin" ? "" : "AND m.is_show = 1"}

    ${(id_type !== undefined && `AND ty.id_type LIKE '%${id_type}%'`) || ""}
    ${
      (id_artist !== undefined && `AND a.id_artist LIKE '%${id_artist}%'`) || ""
    }
    ${(name !== undefined && `AND m.name LIKE '%${name}%'`) || ""}
    ${(slug !== undefined && `AND m.slug LIKE '%${slug}%'`) || ""}
    ${
      (description !== undefined &&
        `AND m.description LIKE '%${description}%'`) ||
      ""
    }
    ${
      (total_duration !== undefined &&
        `AND m.total_duration LIKE '%${total_duration}%'`) ||
      ""
    }
    ${
      (publish_time !== undefined &&
        `AND m.publish_time LIKE '%${publish_time}%'`) ||
      ""
    }
    ${
      (release_date !== undefined &&
        `AND m.release_date LIKE '%${release_date}%'`) ||
      ""
    }
    ${(is_show !== undefined && `AND m.is_show LIKE '%${is_show}%'`) || ""}
    GROUP BY m.id_music
    ${limit !== undefined || offset !== undefined ? " ORDER BY m.id_music" : ""}
    ${limit !== undefined ? ` LIMIT ${limit}` : ""}
    ${offset !== undefined ? ` OFFSET ${offset}` : ""}
    `;

    const [musicList]: Array<any> = await connection.query(query, queryParams);
    Parser.convertJson(musicList as Array<any>, "artists", "types", "lyrics");
    musicList.forEach((item: any, index: number) => {
      item.artists = Parser.removeNullObjects(item.artists);
      item.types = Parser.removeNullObjects(item.types);
      item.lyrics = Parser.removeNullObjects(item.lyrics);
    });
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
