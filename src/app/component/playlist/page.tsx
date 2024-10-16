import React from 'react';
import styles from './playlist.module.scss';

const PlaylistPage = () => {
  return (
    <div className={styles.playlistPage}>
      <h1 className={styles.title}>Playlist</h1>
      <div className={styles.tabs}>
        <button className={styles.active}>Tất cả</button>
        <button>Của tôi</button>
      </div>
      <div className={styles.playlistContainer}>
        <div className={styles.playlistItem}>
          <div className={styles.newPlaylist}>
            <span>+</span>
            <p>Tạo playlist mới</p>
          </div>
        </div>
        <div className={styles.playlistItem}>
          <img src="/images/sample_playlist.png" alt="Playlist cover" />
          <h3>Bài hát</h3>
          <p>Đặng Thành Danh</p>
        </div>
        <div className={styles.playlistItem}>
          <img src="/images/sample_playlist.png" alt="Playlist cover" />
          <h3>Music</h3>
          <p>Nguyễn Thành Đặng</p>
        </div>
        {/* Add more playlist items here */}
      </div>
    </div>
  );
};

export default PlaylistPage;
