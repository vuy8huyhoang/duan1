import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getByLimitOffset, getCurrentUser } from "@/utils/Get";
import Parser from "@/utils/Parser";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const { limit, offset, id_artist }: any = params;
    let currentUser;
    if (id_artist === undefined) {
      currentUser = await getCurrentUser(request, true);
    } else currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const id_user = currentUser.id_user;
    const queryParams: any[] = [];

    const query = `
    SELECT 
      f.created_at as follow_at,
      a.name,
      a.slug,
      a.url_cover,
      a.is_show
    FROM Follow f
    LEFT JOIN 
      User u on u.id_user = f.id_user 
    LEFT JOIN
      Artist a on a.id_artist = f.id_artist
    WHERE TRUE
      AND f.id_user = '${id_user}'
      ${role === "admin" ? "" : "AND a.is_show = 1"}
      ${getByLimitOffset(limit, offset, "f.created_at")}
    `;

    const [followList]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: followList });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const currentUser = await getCurrentUser(request, true);
    const body = await request.json();
    const { id_artist } = body;
    const id_user = currentUser.id_user;

    // Validate
    Checker.checkString(id_artist, true);

    // Check exist artist
    const [artist]: any[] = await connection.query(
      `select id_artist from Artist where id_artist = '${id_artist}'`
    );
    if (artist.length === 0) throwCustomError("Artist not found");

    // Check followed artist
    const [followResult]: any[] = await connection.query(
      `select id_user from Follow where id_user = '${id_user}' and id_artist = '${id_artist}'`
    );
    if (followResult.length !== 0)
      throwCustomError("Artist is already followed", 400);

    // Update DB
    const [result] = await connection.query(
      `
        insert into Follow (id_user, id_artist) values 
        ('${id_user}', '${id_artist}')
      `,
      []
    );

    return objectResponse({ message: "Follow successfully" }, 201);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const DELETE = async (request: Request) => {
  try {
    const body = await request.json();
    const currentUser = await getCurrentUser(request, true);
    const { id_artist } = body;
    const id_user = currentUser.id_user;

    // Validate
    Checker.checkString(id_artist, true);

    // Check followed artist
    const [followResult]: any[] = await connection.query(
      `select id_user from Follow where id_user = '${id_user}' and id_artist = '${id_artist}'`
    );
    if (followResult.length === 0)
      throwCustomError("Artist is already unfollowed", 400);

    // Update DB
    const [result] = await connection.query(
      `
      delete from Follow 
      where id_user = '${id_user}' and id_artist = '${id_artist}'
    `,
      []
    );

    return objectResponse({ message: "Unfollow successfully" }, 201);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
