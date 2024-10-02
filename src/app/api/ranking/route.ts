import connection from "@/lib/connection";
import { getByLimitOffset, getCurrentUser } from "@/utils/Get";
import { getServerErrorMsg, throwCustomError } from "@/utils/Error";
import { getQueryParams, objectResponse } from "@/utils/Response";
import Parser from "@/utils/Parser";
import Checker from "@/utils/Checker";

export const GET = async (request: Request) => {
  try {
    const params = getQueryParams(request);
    const currentUser = await getCurrentUser(request, false);
    const role = currentUser.role;
    const { limit = 100, offset = 0, type = "day" }: any = params;
    const queryParams: any[] = [];

    Checker.checkIncluded(type, ["day", "month", "week"]);

    // Serach music
    const musicQuery = `
    SELECT
      m.id_music,
      m.name,
      m.slug,
      m.total_duration,
      m.release_date,
      m.created_at,
      m.last_update,
      m.is_show,
      (
        select count(*) 
        from MusicHistory mh 
        where mh.id_music = m.id_music
        ${
          type === "day"
            ? `and mh.created_at 
              BETWEEN NOW() - INTERVAL 1 DAY 
              AND NOW()`
            : ""
        }
        ${
          type === "week"
            ? `and mh.created_at 
                BETWEEN NOW() - INTERVAL 1 WEEK 
                AND NOW()`
            : ""
        }
        ${
          type === "month"
            ? `and mh.created_at 
            BETWEEN NOW() - INTERVAL 1 MONTH 
            AND NOW()`
            : ""
        }
      ) as view,
      (
        select count(*) 
        from FavoriteMusic fm 
        where fm.id_music = m.id_music
        ${
          type === "day"
            ? `and fm.last_update 
            BETWEEN NOW() - INTERVAL 1 DAY 
            AND NOW()`
            : ""
        }
        ${
          type === "week"
            ? `and fm.last_update 
            BETWEEN NOW() - INTERVAL 1 WEEK 
            AND NOW()`
            : ""
        }
        ${
          type === "month"
            ? `and fm.last_update 
            BETWEEN NOW() - INTERVAL 1 MONTH 
            AND NOW()`
            : ""
        }
      ) as favorite,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_type', ty.id_type",
          "'name', ty.name",
          "'slug', ty.slug",
          "'created_at', ty.created_at",
          "'is_show', ty.is_show",
        ])
      )} AS types,
      ${Parser.queryArray(
        Parser.queryObject([
          "'id_artist', art.id_artist",
          "'name', art.name",
          "'slug', art.slug",
          "'url_cover', art.url_cover",
          "'created_at', art.created_at",
          "'last_update', art.last_update",
          "'is_show', art.is_show",
        ])
      )} AS artists
    FROM 
      Music m
    LEFT JOIN
      MusicArtistDetail mad
        on mad.id_music = m.id_music
    LEFT JOIN
      Artist art
        on art.id_artist = mad.id_artist
    LEFT JOIN
      MusicTypeDetail mtd
        on mtd.id_music = m.id_music
    LEFT JOIN
      Type ty
        on ty.id_type = mtd.id_type
    WHERE TRUE
      ${role === "admin" ? "" : "AND m.is_show = 1"}
    GROUP BY 
      m.id_music
    ${getByLimitOffset(limit, offset, "view")}
    `;
    const [musicList]: Array<any> = await connection.query(
      musicQuery,
      queryParams
    );
    Parser.convertJson(musicList as Array<any>, "types", "artists");
    musicList.forEach((item: any, index: number) => {
      item.types = Parser.removeNullObjects(item.types);
      item.artists = Parser.removeNullObjects(item.artists);
    });

    return objectResponse({ data: { musicList } });
  } catch (error) {
    return getServerErrorMsg(error);
  }
};
