import React, { useState, useEffect } from 'react';
import axios from 'axios';
import style from './listmusictop.module.scss';
import { ReactSVG } from 'react-svg';

interface Album {
    id: number;
    name: string;
    url_cover: string;
    artist: string;
    genre: string;
    created_at: string;
    composer: string;
}

const ListMusicTop: React.FC = () => {
    const [albums, setAlbums] = useState<Album[]>([]);
    const [isLoading, setIsLoading] = useState<boolean>(true);
    const [currentIndex, setCurrentIndex] = useState<number>(0); // Quản lý chỉ số slide hiện tại

    useEffect(() => {
        const fetchAlbums = async () => {
            try {
                const response = await axios.get('http://localhost:3000/api/music');
                setAlbums(response.data.data.slice(0, 6)); // Lấy 6 album đầu tiên
                setIsLoading(false);
            } catch (error: any) {
                console.error(error);
                setIsLoading(false);
            }
        };

        fetchAlbums();
    }, []);

    const nextSlide = () => {
        // Tăng chỉ số và quay lại đầu nếu vượt quá số album
        setCurrentIndex((prevIndex) => {
            const maxIndex = Math.max(0, albums.length - 3); // Giới hạn chỉ số lớn nhất là album cuối - 3
            return prevIndex + 1 > maxIndex ? 0 : prevIndex + 1; // Di chuyển chỉ số 1 đơn vị
        });
    };

    const prevSlide = () => {
        // Giảm chỉ số và quay lại cuối nếu nhỏ hơn 0
        setCurrentIndex((prevIndex) => {
            const maxIndex = Math.max(0, albums.length - 3);
            return prevIndex - 1 < 0 ? maxIndex : prevIndex - 1; // Di chuyển chỉ số 1 đơn vị
        });
    };

    return (
        <>
            <div className={style.headerSection}>
                <h2>Top bài hát</h2>
                <div className={style.all}>
                    <a href="#" className={style.viewAllButton}>Tất cả</a>
                    <ReactSVG className={style.csvg} src="/all.svg" />
                </div>
            </div>

            <div className={style.sliderContainer}>
                <button onClick={prevSlide} className={style.leftArrow}><ReactSVG src="/back-arrow.svg" /></button> {/* Nút sang trái */}

                <div className={style.albumList}>
                    {isLoading ? (
                        <div style={{ color: 'white' }}>Đang tải...</div>
                    ) : (
                        albums.slice(currentIndex, currentIndex + 3).map((album, index) => ( // Hiển thị 3 album liên tiếp
                            <div className={style.songCard} key={album.id}>
                                <h1 className={style.rank}>{`#${currentIndex + index + 1}`}</h1> {/* Thứ tự */}
                                <div className={style.albumCoverWrapper}>
                                    <img src={album.url_cover} alt={album.name} className={style.albumCover} />
                                    <div className={style.playButton}>
                                        <ReactSVG src="/play.svg" />
                                    </div>
                                </div>
                                <div className={style.songInfo}>
                                    <div className={style.songName}>{album.name}</div>
                                    <div className={style.composerName}>{album.composer}</div>
                                </div>
                            </div>
                        ))
                    )}
                </div>

                <button onClick={nextSlide} className={style.rightArrow}><ReactSVG src="/next-arrow.svg" /></button> {/* Nút sang phải */}
            </div>
        </>
    );
};

export default ListMusicTop;
