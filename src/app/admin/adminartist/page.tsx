"use client";
import { useEffect, useState } from "react";
import axios from "@/lib/axios";
import styles from "./AdminArtist.module.scss";
import { ReactSVG } from "react-svg";
import Link from 'next/link';

interface Artist {
    id_artist: string;
    name: string;
    slug: string | null;
    url_cover: string ;
    created_at: string;
    last_update: string;
    is_show: number;
    followers: number;
}

export default function AdminArtist() {
    const [artists, setArtists] = useState<Artist[]>([]);
    const [loading, setLoading] = useState<boolean>(true);

    useEffect(() => {
        axios
            .get("/artist")
            .then((response: any) => {
                console.log("Full API response:", response);
                if (response && response.result && response.result.data) {
                    setArtists(response.result.data);
                } else {
                    console.error("Response data is undefined or empty:", response);
                    setArtists([]);
                }
            })
            .catch((error: any) => {
                console.error("Lỗi fetch ca sĩ:", error);
                setArtists([]);
            })
            .finally(() => {
                setLoading(false);
            });
    }, []);

    const handleDeleteArtist = async (id_artist: string, url: string) => {
        try {
            await axios.delete(`/artist/${id_artist}`);
            setArtists(artists.filter((artist) => artist.id_artist !== id_artist));
            await axios.delete("/delete-image", {url: url})
        } catch (error) {
            console.error("Lỗi xóa ca sĩ:", error);
        }
    };

    return (
        <div className={styles.container}>
            <div className={styles.header}>
                <h1>Quản lý ca sĩ</h1>
                <Link href="/admin/addartist" passHref>
                    <button className={styles.addButton}>
                        <ReactSVG className={styles.csvg} src="/plus.svg" />
                        <div className={styles.addText}>Tạo ca sĩ mới</div>
                    </button>
                </Link>
            </div>

            <div className={styles.tableContainer}>
                <table className={styles.artistTable}>
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" />
                            </th>
                            <th>ID</th>
                            <th>Hình ảnh</th>
                            <th>Tên ca sĩ</th>
                            <th>Ngày tạo</th>
                            <th>Tính năng</th>
                        </tr>
                    </thead>
                    <tbody>
                        {loading ? (
                            <tr>
                                <td colSpan={6} className={styles.loading}>
                                    Đang tải...
                                </td>
                            </tr>
                        ) : (
                            artists.map((artist) => (
                                <tr key={artist.id_artist}>
                                    <td>
                                        <input type="checkbox" />
                                    </td>
                                    <td>#{artist.id_artist}</td>
                                    <td><img src={artist.url_cover} alt={artist.name} /></td>
                                    <td>{artist.name}</td>
                                    <td>{new Date(artist.created_at).toLocaleString('vi-VN', {
                                        year: 'numeric',
                                        month: '2-digit',
                                        day: '2-digit',
                                        hour12: false
                                    })}</td>
                                    <td className={styles.actions}>
                                        <button className={styles.editButton}>
                                            <Link href={`/admin/editartist/${artist.id_artist}`} passHref>
                                                <ReactSVG className={styles.csvg} src="/Rectangle 80.svg" />
                                            </Link>
                                        </button>
                                        <button className={styles.deleteButton} onClick={() => handleDeleteArtist(artist.id_artist, artist.url_cover)}>
                                            <ReactSVG className={styles.csvg} src="/Rectangle 79.svg" />
                                        </button>
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
