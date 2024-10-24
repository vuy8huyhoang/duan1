import React, { useState, useEffect, useRef } from 'react';
import axios from '@/lib/axios';
import style from './listmusic.module.scss';
import { ReactSVG } from 'react-svg';
import Link from 'next/link';

interface Album {
    id: number;
    name: string;
    url_cover: string;
    url_path: string;
    artist: string;
    genre: string;
    release: string;
    composer: string;
    music:string;
    musics:{
       id_music: string
    }
}


const ListMusic: React.FC = () => {
    const [albums, setAlbums] = useState<Album[]>([]);
    const [currentSong, setCurrentSong] = useState<Album | null>(null);
    const [isPlaying, setIsPlaying] = useState<boolean>(false);
    const [hoveredSong, setHoveredSong] = useState<number | null>(null);
    const [activeFilter, setActiveFilter] = useState<string>('Tất cả');
    const audioRef = useRef<HTMLAudioElement | null>(null);

    useEffect(() => {
        axios.get('/music')
            .then((response: any) => {
                if (response && response.result && response.result.data) {
                    setAlbums(response.result.data.slice(0, 6));
                }
            })
            .catch((error: any) => console.error('Error fetching albums:', error));
    }, []);

    useEffect(() => {
        if (audioRef.current && currentSong) {
            audioRef.current.src = currentSong.url_path;
            audioRef.current.play();
            setIsPlaying(true);
        }
    }, [currentSong]);

    const handlePlayPause = (album: Album) => {
        if (currentSong?.id === album.id && isPlaying) {
            audioRef.current?.pause();
            setIsPlaying(false);
        } else {
            setCurrentSong(album);
            setIsPlaying(true);
        }
    };

    const handleFilterClick = (filter: string) => setActiveFilter(filter);

    const filteredAlbums = activeFilter === 'Tất cả'
        ? albums
        : albums.filter(album => album.genre === activeFilter);

    return (
        <>
            <div className={style.headerSection}>
                <h2>Mới phát hành</h2>
                <div className={style.all}>
                    <a href="#" className={style.viewAllButton}>Tất cả</a>
                    <ReactSVG className={style.csvg} src="/all.svg" />
                </div>
            </div>

            <div className={style.filterBar}>
                {['Tất cả', 'Việt Nam', 'Quốc tế'].map((filter) => (
                    <button
                        key={filter}
                        className={`${style.filter} ${activeFilter === filter ? style.active : ''}`}
                        onClick={() => handleFilterClick(filter)}
                    >
                        {filter}
                    </button>
                ))}
            </div>

            <div className={style.albumList}>
                {filteredAlbums.map((album) => (
                    
                    <div
                        key={album.id}
                        className={style.songCard}
                        onMouseEnter={() => setHoveredSong(album.id)}
                        onMouseLeave={() => setHoveredSong(null)}
                    >
                        <div className={style.albumCoverWrapper}>
                            <img src={album.url_cover} alt={album.name} className={style.albumCover} />
                            <div className={style.overlay}>
                                <button
                                    className={style.playButton}
                                    onClick={() => handlePlayPause(album)}
                                >
                                    {album.id === currentSong?.id && isPlaying ? (
                                        <i className="fas fa-pause"></i>
                                    ) : hoveredSong === album.id ? (
                                        <i className="fas fa-play"></i>
                                    ) : (
                                        <i className="fas fa-play"></i>
                                    )}
                                </button>
                            </div>
                        </div>                   
                    
                        <div className={style.songInfo}>
                                <div className={style.songName}><Link href={`/musicdetail/${album.id}`}>{album.name}</Link></div>
                            <div className={style.composerName}><Link href={`/musicdetail/${album.id}`}>{album.composer}</Link></div>
                        </div>
                        <div className={style.songControls}>
                            <i className="fas fa-heart"></i>
                            <i className="fas fa-ellipsis-h"></i>
                        </div>
                    </div>
                ))}
            </div>

            <audio ref={audioRef}></audio>
        </>
    );
};

export default ListMusic;
