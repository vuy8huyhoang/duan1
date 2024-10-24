"use client";

import { useEffect, useState } from "react";
import axios from "@/lib/axios";
import styles from "../EditMusic.module.scss";

interface Artist {
    id_artist: string;
    name: string;
    slug: string;
    url_cover: string;
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
    composer: string;
    release_date: string | null;
    created_at: string;
    last_update: string;
    is_show: number;
    view: number;
    favorite: number;
    artists: { id_artist: string; name: string }[]; 
    types: { id_type: string; name: string }[];   
}

export default function EditMusic({ params }: { params: { id: string } }) {
    const [song, setSong] = useState<Song | null>(null);
    const [artists, setArtists] = useState<Artist[]>([]);
    const [types, setTypes] = useState<Type[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [formattedDate, setFormattedDate] = useState<string>("");

    useEffect(() => {
        axios.get("/artist").then((response: any) => {
            if (response && response.result && response.result.data) {
                setArtists(response.result.data);
            }
        });
        axios.get("/type").then((response: any) => {
            if (response?.result?.data) {
                setTypes(response.result.data);
            }
        });
    }, []);
    useEffect(() => {
        if (params.id) {
            axios
                .get(`/music/${params.id}`)
                .then((response: any) => {
                    console.log("Full API response:", response);  
                    if (response?.result) {
                        const songData = response.result;

                        // Xử lý release_date
                        if (songData.release_date) {
                            try {
                                const date = new Date(songData.release_date);
                                const formatted = date.toISOString().split("T")[0];
                                setFormattedDate(formatted);
                            } catch (error) {
                                console.error("Lỗi khi xử lý release_date:", error);
                            }
                        } else {
                            setFormattedDate(""); 
                        }

                        setSong(songData);
                        console.log("Song data:", songData); 
                    } else {
                        console.log("Không tìm thấy bài hát:", response);  
                        setSong(null);
                    }
                })
                .catch((error: any) => {
                    console.error("Lỗi fetch bài hát:", error);
                    setSong(null);
                })
                .finally(() => {
                    setLoading(false);
                });
        }
    }, [params.id]);


    console.log("params.id:", params.id);
    if (loading) return <p>Đang tải...</p>;
    if (!song) {
        console.log("Song is null or undefined", song);
        return <p>Không tìm thấy bài hát.</p>;
    }
    console.log("Song data to display: ", song);
    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setSong({ ...song, [name]: value } as Song);
    };

    const handleArtistSelect = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const selectedArtistId = e.target.value;

        setSong((prevSong) => {
            if (prevSong) {
                const existingArtists = prevSong.artists.map(artist => artist.id_artist);
                if (!existingArtists.includes(selectedArtistId)) {
                    return {
                        ...prevSong,
                        artists: [...prevSong.artists, { id_artist: selectedArtistId, name: "" }],
                    };
                }
            }
            return prevSong;
        });
    };


    const handleTypeSelect = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const selectedTypeId = e.target.value; 

        setSong((prevSong) => {
            if (prevSong) {
                return {
                    ...prevSong,
                    types: [{ id_type: selectedTypeId, name: prevSong.types.find(type => type.id_type === selectedTypeId)?.name || "" }],
                };
            }
            return prevSong;
        });
    };

    const handleSubmit = async () => {
        setLoading(true);

        const slug = song?.name.toLowerCase().replace(/\s+/g, "-");
        const songData = {
            name: song?.name,
            slug,
            url_path: song?.url_path || "", 
            url_cover: song?.url_cover || "", 
            producer: song?.producer || "", 
            composer: song?.composer || "", 
            release_date: song?.release_date || null, 
            last_update: new Date().toISOString(),
            artists: song.artists.map(artist => ({ id_artist: artist.id_artist })), 
            types: song.types.map(type => ({ id_type: type.id_type })),
        };

        try {
            const response = await axios.patch(`/music/${params.id}`, songData, {
                headers: {
                    "Content-Type": "application/json",
                },
            });

            if (response.status === 200 || response.status === 204) {
                alert("Bài hát đã được cập nhật thành công!");
                window.location.href = "/admin/adminmusic";
            } else {
                alert("Cập nhật bài hát không thành công.");
            }
        } catch (error) {
            console.error("Error updating song data:", error);
            alert("Đã xảy ra lỗi khi cập nhật dữ liệu.");
        } finally {
            setLoading(false);
        }
    };



    return (
        <div className={styles.container}>
            <h2>Chỉnh sửa bài hát</h2>
            <div className={styles.formGroup}>
                <input
                    type="text"
                    name="name"
                    placeholder="Tên bài hát"
                    value={song?.name || ""}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="url_path"
                    placeholder="URL video"
                    value={song?.url_path || ""}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="url_cover"
                    placeholder="URL ảnh bìa"
                    value={song?.url_cover || ""}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="producer"
                    placeholder="Nhà sản xuất"
                    value={song?.producer || ""}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="composer"
                    placeholder="Người sáng tác"
                    value={song?.composer || ""}
                    onChange={handleChange}
                />
                
                <select
                    value={song?.artists.length ? song.artists[0].id_artist : ""}  
                    onChange={handleArtistSelect}
                >
                    <option value="">Chọn nghệ sĩ</option> 
                    {artists.map(artist => (
                        <option key={artist.id_artist} value={artist.id_artist}>
                            {artist.name}
                        </option>
                    ))}
                </select>
                <select
                    value={song?.types.length ? song.types[0].id_type : ""}  
                    onChange={handleTypeSelect}
                >
                    <option value="">Chọn thể loại</option>
                    {types.map(type => (
                        <option key={type.id_type} value={type.id_type}>
                            {type.name}
                        </option>
                    ))}
                </select>

            </div>
            <button onClick={handleSubmit} disabled={loading}>
                {loading ? "Đang cập nhật..." : "Cập nhật bài hát"}
            </button>
        </div>
    );
}
