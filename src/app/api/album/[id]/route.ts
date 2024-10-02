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
    const id_album = id;
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
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
      AND al.id_album = '${id_album}'
      GROUP BY al.id_album
    `;

    const [album]: Array<any> = await connection.query(query, queryParams);
    Parser.convertJson(album as Array<any>, "artist", "musics");
    album.forEach((item: any, index: number) => {
      item.artist = Parser.removeNullObjects(item.artist);
      item.artist = item.artist[0];
    });
    return objectResponse({ data: album[0] });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const PATCH = async (request: Request, context: any) => {
  try {
    const body = await request.json();
    const {
      id_artist,
      name,
      slug,
      url_cover,
      release_date,
      publish_by,
      is_show,
      musics = [],
    } = body;
    const { params } = context;
    const { id } = params;
    const id_album = id;

    // Validation
    Checker.checkString(id_artist);
    Checker.checkString(name);
    Checker.checkString(slug);
    Checker.checkString(url_cover);
    Checker.checkDate(release_date);
    Checker.checkString(publish_by);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug if slug is provided
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        `select id_album from Album where slug = ? and id_album <> ?`,
        [slug, id_album]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 400);
    }

    // Check existing album
    const [album]: any[] = await connection.query(
      "select id_album from Album where id_album = ?",
      [id_album]
    );
    if (album.length === 0) {
      throwCustomError("Album not found", 404);
    }

    // Update DB
    const querySet = [];
    const queryParams = [];

    if (id_artist !== undefined) {
      querySet.push("id_artist = ?");
      queryParams.push(id_artist);
    }
    if (name !== undefined) {
      querySet.push("name = ?");
      queryParams.push(name);
    }
    if (slug !== undefined) {
      queryParams.push("slug = ?");
      querySet.push(slug);
    }
    if (url_cover !== undefined) {
      queryParams.push("url_cover = ?");
      querySet.push(url_cover);
    }
    if (release_date !== undefined) {
      querySet.push("release_date = ?");
      queryParams.push(release_date);
    }
    if (publish_by !== undefined) {
      queryParams.push("publish_by = ?");
      querySet.push(publish_by);
    }
    if (is_show !== undefined) {
      querySet.push("is_show = ?");
      queryParams.push(is_show);
    }

    if (querySet.length === 0)
      throwCustomError("No valid fields to update", 400);

    queryParams.push(id_album); // Push the ID at the end for the WHERE clause

    const [result]: Array<any> = await connection.query(
      `update Album set ${querySet.join(", ")} where id_album = ?`,
      queryParams
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

    // Delete Album from DB
    const [result]: Array<any> = await connection.query(
      "delete from Album where id_album = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      throwCustomError("Album not found", 404);
    }

    return objectResponse({ message: "Deleted successfully" }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
