import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import {
  getByEqual,
  getByLike,
  getByLimitOffset,
  getByRole,
  getCurrentUser,
} from "@/utils/Get";
import bcrypt from "bcryptjs";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import { v4 as uuidv4 } from "uuid";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, true);
    const currentRole = currentUser.role;
    if (currentRole !== "admin") {
      throwCustomError("Not enough permission", 403);
    }
    const {
      limit,
      offset,
      id_user,
      email,
      role,
      fullname,
      phone,
      gender,
      birthday,
      country,
      is_banned,
      id_google,
    }: any = params;
    const queryParams: any[] = [];

    const query = `
    SELECT 
      id_user,
      email,
      role,
      fullname,
      phone,
      gender,
      url_avatar,
      birthday,
      country,
      created_at,
      last_update,
      is_banned,
      id_google
    FROM User
    WHERE TRUE
    ${getByRole(currentRole, "is_show")}
    
    ${getByEqual(id_user, "id_user")}
    ${getByEqual(email, "email")}
    ${getByEqual(role, "role")}
    ${getByLike(fullname, "fullname")}
    ${getByLike(phone, "phone")}
    ${getByEqual(gender, "gender")}
    ${getByLike(birthday, "birthday")}
    ${getByLike(country, "country")}
    ${getByEqual(is_banned, "is_banned")}
    ${getByEqual(id_google, "id_google")}

    ${getByLimitOffset(limit, offset, "created_at")}
    `;

    const [userList]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: userList }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const {
      email,
      password,
      role = "user",
      fullname,
      phone,
      gender,
      url_avatar,
      birthday,
      country,
      is_banned = 0,
    } = body;

    // Validation
    Checker.checkEmail(email, true);
    Checker.checkPassword(password, true);
    Checker.checkIncluded(role, ["user", "admin"]);
    Checker.checkString(fullname, true);
    Checker.checkPhoneNumber(phone);
    Checker.checkIncluded(gender, ["male", "female"]);
    Checker.checkString(url_avatar);
    Checker.checkDate(birthday);
    Checker.checkString(country);
    Checker.checkIncluded(is_banned, [0, 1]);

    // Check permission
    const currentUser = await getCurrentUser(request, true);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Check unique phone
    if (phone) {
      const [phoneList]: Array<any> = await connection.query(
        "select id_user from User where phone = ?",
        [phone]
      );
      if (phoneList.length !== 0)
        throwCustomError("Phone is already exist", 409);
    }

    // Check unique email
    if (email) {
      const [emailList]: Array<any> = await connection.query(
        "select id_user from User where email = ?",
        [email]
      );
      if (emailList.length !== 0)
        throwCustomError("Email is already exist", 409);
    }

    // Update DB
    const newId = uuidv4();
    const hashedPassword = await bcrypt.hash(password, 12);
    const [result]: Array<any> = await connection.query(
      `
      insert into User
        (
          id_user,
          email,
          password,
          role,
          fullname,
          phone,
          gender,
          url_avatar,
          birthday,
          country,
          is_banned
        )  
      values 
        (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        newId,
        email,
        hashedPassword,
        role,
        fullname,
        phone,
        gender,
        url_avatar,
        birthday,
        country,
        is_banned,
      ]
    );

    return objectResponse({ newID: newId });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
