// src/app/login/page.tsx
"use client"; // Nếu bạn sử dụng client-side rendering

import { useState } from "react";
import axios from "axios"; // hoặc import từ tệp axios của bạn

const LoginPage = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const response = await axios.post("/api/auth/login", { email, password });
      // Xử lý thành công, ví dụ: lưu token vào localStorage
      console.log("Đăng nhập thành công:", response.data);
      // Chuyển hướng đến trang khác hoặc cập nhật trạng thái người dùng
    } catch (err: any) {
      setError(err.response?.data?.message || "Đăng nhập thất bại");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h1>Đăng Nhập</h1>
      {error && <p style={{ color: "red" }}>{error}</p>}
      <form onSubmit={handleSubmit}>
        <div>
          <label>Email:</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Mật Khẩu:</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <button type="submit" disabled={loading}>
          {loading ? "Đang đăng nhập..." : "Đăng Nhập"}
        </button>
      </form>
    </div>
  );
};

export default LoginPage;
