import React from 'react';
import styles from './Header.module.scss'; // Import SCSS

const Header: React.FC = () => {
  return (
    <header className={styles.zingHeader}>
      <div className={styles.headerLeft}>
        <i className="fa fa-arrow-left"></i>
      </div>
      <div className={styles.headerCenter}>
        <input type="text" placeholder="Tìm kiếm bài hát, tác giả..." />
      </div>
      <div className={styles.headerRight}>
        
        <img src="/Group 24.svg" alt="" />
        <img src="/Setting.svg" alt="" />
      </div>
    </header>
  );
};

export default Header;
