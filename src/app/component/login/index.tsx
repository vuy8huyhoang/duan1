import React, { useState } from 'react';
import styles from './login.module.scss';
import { ReactSVG } from 'react-svg';
import Link from 'next/link';

const Login = ({ closePopup }: { closePopup: () => void }) => {
  const [isLogin, setIsLogin] = useState(true); 
  const [isForgotPassword, setIsForgotPassword] = useState(false);

  const toggleForm = () => {
    setIsLogin(!isLogin); 
  };

  const handleForgotPassword = () => {
    setIsForgotPassword(true); 
  };

  const handleBackToLogin = () => {
    setIsForgotPassword(false); 
  };

  return (
    <div className={styles.popupOverlay}>
      <div className={styles.popupContent}>
        {!isForgotPassword ? ( 
          <>
            <h2>{isLogin ? 'Đăng nhập vào Groove' : 'Đăng ký vào Groove'}</h2>
            <form>
              {!isLogin && (
                <div className={styles.formGroup}>
                  <label htmlFor="name">Họ và tên</label>
                  <input type="text" id="name" placeholder="Họ và tên" />
                </div>
              )}
              <div className={styles.formGroup}>
                <label htmlFor="username">Email hoặc tên người dùng</label>
                <input type="text" id="username" placeholder="Email hoặc tên người dùng" />
              </div>
              <div className={styles.formGroup}>
                <label htmlFor="password">Mật khẩu</label>
                <input type="password" id="password" placeholder="Mật khẩu" />
              </div>
              <button type="submit" className={styles.loginBtn}>
                {isLogin ? 'Đăng nhập' : 'Đăng ký'}
              </button>
            </form>
            <p className={styles.forgotPassword}>
              {isLogin && (
                <a href="#" onClick={handleForgotPassword}>Quên mật khẩu của bạn?</a>
              )}
            </p>
            <p className={styles.additionalInfo}>
              {isLogin ? (
                <>
                  Bạn chưa có tài khoản?{' '}
                  <a href="#" onClick={toggleForm}>Đăng ký Groove</a>
                </>
              ) : (
                <>
                  Bạn đã có tài khoản?{' '}
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
                <input type="text" id="email" placeholder="Email hoặc tên người dùng" />
              </div>
              <button type="submit" className={styles.loginBtn}>
                Tìm tài khoản
              </button>
            </form>
            <p className={styles.backToLogin}>
              <a href="#" onClick={handleBackToLogin}>Trở về đăng nhập</a>
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
