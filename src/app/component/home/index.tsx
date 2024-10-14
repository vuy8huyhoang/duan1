import styles from './home.module.scss';
import { useState } from 'react';
export default function Home() {
    const [activeItem, setActiveItem] = useState('Khám Phá');

    const handleMenuClick = (item: any) => {
        setActiveItem(item);
    };

    return (
        <div className={styles.sidebar}></div>
    );
}
