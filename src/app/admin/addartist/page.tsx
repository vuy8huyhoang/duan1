"use client";
import { useState } from "react";
import axios from "@/lib/axios";
import styles from "./AddArtist.module.scss";
import { v4 as uuidv4 } from 'uuid';

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

export default function AddArtist() {
    const [artist, setArtist] = useState<Artist>({
        id_artist: uuidv4(),
        name: "",
        slug: null,
        url_cover: "",
        created_at: new Date().toISOString(),
        last_update: new Date().toISOString(),
        is_show: 1,
        followers: 0,
    });

    const [loading, setLoading] = useState<boolean>(false);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const { name, value } = e.target;
        setArtist({ ...artist, [name]: value });  
    };
    const removeVietnameseTones = (str: string) => {
        return str
            .normalize('NFD') 
            .replace(/[\u0300-\u036f]/g, '') 
            .replace(/đ/g, 'd')  
            .replace(/Đ/g, 'D') 
            .replace(/[^a-zA-Z0-9\s]/g, '')  
            .replace(/\s+/g, '-') 
            .toLowerCase(); 
    };


    const handleSubmit = async () => {
        setLoading(true);
        const slug = removeVietnameseTones(artist.name);  // Tạo slug không dấu từ tên nghệ sĩ
        const artistData = { ...artist, slug };

        console.log("Artist data to submit:", artistData);  // Log để kiểm tra dữ liệu trước khi gửi

        try {
            const response = await axios.post("/artist", artistData, {
                headers: { "Content-Type": "application/json" },
            });

            if (response.status === 200 || response.status === 201) {
                alert("Nghệ sĩ đã được thêm thành công!");
                window.location.href = "/admin/adminartist";  // Điều hướng về trang quản lý nghệ sĩ
            } else {
                alert("Thêm nghệ sĩ không thành công.");
            }
        } catch (error) {
            console.error("Lỗi khi gửi dữ liệu nghệ sĩ:", error);
            alert("Đã xảy ra lỗi khi gửi dữ liệu.");
        } finally {
            setLoading(false);
        }
    };



    return (
        <div className={styles.container}>
            <h2>Thêm mới nghệ sĩ</h2>
            <div className={styles.formGroup}>
                <input
                    type="text"
                    name="name"
                    placeholder="Tên nghệ sĩ"
                    value={artist.name}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="url_cover"
                    placeholder="URL hình ảnh"
                    value={artist.url_cover}
                    onChange={handleChange}
                />
                <button onClick={handleSubmit} disabled={loading}>
                    {loading ? "Đang gửi..." : "Thêm nghệ sĩ"}
                </button>
            </div>
        </div>
    );
}
