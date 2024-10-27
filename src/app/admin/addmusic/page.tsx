"use client";
import { useState, useEffect } from "react";
import axios from "@/lib/axios";
import styles from "./AddMusic.module.scss";

interface Artist {
    id_artist: string;
    name: string;
    slug: string;
    url_cover: string;


}
interface Lyrics {
    id_lyrics: string;
    id_music: string;
    lyrics: string;
    start_time: number;
    end_time: number;
}

interface Type {
    id_type: string;
    name: string;
    slug: string;
    created_at: string;
    is_show: number;
}

interface Song {
    id_music: string;
    name: string;
    slug: string;
    url_path: string;
    url_cover: string;
    total_duration: string | null;
    producer: string;
    composer: string | null;
    release_date: string | null;
    created_at: string;
    last_update: string;
    is_show: number;
    view: number;
    favorite: number;
    artists: string[];
    types: string[];
}
interface Composer{
    id_composer: string;
    name: string;
    created_at: string;
    last_update: string;
}
export default function AddMusic() {
    const [song, setSong] = useState<Song>({
        id_music: "",
        name: "",
        slug: "",
        url_path: "",
        url_cover: "",
        total_duration: null,
        producer: "",
        composer: null,
        release_date: null,
        created_at: new Date().toISOString(),
        last_update: new Date().toISOString(),
        is_show: 1,
        view: 0,
        favorite: 0,
        artists: [],
        types: [],
    });
    
    const [artists, setArtists] = useState<Artist[]>([]);
    const [types, setTypes] = useState<Type[]>([]);
    const [loading, setLoading] = useState<boolean>(false);
    const [composers, setComposers] = useState<Composer[]>([]);

    useEffect(() => {
        axios
            .get("/artist")
            .then((response: any) => {
                console.log("Full API response for artists:", response);
                if (response && response.result && response.result.data) {
                    setArtists(response.result.data);
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




    useEffect(() => {
        axios
            .get("/type")
            .then((response: any) => {
                console.log("Full API response for types:", response);
                if (response && response.result && response.result.data) {
                    setTypes(response.result.data);
                } else {
                    console.error("Response data for types is undefined or empty:", response);
                    setTypes([]);
                }
            })
            .catch((error: any) => {
                console.error("Lỗi fetch thể loại:", error);
                setTypes([]);
            });
    }, []);


    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setSong({ ...song, [name]: value });
    };

    const handleArtistSelect = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const selectedArtists = Array.from(e.target.selectedOptions, option => option.value);  // Chỉ lấy ID nghệ sĩ
        setSong({ ...song, artists: selectedArtists });
    };

    const handleTypeSelect = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const selectedTypes = Array.from(e.target.selectedOptions, option => option.value);  // Chỉ lấy ID thể loại
        setSong({ ...song, types: selectedTypes });
    };



    const handleSubmit = async () => {
        setLoading(true);
        const slug = song.name.toLowerCase().replace(/\s+/g, '-');
        const songData = { ...song, slug };

        console.log("Submitting song data:", songData);  // Log dữ liệu trước khi gửi request

        try {
            const response = await axios.post("/music", songData, {
                headers: { "Content-Type": "application/json" },
            });

            if (response.status === 200 || response.status === 201) {
                alert("Bài hát đã được thêm thành công!");
                window.location.href = "/admin/adminmusic";
            } else {
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
                {/* <input
                    type="text"
                    name="composer"
                    placeholder="Người sáng tác"
                    value={song.composer}
                    onChange={handleChange}
                /> */}

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

                <select onChange={handleTypeSelect}>
                    <option value="">Chọn thể loại</option>
                    {types && types.length > 0 ? (
                        types.map(type => (
                            <option key={type.id_type} value={type.id_type}>
                                {type.name}
                            </option>
                        ))
                    ) : (
                        <option>Đang tải thể loại...</option>
                    )}
                </select>


            </div>

            <button onClick={handleSubmit} disabled={loading}>
                {loading ? "Đang gửi..." : "Thêm bài hát"}
            </button>
        </div>
    );
}
