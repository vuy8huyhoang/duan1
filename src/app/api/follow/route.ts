import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getByLimitOffset, getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import Parser from "@/utils/Parser";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const { limit, offset, id_artist, start_date, end_date }: any = params;
    let currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const queryParams: any[] = [];

    if (!id_artist) throwCustomError("Missing id_artist", 400);

    Checker.checkDate(start_date);
    Checker.checkDate(end_date);

    const query = `
    SELECT 
      f.created_at as follow_at,
      u.fullname,
      u.url_avatar,
      u.id_user
    FROM Follow f
    LEFT JOIN 
      User u on u.id_user = f.id_user 
    WHERE TRUE
      AND f.id_artist = '${id_artist}'
      ${getByLimitOffset(limit, offset, "f.created_at")}
    `;

    const [followList]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: followList });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
