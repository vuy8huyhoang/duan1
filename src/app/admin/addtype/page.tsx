"use client";
import { useState, useEffect } from "react";
import axios from "@/lib/axios";
import styles from "./AddType.module.scss";

interface Type {
    id_type: string;
    name: string;
    slug: string;
    created_at: string;
    is_show: number;
}

export default function AddType() {
    const [type, setType] = useState<Type>({
        id_type: "",
        name: "",
        slug: "",
        created_at: new Date().toISOString(),
        is_show: 1,
    });

    const [loading, setLoading] = useState<boolean>(false);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setType({ ...type, [name]: value });
    };

    const handleSubmit = async () => {
        setLoading(true);
        const slug = type.name.toLowerCase().replace(/\s+/g, '-');
        const typeData = { ...type, slug };

        try {
            const response = await axios.post("/type", typeData, {
                headers: { "Content-Type": "application/json" },
            });

            if (response.status === 200 || response.status === 201) {
                alert("Thể loại đã được thêm thành công!");
                window.location.href = "/admin/types"; // Đường dẫn đến trang quản lý thể loại
            } else {
                alert("Thêm thể loại không thành công.");
            }
        } catch (error) {
            console.error("Error submitting type data:", error);
            alert("Đã xảy ra lỗi khi gửi dữ liệu.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className={styles.container}>
            <h2>Thêm mới thể loại</h2>
            <div className={styles.formGroup}>
                <input
                    type="text"
                    name="name"
                    placeholder="Tên thể loại"
                    value={type.name}
                    onChange={handleChange}
                />
                <div>
                    <label>
                        <input
                            type="checkbox"
                            name="is_show"
                            checked={type.is_show === 1}
                            onChange={() => setType({ ...type, is_show: type.is_show === 1 ? 0 : 1 })}
                        />
                        Hiện thị
                    </label>
                </div>
            </div>

            <button onClick={handleSubmit} disabled={loading}>
                {loading ? "Đang gửi..." : "Thêm thể loại"}
            </button>
        </div>
    );
}
