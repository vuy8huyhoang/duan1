import transporter from "@/lib/transporter";
import Checker from "@/utils/Checker";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getCurrentUser, getRandomVerifyEmailCode } from "@/utils/Get";
import { objectResponse } from "@/utils/Response";

export const POST = async (req: Request) => {
  try {
    const currentUser = await getCurrentUser(req, false);
    const body = await req.json();
    let { email, code } = body;
    let returnData;
    let isResponseCode;
    if (code === undefined) {
      isResponseCode = true;
    } else {
      isResponseCode = false;
    }
    Checker.checkEmail(email, true);

    if (code === undefined) {
      code = getRandomVerifyEmailCode();
    }
    // Send email
    await transporter.sendMail({
      to: email,
      subject: `${code} - Confirm Your Email Address`,
      text: `We have received your account registration request with this email address. To complete the registration process, please confirm your email address by entering the verification code. \n\nVerification code: ${code}`,
    });

    if (isResponseCode) {
      returnData = { code };
    } else if (!isResponseCode) {
      returnData = { message: "Verify code sended successfully" };
    }

    // Trả về phản hồi thành công
    return objectResponse(returnData as any, 200);
  } catch (error) {
    // Xử lý lỗi
    return getServerErrorMsg(error);
  }
};
