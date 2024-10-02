import connection from "@/lib/connection";
import Checker from "@/utils/Checker";
import { getByRole, getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { objectResponse } from "@/utils/Response";

export const GET = async (request: Request, context: any) => {
  try {
    const { params } = context;
    const { id } = params;
    const id_user = id;
    const currentUser = await getCurrentUser(request, false);
    const currentRole = currentUser.role;
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
    AND id_user = '${id_user}'
    `;

    const [user]: Array<any> = await connection.query(query, queryParams);
    return objectResponse({ data: user[0] });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};

export const PATCH = async (request: Request, context: any) => {
  try {
    const body = await request.json();
    const {
      email,
      password,
      role,
      fullname,
      phone,
      gender,
      url_avatar,
      birthday,
      country,
      is_banned,
    } = body;
    const { params } = context;
    const { id } = params;
    const id_user = id;

    // Validation
    Checker.checkEmail(email);
    Checker.checkPassword(password);
    Checker.checkIncluded(role, ["user", "admin"]);
    Checker.checkString(fullname);
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
        `select id_user from User where phone = ? and id_user = '${id_user}'`,
        [phone]
      );
      if (phoneList.length !== 0)
        throwCustomError("Phone is already exist", 409);
    }

    // Check unique email
    if (email) {
      const [emailList]: Array<any> = await connection.query(
        `select id_user from User where email = ? and id_user <> '${id_user}'`,
        [email]
      );
      if (emailList.length !== 0)
        throwCustomError("Email is already exist", 409);
    }

    // Update DB
    const querySet = [];
    const queryParams = [];

    if (email !== undefined) {
      querySet.push("email = ?");
      queryParams.push(email);
    }
    if (password !== undefined) {
      querySet.push("password = ?");
      queryParams.push(password);
    }
    if (role !== undefined) {
      querySet.push("role = ?");
      queryParams.push(role);
    }
    if (fullname !== undefined) {
      querySet.push("fullname = ?");
      queryParams.push(fullname);
    }
    if (phone !== undefined) {
      querySet.push("phone = ?");
      queryParams.push(phone);
    }
    if (gender !== undefined) {
      querySet.push("gender = ?");
      queryParams.push(gender);
    }
    if (url_avatar !== undefined) {
      querySet.push("url_avatar = ?");
      queryParams.push(url_avatar);
    }
    if (birthday !== undefined) {
      querySet.push("birthday = ?");
      queryParams.push(birthday);
    }
    if (country !== undefined) {
      querySet.push("country = ?");
      queryParams.push(country);
    }
    if (is_banned !== undefined) {
      querySet.push("is_banned = ?");
      queryParams.push(is_banned);
    }

    if (querySet.length === 0)
      throwCustomError("No valid fields to update", 400);

    queryParams.push(id_user); // Push the ID at the end for the WHERE clause

    const [result]: Array<any> = await connection.query(
      `update User set ${querySet.join(", ")} where id_user = ?`,
      queryParams
    );

    if (result.affectedRows === 0) {
      throwCustomError("User not found", 404);
    }

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
    const currentUser = await getCurrentUser(request, true);
    if (currentUser?.role !== "admin")
      throwCustomError("Not enough permission", 403);

    // Delete User from DB
    const [result]: Array<any> = await connection.query(
      "delete from User where id_user = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      throwCustomError("Delete user is denied", 404);
    }

    return objectResponse({ message: "Deleted successfully" }, 200);
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
