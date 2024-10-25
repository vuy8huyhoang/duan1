// app/type/[slug]/page.tsx
"use client"; // Đánh dấu đây là một Client Component

import React, { useEffect, useState } from 'react';
import { useParams } from 'next/navigation'; // Sử dụng useParams để lấy id_type
import axios from '@/lib/axios';

const TypeDetailPage = () => {
  const { slug: idType } = useParams(); // Lấy id_type từ params
  const [musicList, setMusicList] = useState<any[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  const fetchMusicList = async () => {
    try {
      const response = await axios.get(`/music?id_type=${idType}`); // Thay đổi để fetch nhạc theo id_type
      console.log(response.data);
      setMusicList(response.data.data || []); 
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
      <ul>
        {Array.isArray(musicList) && musicList.length > 0 ? (
          musicList.map((music: any) => (
            <li key={music.id_music}>
              <a href={music.url_path}>{music.name}</a>
              {music.url_cover && <img src={music.url_cover} alt={`${music.name} cover`} />}
            </li>
          ))
        ) : (
          <li>Không có nhạc nào trong thể loại này.</li>
        )}
      </ul>
    </div>
  );
};

export default TypeDetailPage;
