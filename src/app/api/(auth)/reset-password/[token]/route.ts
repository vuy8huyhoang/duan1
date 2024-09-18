import connection from "@/lib/connection";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { objectResponse } from "@/utils/Response";
import bcrypt from "bcryptjs";
import Checker from "@/utils/Checker";

export const POST = async (
  request: Request,
  { params }: { params: { token: string } }
) => {
  try {
    const body = await request.json();

    const token = params.token;
    const { newPassword = "" } = body;
    Checker.checkPassword(newPassword, true);

    const [users]: Array<any> = await connection.query(
      `select id_user, reset_token, reset_token_expired from User where reset_token = '${token}' and reset_token_expired > '${Date.now()}'`
    );

    if (users.length === 1) {
      const user = users[0];
      const hashedPassword = await bcrypt.hash(newPassword, 12);

      const query = `UPDATE User SET password = ?, reset_token = NULL, reset_token_expired = NULL WHERE id_user = ?`;
      await connection.query(query, [hashedPassword, user.id_user]);

      return objectResponse({ message: "Reset password successfully" }, 200);
    } else {
      throwCustomError("Reset token not found");
    }
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
