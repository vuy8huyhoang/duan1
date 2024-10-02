import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getCurrentUser } from "@/utils/Get";
import { objectResponse } from "@/utils/Response";

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const currentUser = await getCurrentUser(request, true);
    const { id_music, id_playlist, index_order } = body;
    const id_user = currentUser.id_user;

    // Validate
    Checker.checkString(id_music, true);
    Checker.checkString(id_playlist, true);
    Checker.checkInteger(index_order);

    // Check followed artist
    const [favoriteResult]: any[] = await connection.query(
      `select id_music from MusicPlaylistDetail where id_playlist = '${id_playlist}' and id_music = '${id_music}'`
    );
    if (favoriteResult.length !== 0)
      throwCustomError("The music is already in your playlist", 400);

    // Check existing music
    const [music]: any[] = await connection.query(
      `select id_music from Music where id_music = '${id_music}'`
    );
    if (music.length === 0) throwCustomError("Music not found", 404);

    // Check existing playlist
    const [playlist]: any[] = await connection.query(
      `select id_playlist from Playlist where id_playlist = ? and id_user = ?`,
      [id_playlist, id_user]
    );
    if (playlist.length === 0) throwCustomError("Playlist not found", 404);

    // Update DB
    const [result] = await connection.query(
      `
        insert into MusicPlaylistDetail (id_music, id_playlist, index_order) 
        values ('${id_user}', '${id_music}', '${index_order}')
      `,
      []
    );

    return objectResponse(
      { message: "Add music to playlist successfully" },
      201
    );
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const DELETE = async (request: Request) => {
  try {
    const body = await request.json();
    const currentUser = await getCurrentUser(request, true);
    const { id_music, id_playlist } = body;
    const id_user = currentUser.id_user;

    // Validate
    Checker.checkString(id_music, true);
    Checker.checkString(id_playlist, true);

    // Check existing music
    const [music]: any[] = await connection.query(
      `select id_music from Music where id_music = '${id_music}'`
    );
    if (music.length === 0) throwCustomError("Music not found", 404);

    // Check existing playlist
    const [playlist]: any[] = await connection.query(
      `select id_playlist from Playlist where id_playlist = '${id_playlist}'`
    );
    if (playlist.length === 0) throwCustomError("Playlist not found", 404);

    // Check music - playlist
    const [musicList]: any[] = await connection.query(
      `select id_music from MusicPlaylistDetail where id_music = '${id_music}' and id_playlist = '${id_playlist}'`
    );
    if (musicList.length === 0)
      throwCustomError("Music is not in the playlist ", 400);

    // Update DB
    const [result] = await connection.query(
      `
        delete from MusicPlaylistDetail 
        where id_music = '${id_music}' and id_playlist = '${id_playlist}'
      `,
      []
    );

    return objectResponse(
      { message: "Remove music from playlist successfully" },
      201
    );
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
