"use client";
import { useState } from "react";
import axios from "@/lib/axios";
import styles from "./AddMusic.module.scss";

interface Song {
    id_music: string;
    name: string;
    slug: string;
    url_path: string;
    url_cover: string;
    total_duration: string | null;
    producer: string;
    composer: string;
    release_date: string | null;
    created_at: string;
    last_update: string;
    is_show: number;
    view: number;
    favorite: number;
}

export default function AddMusic() {
    const [song, setSong] = useState<Song>({
        id_music: "",
        name: "",
        slug: "",
        url_path: "", // URL video sẽ nhập tại đây
        url_cover: "", // URL ảnh bìa sẽ nhập tại đây
        total_duration: null,
        producer: "",
        composer: "",
        release_date: null,
        created_at: new Date().toISOString(),
        last_update: new Date().toISOString(),
        is_show: 1,
        view: 0,
        favorite: 0,
    });

    const [loading, setLoading] = useState<boolean>(false);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setSong({ ...song, [name]: value });
    };

    const handleSubmit = async () => {
        setLoading(true);
        // Chuyển đổi `name` thành `slug` (tên bài hát dạng URL)
        const slug = song.name.toLowerCase().replace(/\s+/g, '-');

        const songData = {
            ...song,
            slug,
            release_date: song.release_date || null,
        };

        try {
            const response = await axios.post("/music", songData, {
                headers: {
                    "Content-Type": "application/json",
                },
            });

            if (response.status === 200 || response.status === 201) {
                console.log("Song data submitted successfully:", response.data);
                alert("Bài hát đã được thêm thành công!");
                window.location.href = "/admin/adminmusic";
            } else {
                console.error("Failed to submit song data", response);
                alert("Thêm bài hát không thành công.");
            }
        } catch (error) {
            console.error("Error submitting song data:", error);
            alert("Đã xảy ra lỗi khi gửi dữ liệu.");
        } finally {
            setLoading(false);
        }
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
                <input
                    type="text"
                    name="url_path"
                    placeholder="URL video"
                    value={song.url_path}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="url_cover"
                    placeholder="URL ảnh bìa"
                    value={song.url_cover}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="producer"
                    placeholder="Nhà sản xuất"
                    value={song.producer}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="composer"
                    placeholder="Người sáng tác"
                    value={song.composer}
                    onChange={handleChange}
                />
                <input
                    type="date"
                    name="release_date"
                    value={song.release_date || ""}
                    onChange={handleChange}
                />
            </div>

            <button onClick={handleSubmit} disabled={loading}>
                {loading ? "Đang gửi..." : "Thêm bài hát"}
            </button>
        </div>
    );
}
