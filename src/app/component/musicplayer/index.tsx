import React, { useState, useEffect, useRef } from 'react';
import styles from './musicplayer.module.scss';

interface Music {
    id_music: string;
    name: string;
    slug: string;
    url_cover: string;
    url_path: string;
}

const MusicPlayer: React.FC = () => {
    const [currentSong, setCurrentSong] = useState<Music | null>(null);
    const [isPlaying, setIsPlaying] = useState(false);
    const audioRef = useRef<HTMLAudioElement>(new Audio());

    useEffect(() => {
        if (currentSong) {
            audioRef.current.src = currentSong.url_path;
            if (isPlaying) {
                audioRef.current.play();
            } else {
                audioRef.current.pause();
            }
        }

        return () => {
            audioRef.current.pause();
            audioRef.current.src = ''; 
        };
    }, [currentSong, isPlaying]);

    const togglePlayPause = () => {
        if (isPlaying) {
            audioRef.current.pause();
        } else {
            audioRef.current.play();
        }
        setIsPlaying(!isPlaying);
    };

    useEffect(() => {
        setCurrentSong({
            id_music: '1',
            name: 'Sample Song',
            slug: 'sample-song',
            url_cover: 'path_to_cover_image.jpg',
            url_path: 'path_to_audio_file.mp3',
        });
    }, []);

    return (
        <div className={styles.musicPlayer}>
            {currentSong && (
                <>
                    <img src={currentSong.url_cover} alt="Cover" className={styles.cover} /> {/* Using url_cover from Music interface */}
                    <div className={styles.songDetails}>
                        <h3>{currentSong.name}</h3>
                        <p>{currentSong.slug}</p> {/* Displaying slug or any other information as needed */}
                    </div>
                    <button onClick={togglePlayPause} className={styles.playPauseButton}>
                        {isPlaying ? '⏸' : '▶️'}
                    </button>
                </>
            )}
        </div>
    );
};

export default MusicPlayer;
