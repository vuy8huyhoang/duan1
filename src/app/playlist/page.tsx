"use client";
import React, { useEffect, useState } from "react";
import { useRouter } from "next/router";

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

  const fetchPlaylists = async () => {
    try {
      const response = await fetch("http://localhost:3000/api/playlist/me"); 
      if (!response.ok) throw new Error("Failed to fetch playlists");
      const data = await response.json();

      if (data && data.data) {
        setPlaylists(data.data); 
      } else {
        setError("No playlists found");
      }
    } catch (error: any) {
      console.error(error);
      setError(error.message); 
    } finally {
      setLoading(false);
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
