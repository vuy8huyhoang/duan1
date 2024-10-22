"use client"; 

import { useState } from "react";
import styles from "./AddMusic.module.scss";

export default function AddMusic() {
    const [song, setSong] = useState({
        name: "",
        composer: "",
        releaseDate: "",
        genre: "",
        album: "",
        lyrics: "",
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setSong({ ...song, [name]: value });
    };

    const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        console.log(`File uploaded: ${file?.name}`);
    };

    const handleSubmit = () => {
        console.log("Song data submitted:", song);
    };

    return (
        <div className={styles.container}>
            <h2>Thêm mới bài hát</h2>
            <div className={styles.formGroup}>
                <input
                    type="text"
                    name="name"
                    placeholder="Tên bài hát"
                    value={song.name}
                    onChange={handleChange}
                />
                <input type="file" onChange={handleFileUpload} />
                <input type="file" onChange={handleFileUpload} />
                <input
                    type="text"
                    name="composer"
                    placeholder="Người sáng tác"
                    value={song.composer}
                    onChange={handleChange}
                />
                <input
                    type="date"
                    name="releaseDate"
                    value={song.releaseDate}
                    onChange={handleChange}
                />
                <select name="genre" value={song.genre} onChange={handleChange}>
                    <option value="">Chọn thể loại</option>
                    <option value="nhac-vui">Nhạc vui</option>
                    <option value="nhac-buon">Nhạc buồn</option>
                </select>
                <select name="album" value={song.album} onChange={handleChange}>
                    <option value="">Chọn album</option>
                    <option value="album-1">Album 1</option>
                    <option value="album-2">Album 2</option>
                </select>
            </div>

            <textarea
                name="lyrics"
                placeholder="Lyrics bài hát"
                value={song.lyrics}
                onChange={handleChange}
                className={styles.lyricsInput}
            />

            <button onClick={handleSubmit}>Thêm bài hát</button>
        </div>
    );
}
