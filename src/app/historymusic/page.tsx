"use client";

import React, { useEffect, useState } from "react";
import axios from "@/lib/axios";
import style from "./historymusic.module.scss";
import Link from "next/link";

interface MusicHistory {
  id_music_history: string;
  id_music: string;
  play_duration: number;
  created_at: string;
  music: {
    id_music: string;
    name: string;
    url_cover: string;
  };
}

const HistoryMusicPage = () => {
  const [musicHistory, setMusicHistory] = useState<MusicHistory[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchMusicHistory = async () => {
      try {
        const response: any = await axios.get("/music-history/me"); 
        console.log('Music History Data:', response.result); 
        setMusicHistory(response.result.data);
      } catch (error) {
        console.error("Failed to fetch music history", error);
      } finally {
        setLoading(false);
      }
    };
    fetchMusicHistory();
  }, []);

  if (loading) return <p>Loading...</p>;

  return (
    <div className={style.historyPage}>
      <h1 className={style.title}>Lịch sử nghe nhạc</h1>
      <div className={style.musicGrid}>
        {musicHistory.map((history) => (
          <div key={history.id_music_history} className={style.musicItem}>
            <img
              src={history.music.url_cover || "/default-cover.png"}
              alt={history.music.name}
            />
            <Link href={`/musicdetail/${history.music.id_music}`}>
              {history.music.name}
            </Link>
          
            <p >Thời gian phát: {history.play_duration} giây</p>
            <p>Đã nghe vào: {new Date(history.created_at).toLocaleString()}</p>
        
          </div>
        ))}
      </div>
    </div>
  );
};

export default HistoryMusicPage;
