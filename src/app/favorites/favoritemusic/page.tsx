"use client";

import React, { useEffect, useState } from "react";
import axios from "@/lib/axios";
import style from "./FavoriteMusic.module.scss";

interface FavoriteMusic {
  id_music: string;
  name: string;
  url_cover: string;
}

const FavoriteMusicPage = () => {
  const [favoriteMusic, setFavoriteMusic] = useState<FavoriteMusic[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchFavoriteMusic = async () => {
      try {
        const response:any = await axios.get("/favorite-music/me");
        console.log('Favorite Music Data:', response.result); // Kiểm tra dữ liệu API trả về
        setFavoriteMusic(response.result.data);
      } catch (error) {
        console.error("Failed to fetch favorite music", error);
      } finally {
        setLoading(false);
      }
    };
    fetchFavoriteMusic();
  }, []);
  if (loading) return <p>Loading...</p>;
  

  return (
    <div className={style.favoritePage}>
      
      <div className={style.musicGrid}>
        {favoriteMusic.map((music) => (
          <div key={music.id_music} className={style.musicItem}>
            <img src={music.url_cover || "/default-cover.png"} alt={music.name} />
            <p>{music.name}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default FavoriteMusicPage;
