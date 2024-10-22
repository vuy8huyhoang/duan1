import React from 'react';
import styles from './AdminSidebar.module.scss';
import Link from 'next/link';
import { ReactSVG } from 'react-svg';

const AdminSidebar: React.FC = () => {
    return (
        <div className={styles.sidebar}>
            <div className={styles.user}>
                <img className={styles.avatar} src="/Group 66.svg" alt="User Avatar" />
                <div className={styles.userInfo}>
                    <p className={styles.userName}><b>Bùi Huy Vũ</b></p>
                    <p className={styles.userWelcome}>Chào mừng bạn trở lại</p>
                </div>
            </div>

            <ul className={styles.menu}>
                <li>
                    <Link href="#" className={`${styles.menuItem} ${styles.active}`}>
                        <ReactSVG className={styles.csvg} src="/Control Panel.svg"/> Bảng điều khiển
                    </Link>
                </li>
                <li>
                    <Link href="#" className={styles.menuItem}>
                        <ReactSVG className={styles.csvg} src="/Music video.svg" /> Quản lý bài hát
                    </Link>
                </li>
                <li>
                    <Link href="#" className={styles.menuItem}>
                        <ReactSVG className={styles.csvg} src="/Category.svg" /> Quản lý thể loại
                    </Link>
                </li>
                <li>
                    <Link href="#" className={styles.menuItem}>
                        <ReactSVG className={styles.csvg} src="/Album.svg" /> Quản lý album
                    </Link>
                </li>
                <li>
                    <Link href="#" className={styles.menuItem}>
                        <ReactSVG className={styles.csvg} src="/iconamoon_music-artist.svg" /> Quản lý ca sĩ
                    </Link>
                </li>
                <li>
                    <Link href="#" className={styles.menuItem}>
                        <ReactSVG className={styles.csvg} src="/Male User.svg" /> Quản lý người dùng
                    </Link>
                </li>
            </ul>
        </div>
    );
};

export default AdminSidebar;
