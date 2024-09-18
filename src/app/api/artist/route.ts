import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getCurrentUser } from "@/utils/Get";
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
      COUNT(f.id_follow) AS followers
    FROM Artist a
    LEFT JOIN Follow f ON a.id_artist = f.id_artist
    WHERE TRUE
    ${role === "admin" ? "" : "AND is_show = 1"}

    ${
      (id_artist !== undefined && `AND a.id_artist LIKE '%${id_artist}%'`) || ""
    }
    ${(slug !== undefined && `AND a.slug LIKE '%${slug}%'`) || ""}
    ${(name !== undefined && `AND a.name LIKE '%${name}%'`) || ""}
    ${(is_show !== undefined && `AND a.is_show LIKE '%${is_show}%'`) || ""}
    GROUP BY a.id_artist
    ${
      limit !== undefined || offset !== undefined ? " ORDER BY a.id_artist" : ""
    }
    ${limit !== undefined ? ` LIMIT ${limit}` : ""}
    ${offset !== undefined ? ` OFFSET ${offset}` : ""}
    `;
    const [artistList]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: artistList });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const {
      name,
      description,
      slug,
      url_cover,
      birthday,
      country,
      gender,
      is_show,
    } = body;

    // Validation
    Checker.checkString(name, true);
    Checker.checkString(description);
    Checker.checkString(slug);
    Checker.checkString(url_cover);
    Checker.checkDate(birthday);
    Checker.checkString(country);
    Checker.checkIncluded(gender, ["male", "female"]);
    Checker.checkIncluded(is_show, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique slug
    if (slug) {
      const [slugList]: Array<any> = await connection.query(
        "select id_artist from Artist where slug = ?",
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
      insert into Artist
        (id_artist, name, description, slug, url_cover, birthday, country, gender, is_show)  
      values 
        (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        newId,
        name,
        description,
        slug,
        url_cover,
        birthday,
        country,
        gender,
        is_show,
      ]
    );

    return objectResponse({ newID: newId });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
