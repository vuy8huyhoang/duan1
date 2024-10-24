"use client";
import React, { useState } from "react";
import axios from "@/lib/axios";
import styles from "./login.module.scss";
import { ReactSVG } from "react-svg";
import Link from "next/link";

const Login = ({ closePopup }: { closePopup: () => void }) => {
  const [isLogin, setIsLogin] = useState(true);
  const [isForgotPassword, setIsForgotPassword] = useState(false);
  const [loading, setLoading] = useState<boolean>(false);

  const [user, setUser] = useState({
    email: "",
    fullname: "",
    password: "",
  });

  const toggleForm = () => {
    setIsLogin(!isLogin);
  };

  const handleForgotPassword = () => {
    setIsForgotPassword(true);
  };

  const handleBackToLogin = () => {
    setIsForgotPassword(false);
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setUser({ ...user, [name]: value });
  };

  const handleLogin = async (): Promise<void> => {
    setLoading(true);
    try {
      console.log("Login data to submit:", user);

      const response = await axios.post("/login", {
        email: user.email,
        password: user.password,
      });

      const data = response?.data || response;
      const result = data.result || {};

      if (result && result.accessToken) {
        const { accessToken } = result;
        localStorage.setItem("accessToken", accessToken);
        alert("Đăng nhập thành công!");
        const userProfile = await fetchUserProfile();
        if (userProfile && userProfile.fullname) {
          localStorage.setItem("fullname", userProfile.fullname);
        } else {
          console.error("Error fetching the fullname from userProfile");
        }


        closePopup(); 
      } else {
        console.error("Phản hồi không như mong đợi:", data);
        alert("Đăng nhập không thành công: Phản hồi không như mong đợi.");
      }
    } catch (error: any) {
      console.error("Lỗi khi đăng nhập:", error);

      if (error.response) {
        alert(`Lỗi đăng nhập: ${error.response.data?.message || "Kiểm tra lại thông tin đăng nhập."}`);
      } else {
        alert("Đã xảy ra lỗi khi kết nối với server.");
      }
    } finally {
      setLoading(false);
    }
  };



  const fetchUserProfile = async () => {
    try {
      const token = localStorage.getItem("accessToken");

      if (!token) {
        alert("Vui lòng đăng nhập.");
        return null;
      }

      const response = await axios.get("/profile", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      console.log("Full Profile Response:", response);

      const profileData = response?.data?.result;
      console.log("User Profile Data:", profileData);

      if (profileData && profileData.fullname) {
        return profileData;  
      } else {
        console.error("Fullname không tồn tại trong phản hồi:", profileData);
        return null;
      }
    } catch (error) {
      console.error("Lỗi khi lấy thông tin người dùng:", error);
      alert("Không thể lấy thông tin người dùng.");
      return null;
    }
  };









  const handleRegister = async () => {
    setLoading(true);
    try {
      console.log("User data to submit:", user); 

      const response = await axios.post("/register", user, {
        headers: { "Content-Type": "application/json" },
      });

      if (response.status === 200 || response.status === 201) {
        alert("Đăng ký thành công!");
        setIsLogin(true); 
      } else {
        alert("Đăng ký không thành công.");
      }
    } catch (error) {
      console.error("Lỗi khi đăng ký người dùng:", error);
      alert("Đã xảy ra lỗi khi gửi dữ liệu.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={styles.popupOverlay}>
      <div className={styles.popupContent}>
        {!isForgotPassword ? (
          <>
            <h2>{isLogin ? "Đăng nhập vào Groove" : "Đăng ký vào Groove"}</h2>
            <form>
              {isLogin ? (
                <>
                  <div className={styles.formGroup}>
                    <label htmlFor="email">Email</label>
                    <input
                      type="email"
                      id="email"
                      name="email"
                      placeholder="Email"
                      value={user.email}
                      onChange={handleChange}
                      required
                    />
                  </div>
                  <div className={styles.formGroup}>
                    <label htmlFor="password">Mật khẩu</label>
                    <input
                      type="password"
                      id="password"
                      name="password"
                      placeholder="Mật khẩu"
                      value={user.password}
                      onChange={handleChange}
                      required
                    />
                  </div>
                  <button
                    type="button"
                    className={styles.loginBtn}
                    onClick={handleLogin}
                    disabled={loading}
                  >
                    {loading ? "Đang đăng nhập..." : "Đăng nhập"}
                  </button>
                </>
              ) : (
                <>
                  <div className={styles.formGroup}>
                    <label htmlFor="fullname">Họ và tên</label>
                    <input
                      type="text"
                      id="fullname"
                      name="fullname"
                      placeholder="Họ và tên"
                      value={user.fullname}
                      onChange={handleChange}
                      required
                    />
                  </div>
                  <div className={styles.formGroup}>
                    <label htmlFor="email">Email</label>
                    <input
                      type="email"
                      id="email"
                      name="email"
                      placeholder="Email"
                      value={user.email}
                      onChange={handleChange}
                      required
                    />
                  </div>
                  <div className={styles.formGroup}>
                    <label htmlFor="password">Mật khẩu</label>
                    <input
                      type="password"
                      id="password"
                      name="password"
                      placeholder="Mật khẩu"
                      value={user.password}
                      onChange={handleChange}
                      required
                    />
                  </div>
                  <button
                    type="button"
                    className={styles.loginBtn}
                    onClick={handleRegister}
                    disabled={loading}
                  >
                    {loading ? "Đang gửi..." : "Đăng ký"}
                  </button>
                </>
              )}
            </form>
            <p className={styles.forgotPassword}>
              {isLogin && (
                <a href="#" onClick={handleForgotPassword}>
                  Quên mật khẩu của bạn?
                </a>
              )}
            </p>
            <p className={styles.additionalInfo}>
              {isLogin ? (
                <>
                  Bạn chưa có tài khoản?{" "}
                  <a href="#" onClick={toggleForm}>Đăng ký Groove</a>
                </>
              ) : (
                <>
                  Bạn đã có tài khoản?{" "}
                  <a href="#" onClick={toggleForm}>Đăng nhập vào Groove</a>
                </>
              )}
            </p>
          </>
        ) : (
          <>
            <h2>Khôi phục mật khẩu</h2>
            <form>
              <div className={styles.formGroup}>
                <label htmlFor="email">Email hoặc tên người dùng</label>
                <input
                  type="text"
                  id="email"
                  placeholder="Email hoặc tên người dùng"
                />
              </div>
              <button type="submit" className={styles.loginBtn}>
                Tìm tài khoản
              </button>
            </form>
            <p className={styles.backToLogin}>
              <a href="#" onClick={handleBackToLogin}>
                Trở về đăng nhập
              </a>
            </p>
          </>
        )}
        <button className={styles.closeBtn} onClick={closePopup}>
          <ReactSVG src="/close.svg" />
        </button>
      </div>
    </div>
  );
};

export default Login;
