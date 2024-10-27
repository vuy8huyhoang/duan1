// app/type/[slug]/page.tsx
"use client"; // Đánh dấu đây là một Client Component

import React, { useEffect, useState } from 'react';
import { useParams } from 'next/navigation'; // Sử dụng useParams để lấy id_type
import axios from '@/lib/axios';
import styles from './ct.module.scss'; 

const TypeDetailPage = ({ params }) => {
  const idType = params.id; 
  const [musicList, setMusicList] = useState<any[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  const fetchMusicList = async () => {
    try {
      const response: any = await axios.get(`/music?id_type=${idType}`); 
      console.log(response.result);
      setMusicList(response.result.data || []); 
    } catch (err) {
      console.error("Error fetching music list:", err);
      setError("Có lỗi xảy ra khi tải danh sách nhạc.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (idType) {
      fetchMusicList();
    }
  }, [idType]); 

  if (loading) {
    return <div>Đang tải dữ liệu...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  return (
    <div>
      <h1>Danh Sách Nhạc Thể Loại: {idType}</h1>
      <div className={styles.albumList}>
        {Array.isArray(musicList) && musicList.length > 0 ? (
          musicList.map((music: any) => (
            <div key={music.id_music} className={styles.songCard}>
              <div className={styles.albumCoverWrapper}>
                <img src={music.url_cover} alt={music.name} className={styles.albumCover} />
                <div className={styles.overlay}>
                  <button className={styles.playButton}>
                    <i className="fas fa-play"></i>
                  </button>
                </div>
              </div>
              <div className={styles.songInfo}>
                <div className={styles.songName}>
                  <a href={`/musicdetail/${music.id_music}`}>{music.name}</a>
                </div>
                <div className={styles.composerName}>
                  <a href={`/musicdetail/${music.id_music}`}>{music.composer}</a>
                </div>
              </div>
              <div className={styles.songControls}>
                <i className="fas fa-heart"></i>
                <i className="fas fa-ellipsis-h"></i>
              </div>
            </div>
          ))
        ) : (
          <div>Không có nhạc nào trong thể loại này.</div>
        )}
      </div>
    </div>
  );
};

export default TypeDetailPage;
