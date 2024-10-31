"use client";

import React, { useEffect, useState } from "react";
import axios from "@/lib/axios";
import style from "./FavoriteAlbum.module.scss";

interface FavoriteAlbum {
  id_album: string;
  name: string;
  url_cover: string;
}

const FavoriteAlbumPage = () => {
  const [favoriteAlbums, setFavoriteAlbums] = useState<FavoriteAlbum[]>([]);

  useEffect(() => {
    const fetchFavoriteAlbums = async () => {
      try {
        const response:any = await axios.get("/favorite-album/me");
        console.log('Favorite Album Data:', response.data); // Kiểm tra dữ liệu API trả về
        setFavoriteAlbums(response.result.data);
      } catch (error) {
        console.error("Failed to fetch favorite albums", error);
      }
    };
    fetchFavoriteAlbums();
  }, []);

  return (
    <div className={style.favoritePage}>
      <h1 className={style.title}>Albums yêu thích</h1>
      <div className={style.albumGrid}>
        {favoriteAlbums.map((album) => (
          <div key={album.id_album} className={style.albumItem}>
            <img src={album.url_cover || "/default-cover.png"} alt={album.name} />
            <p>{album.name}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default FavoriteAlbumPage;
