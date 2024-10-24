import React, { useState } from 'react'; 
import styles from './Header.module.scss'; // Import SCSS
import Login from '../login';
const Header: React.FC = () => {
  const [showLogin, setShowLogin] = useState(false); // State to control the popup

  const toggleLoginPopup = () => {
    setShowLogin((prev) => !prev); // Toggle the popup visibility
  };
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
      </div>
      {showLogin && <Login closePopup={toggleLoginPopup} />}
    </header>
  );
};

export default Header;
