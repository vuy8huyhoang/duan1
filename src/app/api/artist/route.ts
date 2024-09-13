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
    const {
      limit,
      offset,
      birthday,
      country,
      gender,
      slug,
      name,
      is_show,
    }: any = params;
    const queryParams: any[] = [];
    let query = "";

    if (role === "admin") {
      query += `SELECT * FROM Artist`;
    } else {
      query += `
        SELECT 
          id_artist,
          name,
          description,
          slug,
          url_cover,
          birthday,
          country,
          gender,
          created_at,
          last_update
        FROM Artist
        WHERE is_show = 1
      `;
    }

    // Add filtering conditions if provided
    const filters: string[] = [];
    if (birthday) {
      filters.push("birthday = ?");
      queryParams.push(birthday);
    }
    if (country) {
      filters.push("country = ?");
      queryParams.push(country);
    }
    if (gender) {
      filters.push("gender = ?");
      queryParams.push(gender);
    }
    if (slug) {
      filters.push("slug = ?");
      queryParams.push(slug);
    }
    if (name) {
      filters.push("name = ?");
      queryParams.push(name);
    }
    if (is_show) {
      filters.push("is_show = ?");
      queryParams.push(is_show);
    }

    if (filters.length > 0) {
      query += ` AND ${filters.join(" AND ")}`;
    }

    // Add limit and offset only if provided
    if (limit !== undefined || offset !== undefined) {
      query += ` ORDER BY id_artist`; // Ensure there's an ORDER BY clause
      if (limit !== undefined) {
        query += ` LIMIT ?`;
        queryParams.push(parseInt(limit, 10)); // Convert limit to integer
      }
      if (offset !== undefined) {
        query += ` OFFSET ?`;
        queryParams.push(parseInt(offset, 10)); // Convert offset to integer
      }
    }

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
