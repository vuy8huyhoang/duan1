import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getByEqual, getByLimitOffset, getCurrentUser } from "@/utils/Get";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, true);
    const role = currentUser.role;
    const { limit, offset, id_music_history, id_music, play_duration }: any =
      params;
    const queryParams: any[] = [];

    // Check permisstion
    const id_user = currentUser.id_user;
    if (role !== "admin" && currentUser.id_user !== id_user)
      throwCustomError("Not enough permission", 401);

    const query = `
    SELECT 
      mh.id_music_history,
      mh.play_duration,
      mh.created_at,
      mh.id_music
    FROM MusicHistory mh
    WHERE TRUE
      AND id_user = '${id_user}'
      ${getByEqual(id_music_history, "mh.id_music_history")}
      ${getByEqual(id_music, "mh.id_music")}
      ${getByEqual(play_duration, "mh.play_duration")}
      ${getByLimitOffset(limit, offset, "mh.created_at")}
    `;

    const [typeList]: Array<any> = await connection.query(query, queryParams);

    return objectResponse({ data: typeList });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const { id_music, play_duration } = body;

    // Validation
    Checker.checkString(id_music, true);
    Checker.checkInteger(play_duration);

    // Check exist id_music
    const [music]: any[] = await connection.query(
      `select id_music 
      from Music 
      where id_music = ?`,
      [id_music]
    );
    if (music.length === 0) {
      throwCustomError("Music not found", 404);
    }

    // Check permission
    const currentUser = await getCurrentUser(request);
    const id_user = currentUser.id_user;

    // Update DB
    const newId = uuidv4();
    const [result]: Array<any> = await connection.query(
      `
      insert into MusicHistory
        (
          id_music_history,
          id_user,
          id_music,
          play_duration
        )  
      values 
        (?, ?, ?, ?)
      `,
      [newId, id_user, id_music, play_duration]
    );
    return objectResponse({ newID: newId }, 201);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
