import React from 'react';
import styles from './AdminHeader.module.scss';
import { ReactSVG } from 'react-svg';

const AdminHeader: React.FC = () => {
    return (
        <div className={styles.header}>
            <div className={styles.hoverIcon}>

                <ReactSVG className={styles.svgIcon} src="/Exit to app.svg" />
        </div>
        </div>
    );
};

export default AdminHeader;
