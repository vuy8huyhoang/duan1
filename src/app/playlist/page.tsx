"use client"; // Đảm bảo là client component

import React, { useEffect, useState } from "react";
import { useRouter } from "next/router";
import axios from "@/lib/axios";// Import axios

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
  const [error, setError] = useState<string | null>(null);
  const [newPlaylistName, setNewPlaylistName] = useState("");
  const [creating, setCreating] = useState(false); // Trạng thái khi đang tạo playlist

  const fetchPlaylists = async () => {
    try {
      localStorage.setItem("accessToken", "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6InUwMDA1IiwiZXhwIjoxNzY1MTY5MjgzfQ.ZT-i4LBI-1OW9gsc1UyTsBO1J8qirj5UmxzIl9ASWno")
      const response = await axios.get("profile"); // Sử dụng axios để lấy dữ liệu
      const data = response.data;
      console.log(response);

      if (data && data.data) {
        setPlaylists(data.data);
      } else {
        setError("No playlists found");
      }
    } catch (error: any) {
      console.error(error);
      setError(error.message || "Failed to fetch playlists");
    } finally {
      setLoading(false);
    }
  };

  const createPlaylist = async () => {
    if (!newPlaylistName) {
      setError("Playlist name cannot be empty");
      return;
    }

    setCreating(true); // Đặt trạng thái đang tạo
    try {
      const response = await axios.post("playlist/me", {
        name: newPlaylistName,
      });

      if (response.data.success) {
        setNewPlaylistName(""); // Xóa tên đã nhập sau khi tạo thành công
        fetchPlaylists(); // Cập nhật danh sách playlist
      } else {
        setError("Failed to create playlist");
      }
    } catch (error: any) {
      console.error(error);
      setError(error.message || "Failed to create playlist");
    } finally {
      setCreating(false);
    }
  };

  useEffect(() => {
    fetchPlaylists();
  }, []);

  if (loading) return <p>Loading...</p>;

  if (error) return <p>Error: {error}</p>;

  return (
    <div>
      <h1>Your Playlists</h1>

      {/* Form để tạo playlist mới */}
      <div>
        <h2>Create New Playlist</h2>
        <input
          type="text"
          value={newPlaylistName}
          onChange={(e) => setNewPlaylistName(e.target.value)}
          placeholder="Enter playlist name"
        />
        <button onClick={createPlaylist} disabled={creating}>
          {creating ? "Creating..." : "Create Playlist"}
        </button>
      </div>

      {playlists.length === 0 ? (
        <p>No playlists found.</p>
      ) : (
        <ul>
          {playlists.map((playlist) => (
            <li key={playlist.id_playlist}>
              <h2>{playlist.name}</h2>
              <p>Created at: {playlist.created_at}</p>
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
