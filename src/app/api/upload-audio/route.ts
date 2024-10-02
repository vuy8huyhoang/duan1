import cloudinary from "@/lib/cloudinary"; // Import Cloudinary config
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { objectResponse } from "@/utils/Response";

export const POST = async (req: Request, res: Response) => {
  try {
    const formData = await req.formData();
    const file = formData.get("img"); // Only need to get the first file

    if (!file || !(file instanceof File)) {
      throw new Error("No file uploaded or file is invalid.");
    }

    // Define allowed MIME types
    const allowedMimeTypes = ["audio/mpeg", "audio/mp3", "audio/mp4"];

    // Check if the file type is allowed
    if (!allowedMimeTypes.includes(file.type)) {
      throw new Error("File type not allowed.");
    }

    // Convert file stream to a buffer
    const buffer = Buffer.from(await file.arrayBuffer());

    // Upload to Cloudinary
    const result = await new Promise((resolve, reject) => {
      cloudinary.v2.uploader
        .upload_stream({ resource_type: "auto" }, (error, result) => {
          if (error) {
            reject(error);
          } else {
            resolve(result);
          }
        })
        .end(buffer);
    });

    const url = (result as any)?.url || null;

    return objectResponse({
      message: "Upload image successfully",
      url: url,
    });
  } catch (e) {
    return getServerErrorMsg(e);
  }
};

export const DELETE = async (req: Request, res: Response) => {
  try {
    const { url } = await req.json(); // Assume the request body contains the URL of the image to be deleted

    if (!url) {
      throw new Error("No URL provided.");
    }

    // Extract public_id using regex
    const regex = /\/([^\/]+)\/([^\/]+)$/;
    const matches = url.match(regex);

    if (!matches || matches.length < 3) {
      throw new Error("No public_id could be extracted from the URL.");
    }

    const public_id = `${matches[2]}`.replace(
      /\.(jpg|jpeg|png|gif|mp4|webm|mp3)$/i,
      ""
    ); // Combine the version and public ID

    // Delete the image from Cloudinary
    const result = await cloudinary.v2.uploader.destroy(public_id, {
      resource_type: "video",
    });

    if (result.result === "ok") {
      return objectResponse(
        {
          message: "Image deleted successfully",
        },
        200
      );
    } else {
      throwCustomError("Failed to delete the image.", 400);
    }
  } catch (e) {
    return getServerErrorMsg(e);
  }
};
