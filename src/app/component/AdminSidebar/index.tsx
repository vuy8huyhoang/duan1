import React, { useState, useEffect } from 'react';
import styles from './AdminSidebar.module.scss';
import Link from 'next/link';
import { ReactSVG } from 'react-svg';

const AdminSidebar: React.FC = () => {
    const [activeItem, setActiveItem] = useState<string>('Bảng điều khiển'); // Khởi tạo trạng thái mặc định

    // Hàm xử lý khi click vào menu
    const handleMenuClick = (item: string) => {
        setActiveItem(item);
        if (typeof window !== 'undefined') {
            localStorage.setItem('activeAdminItem', item); // Lưu vào localStorage
        }
    };

    // Kiểm tra giá trị từ localStorage khi component mount
    useEffect(() => {
        if (typeof window !== 'undefined') {
            const storedItem = localStorage.getItem('activeAdminItem');
            if (storedItem) {
                setActiveItem(storedItem);
            }
        }
    }, []); // Chạy khi component mount lần đầu

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
                    <Link
                        href="#"
                        className={`${styles.menuItem} ${activeItem === 'Bảng điều khiển' ? styles.active : ''}`}
                        onClick={() => handleMenuClick('Bảng điều khiển')}
                    >
                        <ReactSVG className={styles.csvg} src="/Control Panel.svg" />
                        <div className={styles.menuText}>Bảng điều khiển</div>
                    </Link>
                </li>
                <li>
                    <Link
                        href="#"
                        className={`${styles.menuItem} ${activeItem === 'Quản lý bài hát' ? styles.active : ''}`}
                        onClick={() => handleMenuClick('Quản lý bài hát')}
                    >
                        <ReactSVG className={styles.csvg} src="/Music video.svg" />
                        <div className={styles.menuText}>Quản lý bài hát</div>
                    </Link>
                </li>
                <li>
                    <Link
                        href="#"
                        className={`${styles.menuItem} ${activeItem === 'Quản lý thể loại' ? styles.active : ''}`}
                        onClick={() => handleMenuClick('Quản lý thể loại')}
                    >
                        <ReactSVG className={styles.csvg} src="/Category.svg" />
                        <div className={styles.menuText}>Quản lý thể loại</div>
                    </Link>
                </li>
                <li>
                    <Link
                        href="#"
                        className={`${styles.menuItem} ${activeItem === 'Quản lý album' ? styles.active : ''}`}
                        onClick={() => handleMenuClick('Quản lý album')}
                    >
                        <ReactSVG className={styles.csvg} src="/Album.svg" />
                        <div className={styles.menuText}>Quản lý album</div>
                    </Link>
                </li>
                <li>
                    <Link
                        href="#"
                        className={`${styles.menuItem} ${activeItem === 'Quản lý ca sĩ' ? styles.active : ''}`}
                        onClick={() => handleMenuClick('Quản lý ca sĩ')}
                    >
                        <ReactSVG className={styles.csvg} src="/iconamoon_music-artist.svg" />
                        <div className={styles.menuText}>Quản lý ca sĩ</div>
                    </Link>
                </li>
                <li>
                    <Link
                        href="#"
                        className={`${styles.menuItem} ${activeItem === 'Quản lý người dùng' ? styles.active : ''}`}
                        onClick={() => handleMenuClick('Quản lý người dùng')}
                    >
                        <ReactSVG className={styles.csvg} src="/Male User.svg" />
                        <div className={styles.menuText}>Quản lý người dùng</div>
                    </Link>
                </li>
            </ul>
        </div>
    );
};

export default AdminSidebar;
