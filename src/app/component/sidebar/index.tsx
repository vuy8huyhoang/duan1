
import { useState } from 'react';
import styles from './sidebar.module.scss';
import { ReactSVG } from 'react-svg';

export default function Sidebar() {
    const [activeItem, setActiveItem] = useState('Khám Phá');

    const handleMenuClick = (item: any) => {
        setActiveItem(item);
    };

    return (
        <div className={styles.sidebar}>
            <div className={styles.logo}>
                <img src="/logo.svg" alt="Groove Logo" />
            </div>
            <ul className={styles.menu}>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Thư Viện' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Thư Viện')}
                >
                    <ReactSVG className={styles.csvg} src="/Group (1).svg" />
                    <a href="#">Thư Viện</a>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Khám Phá' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Khám Phá')}
                >
                    <ReactSVG className={styles.csvg} src="/earth_light.svg"  />
                    <a href="#">Khám Phá</a>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === '#groovechart' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('#groovechart')}
                >
                    <ReactSVG className={styles.csvg} src="/Vector (1).svg"  />
                    <a href="#">#groovechart</a>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'BXH Nhạc Mới' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('BXH Nhạc Mới')}
                >
                    <ReactSVG className={styles.csvg} src="/Vector (2).svg"  />
                    <a href="#">BXH Nhạc Mới</a>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Chủ Đề & Thể Loại' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Chủ Đề & Thể Loại')}
                >
                    <ReactSVG className={styles.csvg} src="/type_light.svg"  />
                    <a href="#">Chủ Đề & Thể Loại</a>
                </li>
            </ul>
            <ul className={styles.submenu}>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Nghe gần đây' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Nghe gần đây')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10.svg"  />
                    <a href="#">Nghe gần đây</a>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Bài hát yêu thích' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Bài hát yêu thích')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (1).svg"  />
                    <a href="#">Bài hát yêu thích</a>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Playlist' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Playlist')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (2).svg"  />
                    <a href="#">Playlist</a>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Album' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Album')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (3).svg" />
                    <a href="#">Album</a>
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
