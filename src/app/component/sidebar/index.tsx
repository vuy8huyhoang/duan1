import { useState } from 'react';
import styles from './sidebar.module.scss';
import { ReactSVG } from 'react-svg';
import clsx from 'clsx';
import Link from 'next/link';

export default function Sidebar() {
    const [activeItem, setActiveItem] = useState('Khám Phá');

    const handleMenuClick = (item: string) => {
        setActiveItem(item);
    };

    return (
        <div className={styles.sidebar}>
            <div className={styles.logo}>
                <a href="/"><img src="/logo.svg" alt="Groove Logo" /></a>
            </div>
            <ul className={styles.menu}>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Thư Viện' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Thư Viện')}
                >
                    <ReactSVG className={styles.csvg} src="/Group (1).svg" />
                    <Link href="/playlist">Thư Viện</Link>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Khám Phá' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Khám Phá')}
                >
                    <ReactSVG className={styles.csvg} src="/earth_light.svg" />
                    <Link href="/">Khám Phá</Link>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === '#groovechart' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('#groovechart')}
                >
                    <ReactSVG className={styles.csvg} src="/Vector (1).svg" />
                    <Link href="/groovechart">#groovechart</Link>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'BXH Nhạc Mới' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('BXH Nhạc Mới')}
                >
                    <ReactSVG className={styles.csvg} src="/Vector (2).svg" />
                    <Link href="#">BXH Nhạc Mới</Link>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Chủ Đề & Thể Loại' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Chủ Đề & Thể Loại')}
                >
                    <ReactSVG className={styles.csvg} src="/type_light.svg" />
                    <Link href="/type">Chủ Đề & Thể Loại</Link>
                </li>
            </ul>
            <ul className={styles.submenu}>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Nghe gần đây' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Nghe gần đây')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10.svg" />
                    <Link href="#">Nghe gần đây</Link>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Bài hát yêu thích' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Bài hát yêu thích')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (1).svg" />
                    <Link href="#">Bài hát yêu thích</Link>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Playlist' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Playlist')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (2).svg" />
                    <Link href="#">Playlist</Link>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Album' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Album')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (3).svg" />
                    <Link href="#">Album</Link>
                </li>
            </ul>
            <div className={styles.createPlaylist}>
                <button>
                    <ReactSVG src="/vector (3).svg" />
                    Tạo playlist mới
                </button>
            </div>
        </div>
    );
}
