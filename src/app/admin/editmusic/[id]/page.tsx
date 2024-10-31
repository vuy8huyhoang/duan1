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

interface Composer {
    id_composer: string;
    name: string;
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
    artists: { id_artist: string; name: string }[];
    types: { id_type: string; name: string }[];
    composers: { id_composer: string; name: string }[];
}

export default function EditMusic({ params }: { params: { id: string } }) {
    const [song, setSong] = useState<Song | null>(null);
    const [artists, setArtists] = useState<Artist[]>([]);
    const [types, setTypes] = useState<Type[]>([]);
    const [composers, setComposers] = useState<Composer[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [message, setMessage] = useState<string>("");

    const [file, setFile] = useState<File | null>(null);
    const [previewUrl, setPreviewUrl] = useState<string | null>(null);

    const [audioFile, setAudioFile] = useState<File | null>(null);
    const [audioPreviewUrl, setAudioPreviewUrl] = useState<string | null>(null);

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
        axios.get("/composer").then((response: any) => {
            if (response?.result?.data) {
                setComposers(response.result.data);
            }
        });
    }, []);

    useEffect(() => {
        if (params.id) {
            axios
                .get(`/music/${params.id}`)
                .then((response: any) => {
                    if (response?.result?.data) {
                        const songData = response.result.data;
                        setSong(songData);

                        if (songData.url_cover) {
                            setPreviewUrl(songData.url_cover);
                        }
                        if (songData.url_path) {
                            setAudioPreviewUrl(songData.url_path);
                        }

                        console.log("Song data fetched:", songData);
                    }
                })
                .catch((error: any) => {
                    console.error("Lỗi fetch bài hát:", error);
                })
                .finally(() => {
                    setLoading(false);
                });
        }
    }, [params.id]);

    const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files[0]) {
            setFile(e.target.files[0]);

            const fileUrl = URL.createObjectURL(e.target.files[0]);
            setPreviewUrl(fileUrl); 
        }
    };

    const handleAudioChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files[0]) {
            setAudioFile(e.target.files[0]);

            const audioUrl = URL.createObjectURL(e.target.files[0]);
            setAudioPreviewUrl(audioUrl); 
        }
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
            composer: song?.composer || null,
            release_date: song?.release_date || null,
            last_update: new Date().toISOString(),
            artists: song?.artists.map(artist => artist.id_artist),
            types: song?.types.map(type => type.id_type),
            composers: song?.composers.map(composer => composer.id_composer),
        };

        console.log("Data being sent:", songData); 

        try {
            if (file) {
                const imageFormData = new FormData();
                imageFormData.append("file", file);
                const imageUploadResponse: any = await axios.post("/upload-image", imageFormData, {
                    headers: { "Content-Type": "multipart/form-data" },
                });
                const imageUrl = imageUploadResponse?.result?.url;
                if (imageUrl) {
                    songData.url_cover = imageUrl;
                } else {
                    setMessage("Lỗi khi tải ảnh lên.");
                    return;
                }
            }

            if (audioFile) {
                const audioFormData = new FormData();
                audioFormData.append("file", audioFile);
                const audioUploadResponse: any = await axios.post("/upload-audio", audioFormData, {
                    headers: { "Content-Type": "multipart/form-data" },
                });
                const audioUrl = audioUploadResponse?.result?.url;
                if (audioUrl) {
                    songData.url_path = audioUrl;
                } else {
                    setMessage("Lỗi khi tải tệp âm thanh lên.");
                    return;
                }
            }

            console.log("Sending updated song data:", songData); // Check the final song data

            const response = await axios.patch(`/music/${params.id}`, songData, {
                headers: { "Content-Type": "application/json" },
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


    if (loading) return <p>Đang tải...</p>;
    if (!song) return <p>Không tìm thấy bài hát.</p>;

    return (
        <div className={styles.container}>
            <h2>Chỉnh sửa bài hát</h2>
            <div className={styles.formGroup}>
                <input
                    type="text"
                    name="name"
                    placeholder="Tên bài hát"
                    value={song?.name || ""}
                    onChange={(e) => setSong({ ...song, name: e.target.value } as Song)}
                />

                <input
                    type="text"
                    name="producer"
                    placeholder="Nhà sản xuất"
                    value={song?.producer || ""}
                    onChange={(e) => setSong({ ...song, producer: e.target.value } as Song)}
                />

                <select
                    value={song?.artists.length > 0 ? song.artists[0].id_artist : ""}
                    onChange={(e) => {
                        const selectedArtistId = e.target.value;
                        setSong((prevSong) => ({
                            ...prevSong,
                            artists: [{ id_artist: selectedArtistId, name: "" }],
                        }));
                    }}
                >
                    <option value="">Chọn nghệ sĩ</option>
                    {artists.map((artist) => (
                        <option key={artist.id_artist} value={artist.id_artist}>
                            {artist.name}
                        </option>
                    ))}
                </select>

                <select
                    value={song?.types.length > 0 ? song.types[0].id_type : ""}
                    onChange={(e) => {
                        const selectedTypeId = e.target.value;
                        setSong((prevSong) => ({
                            ...prevSong,
                            types: [{ id_type: selectedTypeId, name: "" }],
                        }));
                    }}
                >
                    <option value="">Chọn thể loại</option>
                    {types.map((type) => (
                        <option key={type.id_type} value={type.id_type}>
                            {type.name}
                        </option>
                    ))}
                </select>

                

                {previewUrl && (
                    <div className={styles.preview}>
                        <img src={previewUrl} alt="Xem trước ảnh bìa" />
                    </div>
                )}
                <label htmlFor="file-upload" className={styles.customFileUpload}>
                    Chọn ảnh bìa
                </label>
                <input
                    id="file-upload"
                    type="file"
                    style={{ display: "none" }}
                    onChange={handleFileChange}
                />

                {audioPreviewUrl && (
                    <div className={styles.preview}>
                        <audio controls src={audioPreviewUrl}>
                            Trình duyệt của bạn không hỗ trợ phát âm thanh.
                        </audio>
                    </div>
                )}
                <label htmlFor="audio-upload" className={styles.customFileUpload}>
                    Chọn tệp âm thanh
                </label>
                <input
                    id="audio-upload"
                    type="file"
                    style={{ display: "none" }}
                    onChange={handleAudioChange}
                />
            </div>

            <button onClick={handleSubmit} disabled={loading}>
                {loading ? "Đang cập nhật..." : "Cập nhật bài hát"}
            </button>
            {message && <div className={styles.message}>{message}</div>}
        </div>
    );
}
