import connection from "@/lib/connection";
import transporter from "@/lib/transporter";
import Checker from "@/utils/Checker";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getCurrentUser } from "@/utils/Get";
import { objectResponse } from "@/utils/Response";
import crypto from "crypto";
import { headers } from "next/headers";

export const POST = async (req: Request) => {
  try {
    const currentUser = await getCurrentUser(req, true);
    const email = currentUser.email;

    // Create crypto code
    const resetToken = crypto.randomBytes(32).toString("hex");
    const tokenExpireTime = Date.now() + 300000; // Expired in 5 minutes

    // Update DB
    await connection.query(
      "UPDATE User SET reset_token = ?, reset_token_expired = ? WHERE email = ?",
      [resetToken, tokenExpireTime, email]
    );

    const url = headers().get("host") || "";
    const resetLink = `https://${url}/reset-password/${resetToken}`;

    // Send email
    await transporter.sendMail({
      to: email,
      subject: "Reset Your Password",
      text: `We received a request to reset your password. If you made this request, please click the link below to reset your password. If you did not request a password reset, please ignore this email or contact our support team if you have any concerns.\n\nReset link: ${resetLink}`,
    });

    // Trả về phản hồi thành công
    return objectResponse(
      {
        message: "Password reset email sent successfully.",
      },
      200
    );
  } catch (error) {
    // Xử lý lỗi
    return getServerErrorMsg(error);
  }
};
