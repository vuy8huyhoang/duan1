import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useRouter } from 'next/router';

const SearchPage: React.FC = () => {
  const router = useRouter();
  const { search_text } = router.query; // Lấy từ khóa tìm kiếm từ query
  const [musicList, setMusicList] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (search_text) {
      const fetchData = async () => {
        try {
          const response = await axios.get(`https://api-groove.vercel.app/search?search_text=${search_text}`);
          setMusicList(response.data.data.musicList); // Lưu danh sách bài hát vào state
        } catch (error) {
          console.error("Error fetching data:", error);
        } finally {
          setLoading(false);
        }
      };
      fetchData();
    }
  }, [search_text]);

  if (loading) {
    return <div>Loading...</div>; // Hiển thị thông báo loading
  }

  return (
    <div>
      <h1>Kết quả tìm kiếm cho: {search_text}</h1>
      <ul>
        {musicList.map(music => (
          <li key={music.id_music}>
            <h2>{music.name}</h2>
            {/* Hiển thị thêm thông tin bài hát nếu cần */}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default SearchPage;
