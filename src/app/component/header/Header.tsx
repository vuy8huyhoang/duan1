import React, { useEffect, useState } from 'react';
import styles from './Header.module.scss';
import Login from '../auth';
import Link from 'next/link';
const Header: React.FC = () => {
  const [showLogin, setShowLogin] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState<boolean>(false);
  const [showDropdown, setShowDropdown] = useState(false); 

  const toggleLoginPopup = () => {
    if (!isLoggedIn) {
      setShowLogin((prev) => !prev);
    }
  };

  const toggleDropdown = () => {
    if (isLoggedIn) {
      setShowDropdown((prev) => !prev); 
    }
  };
  const closeDropdown=()=>{
    setShowDropdown(false);
  }
  const handleLogout = () => {
    localStorage.removeItem("accessToken");
    setIsLoggedIn(false);
    setShowDropdown(false);
  };

  useEffect(() => {
    const accessToken = localStorage.getItem("accessToken");
    if (accessToken) {
      setIsLoggedIn(true);
      setShowLogin(false); 
    } else {
      setIsLoggedIn(false);
    }
  }, [showLogin]);

  return (
    <header className={styles.zingHeader}>
      <div className={styles.headerLeft}>
        <i className="fa fa-arrow-left"></i>
        <i className="fa fa-arrow-right"></i>
      </div>
      <div className={styles.headerCenter}>
        <input type="text" placeholder="Tìm kiếm bài hát, tác giả..." />
      </div>
      <div className={styles.headerRight}>
        <img src="/Vector.svg" alt="" />
        <img src="/Group 24.svg" alt="" />

        <div className={styles.settingsContainer}>
          {isLoggedIn ? (
            <>
              <img
                src="/Setting.svg"
                alt="Settings"
                onClick={toggleDropdown}
                style={{ cursor: 'pointer' }}
              />
              {showDropdown && (
                <div className={styles.dropdownMenu}>
                  <ul>
                  <li onClick={closeDropdown}><Link href="/profile">Tài Khoản</Link></li>
                    <li onClick={handleLogout}>Đăng xuất</li>
                    
                  </ul>
                </div>
              )}
            </>
          ) : (
            <img
              src="/Setting.svg"
              alt="Settings"
              onClick={toggleLoginPopup}
              style={{ cursor: 'pointer' }}
            />
          )}
        </div>
      </div>

      {showLogin && !isLoggedIn && <Login closePopup={toggleLoginPopup} />}
    </header>
  );
};

export default Header;
