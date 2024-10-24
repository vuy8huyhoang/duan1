import React, { useEffect, useState } from 'react'; 
import styles from './Header.module.scss'; // Import SCSS
import Login from '../auth';
const Header: React.FC = () => {
  const [showLogin, setShowLogin] = useState(false);
  const [userFullname, setUserFullname] = useState<string | null>(null);

  const toggleLoginPopup = () => {
    setShowLogin((prev) => !prev);
  };
  useEffect(() => {
    const fullname = localStorage.getItem("fullname");
    setUserFullname(fullname);
  }, [showLogin]);
  return (
    
    <header className={styles.zingHeader}>
      <div className={styles.headerLeft}>
        <i className="fa fa-arrow-left"></i>
        <i className="fa fa-arrow-right"></i>
      </div>
      <div className={styles.headerRight}>
      
      </div>
      <div className={styles.headerCenter}>
        <input type="text" placeholder="Tìm kiếm bài hát, tác giả..." />
      </div>
      <div className={styles.headerRight}>
        <img src="/Vector.svg" alt="" />
        <img src="/Group 24.svg" alt="" />
        <img
          src="/Setting.svg"
          alt="Settings"
          onClick={toggleLoginPopup}
          style={{ cursor: 'pointer' }}
        />
        {userFullname && <span className={styles.username}>{userFullname}</span>}

      </div>
      {showLogin && <Login closePopup={toggleLoginPopup} />}
    </header>
  );
};

export default Header;
