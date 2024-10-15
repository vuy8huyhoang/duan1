"use client";
import styles from './MusicCard.module.scss'; // Import the corresponding styles

interface MusicCardProps {
    title: string;
    artist: string;
    image: string;
}

const MusicCard: React.FC<MusicCardProps> = ({ title, artist, image }) => {
    return (
        <div className={styles.musicCard}>
            <img src={image} alt={title} className={styles.musicCover} />
            <h3 className={styles.musicTitle}>{title}</h3>
            <p className={styles.musicArtist}>{artist}</p>
        </div>
    );
};

export default MusicCard;
