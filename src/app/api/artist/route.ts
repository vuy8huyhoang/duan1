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

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const { limit, offset, id_artist, slug, name, is_show }: any = params;
    const queryParams: any[] = [];

    const query = `
    SELECT 
      a.id_artist,
      a.name,
      a.slug,
      a.url_cover,
      a.created_at,
      a.last_update,
      a.is_show,
      COUNT(f.id_user) AS followers
    FROM Artist a
    LEFT JOIN Follow f ON a.id_artist = f.id_artist
    WHERE TRUE
    ${getByRole(role, "a.is_show")}

    ${getByLike(id_artist, "a.id_artist")}
    ${getByLike(slug, "a.slug")}
    ${getByLike(name, "a.name")}
    ${getByEqual(is_show, "a.is_show")}
    
    GROUP BY a.id_artist

    ${getByLimitOffset(limit, offset, "a.created_at")}
    `;
    const [artistList]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ artistList }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const { name, slug, url_cover, is_show = 1 } = body;

    // Validation
    Checker.checkString(name, true);
    Checker.checkString(slug);
    Checker.checkString(url_cover);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request, true);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        "select id_artist from Artist where slug = ?",
        [slug]
      );
      if (slugList.length !== 0) throwCustomError("Slug is already exist", 409);
    }

    // Check slug not empty
    if (slug === "") throwCustomError("Slug cannot be empty string", 400);

    // Update DB
    const newId = uuidv4();
    const [result]: Array<any> = await connection.query(
      `
      insert into Artist
        (id_artist, name, slug, url_cover, is_show)  
      values 
        (?, ?, ?, ?, ?)
      `,
      [newId, name, slug, url_cover, is_show]
    );

    return objectResponse({ newID: newId });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
