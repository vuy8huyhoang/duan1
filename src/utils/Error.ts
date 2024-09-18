import { objectResponse, stringResponse } from "./Response";

class CustomError extends Error {
  constructor(public statusCode: number, message?: string) {
    super(message);
    this.name = "CustomError";
  }
}

export const throwCustomError = (msg: string, status: number = 500): never => {
  throw new CustomError(status, msg);
};

export const getServerErrorMsg = (e: any) => {
  if (e instanceof CustomError) {
    return objectResponse(
      { message: "Contact admin if see this error", error: e.message },
      e.statusCode
    );
  } else if (e instanceof Error) {
    return objectResponse(
      { message: "Contact admin if see this error", error: e.message },
      500
    );
  } else {
    return objectResponse({ message: "Unknown error" }, 500);
  }
};
