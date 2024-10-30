"use client"; // Thêm dòng này để đánh dấu là Client Component

import React, { useEffect, useState } from "react";
import axios from "@/lib/axios";
import style from "./playlist.module.scss";
import { ReactSVG } from "react-svg";

interface Playlist {
  id_playlist: string;
  name: string;
  created_at: string;
  creator_name: string; // Thêm tên người tạo vào dữ liệu playlist
  music_list?: Music[]; // Danh sách nhạc trong playlist
}
interface Music {
  id_music: string;
  name: string;
}

const PlaylistPage = () => {
  const [playlists, setPlaylists] = useState<Playlist[]>([]);
  const [musicList, setMusicList] = useState<Music[]>([]);
  const [selectedMusic, setSelectedMusic] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<"all" | "mine">("all"); // Tab quản lý
  const [newPlaylistName, setNewPlaylistName] = useState("");
  const [creating, setCreating] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false); // Trạng thái modal
  const [showMusicList, setShowMusicList] = useState(false); // State điều khiển hiển thị danh sách nhạc

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

  const fetchMusic = async () => {
    try {
      const response: any = await axios.get("music");
      setMusicList(response.result.data || []);
    } catch (error: any) {
      setError(error.message || "Failed to fetch music list");
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

      if (response && response.data && response.data.success) {
        const newPlaylistId = response.data.playlist_id;

        const addMusicResponse: any = await axios.post("playlist/add-music", {
          id_playlist: newPlaylistId,
          music_ids: selectedMusic,
        });

      if (addMusicResponse && addMusicResponse.data && addMusicResponse.data.success) {
        setNewPlaylistName("");
        setSelectedMusic([]);
        setIsModalOpen(false);
        fetchPlaylists();
      } else {
        setError("Failed to add music to playlist");
      }
      } else {
        setError("Failed to create playlist");
      }
    } catch (error: any) {
      setError(error.message || "Failed to create playlist");
    } finally {
      setCreating(false);
    }
  };

  const deletePlaylist = async (id_playlist: string) => {
    try {
      const response: any = await axios.delete(`playlist/me/${id_playlist}`);
      console.log("Delete Response:", response); // Kiểm tra phản hồi từ API
      
      // Kiểm tra xem API trả về thành công không
      if (response && response.data && response.data.success) {
        // Xóa playlist khỏi state sau khi xóa thành công
        setPlaylists(playlists.filter((playlist) => playlist.id_playlist !== id_playlist));
      } else {
        setError("Failed to delete playlist");
      }
    } catch (error: any) {
      console.error("Error deleting playlist:", error.response || error.message);
      setError(error.message || "Failed to delete playlist");
    }
  };
  

  const toggleMusicSelection = (id: string) => {
    setSelectedMusic((prevSelected) =>
      prevSelected.includes(id)
        ? prevSelected.filter((musicId) => musicId !== id)
        : [...prevSelected, id]
    );
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
        {/* Nút để mở modal tạo playlist */}
        <div className={style.playlistItem} onClick={() => { setIsModalOpen(true); fetchMusic();}}>
        <ReactSVG className={style.csvg} src="/Group 282.svg" />
          <p>Tạo playlist mới</p>
        </div>

        {/* Modal để nhập tên playlist */}
        {isModalOpen && (
          <div className={style.modal}>
            <div className={style.modalContent}>
              <h2>Tạo Playlist Mới</h2>
              <input
                type="text"
                value={newPlaylistName}
                onChange={(e) => setNewPlaylistName(e.target.value)}
                placeholder="Tên playlist mới"
              />
              
              <button onClick={() => setShowMusicList(!showMusicList)}>
                {showMusicList ? "Ẩn danh sách nhạc" : "Chọn nhạc"}
              </button>

              {/* Chỉ hiển thị danh sách nhạc khi `showMusicList` là true */}
              {showMusicList && (
                <div className={style.musicList}>
                  {musicList.map((music) => (
                    <div key={music.id_music}>
                      <input
                        type="checkbox"
                        checked={selectedMusic.includes(music.id_music)}
                        onChange={() => toggleMusicSelection(music.id_music)}
                      />
                      <label>{music.name}</label>
                    </div>
                  ))}
                </div>
              )}

              <button onClick={createPlaylist} disabled={creating}>
                {creating ? "Creating..." : "Tạo playlist"}
              </button>
              <button onClick={() => setIsModalOpen(false)}>Đóng</button>
            </div>
          </div>
        )}

        {playlists.map((playlist) => (
          <div key={playlist.id_playlist} className={style.playlistItem}>
            <img src="/playlist.png" alt="Playlist cover" />
            <p>{playlist.name}</p>
            {/* Nút Xóa */}
            <button onClick={() => deletePlaylist(playlist.id_playlist)} className={style.deleteButton}>
              Xóa
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

export default PlaylistPage;
