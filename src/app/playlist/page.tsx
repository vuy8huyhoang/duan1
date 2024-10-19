"use client"; // Thêm dòng này để đánh dấu là Client Component

import React, { useEffect, useState } from "react";
import axios from "@/lib/axios";
import style from "./playlist.module.scss";

interface Playlist {
  id_playlist: string;
  name: string;
  created_at: string;
  creator_name: string; // Thêm tên người tạo vào dữ liệu playlist
}

const PlaylistPage = () => {
  const [playlists, setPlaylists] = useState<Playlist[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<"all" | "mine">("all"); // Tab quản lý
  const [newPlaylistName, setNewPlaylistName] = useState("");
  const [creating, setCreating] = useState(false);

  const fetchPlaylists = async () => {
    try {
      const response:any = await axios.get("playlist/me");
      const data = response.result;

      if (data && data.data) {
        setPlaylists(data.data);
      } else {
        setError("No playlists found");
      }
    } catch (error: any) {
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

    setCreating(true);
    try {
      const response:any = await axios.post("playlist/me", {
        name: newPlaylistName,
      });

      if (response.data.success) {
        setNewPlaylistName("");
        fetchPlaylists();
      } else {
        setError("Failed to create playlist");
      }
    } catch (error: any) {
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
    <div className={style.playlistPage}>
      <h1 className={style.title}>Playlist</h1>

      {/* Tabs chuyển đổi giữa "Tất cả" và "Của tôi" */}
      <div className={style.tabs}>
        <button
          className={`${style.tabButton} ${activeTab === "all" ? style.active : ""}`}
          onClick={() => setActiveTab("all")}
        >
          Tất cả
        </button>
        <button
          className={`${style.tabButton} ${activeTab === "mine" ? style.active : ""}`}
          onClick={() => setActiveTab("mine")}
        >
          Của tôi
        </button>
      </div>

      <div className={style.playlistGrid}>
  <button
    onClick={createPlaylist}
    disabled={creating}
    className={style.createNewPlaylist}
  >
    {creating ? "Creating..." : "Tạo playlist mới"}
  </button>
  {playlists.map((playlist) => (
    <div key={playlist.id_playlist} className={style.playlistItem}>
      <img src="/placeholder-image.png" alt="Playlist cover" />
      <p>{playlist.name}</p>
    </div>
  ))}
</div>

    </div>
  );
};

export default PlaylistPage;
