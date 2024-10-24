"use client";
import { useState, useEffect } from "react";
import axios from "@/lib/axios";
import styles from "./addAlbum.module.scss";

interface Artist {
    id_artist: string;
    name: string;
    slug: string;
    url_cover: string;
}

interface Album {
    id_album: string;
    name: string;
    slug: string;
    url_cover: string;
    release_date: string | null;
    created_at: string;
    last_update: string;
    is_show: number;
    artists: string[]; 
}

export default function AddAlbum() {
    const [album, setAlbum] = useState<Album>({
        id_album: "",
        name: "",
        slug: "",
        url_cover: "",
        release_date: null,
        created_at: new Date().toISOString(),
        last_update: new Date().toISOString(),
        is_show: 1,
        artists: [],
    });

    const [artists, setArtists] = useState<Artist[]>([]);
    const [loading, setLoading] = useState<boolean>(false);

    useEffect(() => {
        axios
            .get("/artist")
            .then((response: any) => {
                console.log("Full API response for artists:", response);
                if (response && response.result && response.result.artistList) {
                    setArtists(response.result.artistList);
                } else {
                    console.error("Response data for artists is undefined or empty:", response);
                    setArtists([]);
                }
            })
            .catch((error: any) => {
                console.error("Lỗi fetch nghệ sĩ:", error);
                setArtists([]);
            });
    }, []);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setAlbum({ ...album, [name]: value });
    };

    const handleArtistSelect = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const selectedArtists = Array.from(e.target.selectedOptions, option => option.value);
        setAlbum({ ...album, artists: selectedArtists });
    };

    const handleSubmit = async () => {
        setLoading(true);
        const slug = album.name.toLowerCase().replace(/\s+/g, '-');
        const albumData = { ...album, slug };

        try {
            const response = await axios.post("/album", albumData, {
                headers: { "Content-Type": "application/json" },
            });

            if (response.status === 200 || response.status === 201) {
                alert("Album đã được thêm thành công!");
                window.location.href = "/admin/adminalbum";
            } else {
                alert("Thêm album không thành công.");
            }
        } catch (error) {
            console.error("Error submitting album data:", error);
            alert("Đã xảy ra lỗi khi gửi dữ liệu.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className={styles.container}>
            <h2>Thêm mới album</h2>
            <div className={styles.formGroup}>
                <input
                    type="text"
                    name="name"
                    placeholder="Tên album"
                    value={album.name}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="url_cover"
                    placeholder="URL ảnh bìa"
                    value={album.url_cover}
                    onChange={handleChange}
                />
                <input
                    type="date"
                    name="release_date"
                    value={album.release_date || ""}
                    onChange={handleChange}
                />
                <select onChange={handleArtistSelect}>
                    <option value="">Chọn nghệ sĩ</option>
                    {artists && artists.length > 0 ? (
                        artists.map(artist => (
                            <option key={artist.id_artist} value={artist.id_artist}>
                                {artist.name}
                            </option>
                        ))
                    ) : (
                        <option>Đang tải nghệ sĩ...</option>
                    )}
                </select>
            </div>

            <button onClick={handleSubmit} disabled={loading}>
                {loading ? "Đang gửi..." : "Thêm album"}
            </button>
        </div>
    );
}
