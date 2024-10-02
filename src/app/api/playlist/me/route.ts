import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getByEqual, getByLimitOffset, getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";
import Parser from "@/utils/Parser";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, true);
    const role = currentUser.role;
    const { id_playlist }: any = params;
    const queryParams: any[] = [];
    const id_user = currentUser.id_user;

    const query = `
    SELECT 
      p.id_playlist,
      p.name,
      p.playlist_index,
      p.created_at,
      p.last_update,
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
    FROM Playlist p
    LEFT JOIN MusicPlaylistDetail mpd
      ON p.id_playlist = mpd.id_playlist
    LEFT JOIN Music m
      on m.id_music = mpd.id_music
      ${role === "admin" ? "" : "AND m.is_show = 1"}
    WHERE TRUE
      AND id_user = '${id_user}'
      ${getByEqual(id_playlist, "p.id_playlist")}
    `;

    const [playlistList]: Array<any> = await connection.query(
      query,
      queryParams
    );
    Parser.convertJson(playlistList as Array<any>, "musics");
    playlistList.forEach((item: any, index: number) => {
      item.musics = Parser.removeNullObjects(item.musics);
      item.musics = item.musics[0] || {};
    });
    return objectResponse({ data: playlistList });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const { name, playlist_index } = body;

    // Validation
    Checker.checkString(name, true);
    Checker.checkInteger(playlist_index);

    // Check permission
    const currentUser = await getCurrentUser(request);
    const id_user = currentUser.id_user;

    // Update DB
    const newId = uuidv4();
    const [result]: Array<any> = await connection.query(
      `
      insert into Playlist
        (
          id_playlist,
          id_user,
          name,
          playlist_index
        )  
      values 
        (?, ?, ?, ?)
      `,
      [newId, id_user, name, playlist_index]
    );

    return objectResponse({ newID: newId });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const PATCH = async (request: Request) => {
  try {
    const body = await request.json();
    const { name, playlist_index, id_playlist } = body;

    // Validation
    Checker.checkString(id_playlist, true);
    Checker.checkString(name);
    Checker.checkInteger(playlist_index);

    // Check permission
    const currentUser = await getCurrentUser(request, true);
    const id_user = currentUser.id_user;

    // Update DB
    const querySet = [];
    const queryParams = [];

    if (name !== undefined) {
      querySet.push("name = ?");
      queryParams.push(name);
    }
    if (playlist_index !== undefined) {
      querySet.push("playlist_index = ?");
      queryParams.push(playlist_index);
    }

    if (querySet.length === 0)
      throwCustomError("No valid fields to update", 400);

    queryParams.push(id_playlist);
    queryParams.push(id_user);

    // Update db
    const [result]: Array<any> = await connection.query(
      `update Playlist set ${querySet.join(
        ", "
      )} where id_playlist = ? and id_user = ?`,
      queryParams
    );

    if (result.affectedRows === 0) {
      throwCustomError("Playlist not found", 404);
    }

    return objectResponse({ success: "Updated successfully" }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const DELETE = async (request: Request) => {
  try {
    const body = await request.json();
    const { id_playlist } = body;

    // Validation
    Checker.checkString(id_playlist, true);

    // Check permission
    const currentUser = await getCurrentUser(request, true);
    const id_user = currentUser.id_user;

    // Delete Playlist from DB
    const [result]: Array<any> = await connection.query(
      "delete from Playlist where id_playlist = ? and id_user = ?",
      [id_playlist, id_user]
    );

    if (result.affectedRows === 0) {
      throwCustomError("Playlist not found", 404);
    }

    return objectResponse({ message: "Deleted successfully" }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
