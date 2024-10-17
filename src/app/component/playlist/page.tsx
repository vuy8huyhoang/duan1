import React, { useEffect, useState } from "react";
import { useRouter } from "next/router";

// Định nghĩa các kiểu dữ liệu
interface Music {
  id_music: string;
  name: string;
}

interface Playlist {
  id_playlist: string;
  name: string;
  created_at: string;
  musics: Music[];
}

const PlaylistPage = () => {
  const [playlists, setPlaylists] = useState<Playlist[]>([]);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  const fetchPlaylists = async () => {
    try {
      const response = await fetch("http://localhost:3000/api/playlist/me"); // API để lấy danh sách playlist của người dùng
      if (!response.ok) throw new Error("Failed to fetch playlists");
      const data = await response.json();
      setPlaylists(data.data); // Giả sử data trả về chứa mảng playlists
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPlaylists();
  }, []);

  if (loading) return <p>Loading...</p>;

  return (
    <div>
      <h1>Your Playlists</h1>
      {playlists.length === 0 ? (
        <p>No playlists found.</p>
      ) : (
        <ul>
          {playlists.map((playlist) => (
            <li key={playlist.id_playlist}>
              <h2>{playlist.name}</h2>
              <p>{playlist.created_at}</p>
              <ul>
                {playlist.musics.map((music) => (
                  <li key={music.id_music}>
                    <p>{music.name}</p>
                  </li>
                ))}
              </ul>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default PlaylistPage;
