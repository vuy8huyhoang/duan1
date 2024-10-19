import { useState, useEffect } from 'react';
import styles from './sidebar.module.scss';
import { ReactSVG } from 'react-svg';

export default function Sidebar() {
    const [activeItem, setActiveItem] = useState<string>('Khám Phá'); // Khởi tạo trạng thái mặc định

    // Hàm xử lý khi click vào menu
    const handleMenuClick = (item: string, path: string) => {
        setActiveItem(item);
        if (typeof window !== 'undefined') {
            localStorage.setItem('activeItem', item); // Lưu vào localStorage
            window.location.href = path; // Điều hướng sang trang mới
        }
    };

    // Kiểm tra giá trị từ localStorage khi component mount
    useEffect(() => {
        if (typeof window !== 'undefined') {
            const storedItem = localStorage.getItem('activeItem');
            if (storedItem) {
                setActiveItem(storedItem);
            }
        }
    }, []); // Chạy khi component mount lần đầu

    return (
        <div className={styles.sidebar}>
            <div className={styles.logo}>
                <a href="/">
                    <img src="/logo.svg" alt="Groove Logo" />
                </a>
            </div>
            <ul className={styles.menu}>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Thư Viện' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Thư Viện', '/playlist')}
                >
                    <ReactSVG className={styles.csvg} src="/Group (1).svg" />
                    <span>Thư Viện</span>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Khám Phá' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Khám Phá', '/')}
                >
                    <ReactSVG className={styles.csvg} src="/earth_light.svg" />
                    <span>Khám Phá</span>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === '#groovechart' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('#groovechart', '/groovechart')}
                >
                    <ReactSVG className={styles.csvg} src="/Vector (1).svg" />
                    <span>#groovechart</span>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'BXH Nhạc Mới' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('BXH Nhạc Mới', '#')}
                >
                    <ReactSVG className={styles.csvg} src="/Vector (2).svg" />
                    <span>BXH Nhạc Mới</span>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Chủ Đề & Thể Loại' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Chủ Đề & Thể Loại', '/type')}
                >
                    <ReactSVG className={styles.csvg} src="/type_light.svg" />
                    <span>Chủ Đề & Thể Loại</span>
                </li>
            </ul>
            <ul className={styles.submenu}>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Nghe gần đây' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Nghe gần đây', '#')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10.svg" />
                    <span>Nghe gần đây</span>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Bài hát yêu thích' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Bài hát yêu thích', '#')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (1).svg" />
                    <span>Bài hát yêu thích</span>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Playlist' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Playlist', '#')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (2).svg" />
                    <span>Playlist</span>
                </li>
                <li
                    className={`${styles.menuItem} ${activeItem === 'Album' ? styles.active : ''}`}
                    onClick={() => handleMenuClick('Album', '#')}
                >
                    <ReactSVG className={styles.csvg} src="/Frame 10 (3).svg" />
                    <span>Album</span>
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
