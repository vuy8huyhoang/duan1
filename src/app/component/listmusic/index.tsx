import React, { useState, useEffect } from 'react';
import axios from 'axios';
import style from './listmusic.module.scss';
import { ReactSVG } from 'react-svg';

interface Album {
    id: number;
    name: string;
    url_cover: string;
    artist: string;
    genre: string;
    release: string;
    composer: string;
}

const ListMusic: React.FC = () => {
    const [albums, setAlbums] = useState<Album[]>([]);
    const [isLoading, setIsLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);
    const [activeFilter, setActiveFilter] = useState<string>('Tất cả');

    useEffect(() => {
        const fetchAlbums = async () => {
            try {
                const response = await axios.get('http://localhost:3000/api/music');
                console.log(response.data);
                setAlbums(response.data.data.slice(0, 6));
                setIsLoading(false);
            } catch (error: any) {
                setError(error.message);
                setIsLoading(false);
            }
        };

        fetchAlbums();
    }, []);

    const handleFilterClick = (filter: string) => {
        setActiveFilter(filter);
    };

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
                <button className={`${style.filter} ${activeFilter === 'Tất cả' ? style.active : ''}`} onClick={() => handleFilterClick('Tất cả')}>Tất cả</button>
                <button className={`${style.filter} ${activeFilter === 'Việt Nam' ? style.active : ''}`} onClick={() => handleFilterClick('Việt Nam')}>Việt Nam</button>
                <button className={`${style.filter} ${activeFilter === 'Quốc tế' ? style.active : ''}`} onClick={() => handleFilterClick('Quốc tế')}>Quốc tế</button>
            </div>

            <div className={style.albumList}>
                {filteredAlbums.length > 0 ? (
                    filteredAlbums.map((album) => (
                        <div className={style.songCard} key={album.id}>
                            <div className={style.albumCoverWrapper}>
                                <img src={album.url_cover} alt={album.name} className={style.albumCover} />
                                <div className={style.overlay}>
                                    <button className={style.playButton}>
                                        <i className="fas fa-play"></i>
                                    </button>
                                </div>
                            </div>
                            <div className={style.songInfo}>
                                <div className={style.songName}>{album.name}</div>
                                <div className={style.composerName}>{album.composer}</div>
                            </div>
                            <div className={style.songControls}>
                                <i className="fas fa-heart"></i>
                                <i className="fas fa-ellipsis-h"></i>
                            </div>
                        </div>


                    ))
                ) : (
                        <div style={{ color: 'white' }}>Không có bài hát nào được tìm thấy</div>
                )}
            </div>

            
        </>
    );
};

export default ListMusic;
