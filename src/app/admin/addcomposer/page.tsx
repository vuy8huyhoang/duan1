"use client";
import { useState } from "react";
import axios from "@/lib/axios";
import styles from "./AddComposer.module.scss";
import { v4 as uuidv4 } from 'uuid';

interface Composer {
    id_composer: string;
    name: string;
    created_at: string;
    last_update:string;
}
export default function AddComposer() {
    const [composer, setComposer] = useState<Composer>({
        id_composer: uuidv4(),
        name: "", 
        created_at: new Date().toISOString(),
        last_update: new Date().toISOString(),
    });

    const [loading, setLoading] = useState<boolean>(false);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const { name, value } = e.target;
        setComposer({ ...composer, [name]: value });  
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
        const slug = removeVietnameseTones(composer.name);  // Tạo slug không dấu từ tên nghệ sĩ
        const composerData = { ...composer, slug };

        console.log("Artist data to submit:", composerData);  // Log để kiểm tra dữ liệu trước khi gửi

        try {
            const response = await axios.post("/composer", composerData, {
                headers: { 
                    "Content-Type": "application/json",
                    "Authorization": `Bearer YOUR_TOKEN_HERE`, 
                },
            });

            if (response.status === 200 || response.status === 201) {
                alert("Nghệ sĩ đã được thêm thành công!");
                window.location.href = "/admin/admincomposer";  // Điều hướng về trang quản lý nghệ sĩ
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
                    value={composer.name}
                    onChange={handleChange}
                />
                <button onClick={handleSubmit} disabled={loading}>
                    {loading ? "Đang gửi..." : "Thêm nghệ sĩ"}
                </button>
            </div>
        </div>
    );
}