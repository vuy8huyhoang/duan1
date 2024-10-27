"use client";

import { useEffect, useState } from "react";
import axios from "@/lib/axios";
import styles from "../EditAlbum.module.scss";

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

interface Album {
    id_album: string;
    name: string;
    slug: string;
    url_cover: string;
    release_date: string | null;
    created_at: string;
    last_update: string;
    is_show: number;
    artists: { id_artist: string; name: string }[];
    types: { id_type: string; name: string }[];
}

export default function EditAlbum({ params }: { params: { id: string } }) {
    const [album, setAlbum] = useState<Album | null>(null);
    const [artists, setArtists] = useState<Artist[]>([]);
    const [types, setTypes] = useState<Type[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [formattedDate, setFormattedDate] = useState<string>("");

    // Lấy danh sách nghệ sĩ và thể loại
    useEffect(() => {
        axios.get("/artist").then((response: any) => {
            if (response?.result?.artistList) {
                setArtists(response.result.artistList);
            }
        });
        axios.get("/type").then((response: any) => {
            if (response?.result?.data) {
                setTypes(response.result.data);
            }
        });
    }, []);

    // Fetch dữ liệu album
    useEffect(() => {
        if (params.id) {
            axios
                .get(`/album/${params.id}`)
                .then((response: any) => {
                    if (response && response.result && response.result.data) {
                        const albumData = response.result.data;

                        if (albumData.release_date) {
                            const date = new Date(albumData.release_date);
                            const formatted = date.toISOString().split("T")[0];
                            setFormattedDate(formatted);
                        }

                        setAlbum(albumData);
                    } else {
                        setAlbum(null);
                    }
                })
                .catch((error: any) => {
                    console.error("Lỗi fetch album:", error);
                    setAlbum(null);
                })
                .finally(() => {
                    setLoading(false);
                });
        }
    }, [params.id]);

    if (loading) return <p>Đang tải...</p>;
    if (!album) return <p>Không tìm thấy album.</p>;

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setAlbum({ ...album, [name]: value } as Album);
    };

    const handleArtistSelect = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const selectedArtistId = e.target.value;

        setAlbum((prevAlbum) => {
            if (prevAlbum) {
                return {
                    ...prevAlbum,
                    artists: [{ id_artist: selectedArtistId, name: prevAlbum.artists.find(artist => artist.id_artist === selectedArtistId)?.name || "" }],
                };
            }
            return prevAlbum;
        });
    };

    const handleTypeSelect = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const selectedTypeId = e.target.value;

        setAlbum((prevAlbum) => {
            if (prevAlbum) {
                return {
                    ...prevAlbum,
                    types: [{
                        id_type: selectedTypeId,
                        name: prevAlbum.types?.find(type => type.id_type === selectedTypeId)?.name || ""
                    }],
                };
            }
            return prevAlbum;
        });
    };


    const handleSubmit = async () => {
        setLoading(true);
        const slug = album?.name.toLowerCase().replace(/\s+/g, "-");

        const albumData = {
            ...album,
            slug,
            release_date: album?.release_date || null,
            last_update: new Date().toISOString(),
        };

        try {
            const response = await axios.patch(`/album/${params.id}`, albumData, {
                headers: {
                    "Content-Type": "application/json",
                },
            });

            if (response.status === 200 || response.status === 204) {
                alert("Album đã được cập nhật thành công!");
                window.location.href = "/admin/adminalbum";
            } else {
                alert("Cập nhật album không thành công.");
            }
        } catch (error:any) {
            console.error("Error updating album data:", error);
            alert("Đã xảy ra lỗi khi cập nhật dữ liệu.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className={styles.container}>
            <h2>Chỉnh sửa album</h2>
            <div className={styles.formGroup}>
                <input
                    type="text"
                    name="name"
                    placeholder="Tên album"
                    value={album?.name || ""}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="url_cover"
                    placeholder="URL ảnh bìa"
                    value={album?.url_cover || ""}
                    onChange={handleChange}
                />
                <input
                    type="date"
                    name="release_date"
                    value={formattedDate}
                    onChange={handleChange}
                />
                <select
                    value={album && album.artists && album.artists.length ? album.artists[0].id_artist : ""}
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
                    value={album && album.types && album.types.length ? album.types[0].id_type : ""}
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
                {loading ? "Đang cập nhật..." : "Cập nhật album"}
            </button>
        </div>
    );
}
