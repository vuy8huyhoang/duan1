'use client'
import React, { useEffect, useState, useRef } from 'react';
import { useParams } from 'react-router-dom';
import axios from '@/lib/axios';
import style from './songdetail.module.scss';   
import AlbumHot from '@/app/component/albumhot';
import MusicPartner from '@/app/component/musicpartner';
interface Music {
    id_music: number;
    name: string;
    url_cover: string;
    url_path: string;

    types:{
        name:string;
    }[];
    producer: string;
    release_date: string;
    composer: string;
    total_duration: string | null;
    artists: Artist[];
}
interface Artist {
    id_artist: string;
    name: string;
    slug: string;
    url_cover: string;
}

const SongDetailPage: React.FC = ({params}) => {
    const id = params.id;
    const [musicdetail, setMusic] = useState<Music | null>(null);
    const [artistdetail, setArtist] = useState<Artist | null>(null);
    const [loading, setLoading] = useState(true);
    const audioRef = useRef<HTMLAudioElement | null>(null);
    const [isPlaying, setIsPlaying] = useState(false);

    function formatDate(isoString) {
        // Chuyển đổi chuỗi ISO thành đối tượng Date
        const date = new Date(isoString);
      
        // Lấy ngày, tháng và năm
        const day = date.getUTCDate().toString().padStart(2, '0');
        const month = (date.getUTCMonth() + 1).toString().padStart(2, '0'); // Tháng bắt đầu từ 0
        const year = date.getUTCFullYear();
      
        // Trả về chuỗi theo định dạng ngày/tháng/năm
        return `${day}/${month}/${year}`;
      }
    useEffect(() => {
        axios.get(`/music/${id}`)
            .then((response: any) => {
                if (response && response.result.data) {
                    const musicData: Music = response.result.data;
                    setMusic(musicData);
                    setArtist(musicData.artists[0] || null);
                } else {
                    console.error('Response data is undefined or null', response);
                }
            })
            .catch((error: any) => {
                console.error('Error fetching album details', error);
            })
            .finally(() => {
                setLoading(false);
            });
    }, [id]);
    const handlePlayPause = () => {
        if (audioRef.current) {
            if (isPlaying) {
                audioRef.current.pause();
            } else {
                audioRef.current.play();
            }
            setIsPlaying(!isPlaying);
        }
    };
    const handleHeartClick = async () => {
        try {
            const response = await axios.post("favorite-music/me");
            if (response.status === 200) {
                console.log('Song liked successfully');
                // Optionally update UI or state here
            }
        } catch (error) {
            console.error('Error liking the song', error);
        }
    };
    if (loading) {
        return <p>Đang tải chi tiết bài hát...</p>;
    }

    if (!musicdetail && artistdetail) {
        return <p>Không tìm thấy music</p>;
    }
    return (
        <div className={style.contentwrapper}>
        <div className={style.modalContent}>
            <div className={style.modalContentRight}>
                 <img src={musicdetail.url_cover} alt={musicdetail.name} className={style.coverImage} />
                <h2>{musicdetail.name}</h2>
                <p className={style.songTitle}>Ca sĩ: {artistdetail.name}</p>
            </div>
            <div className={style.modalContentLeft}>
                <p>Bài Hát</p>
                <div className={style.songContent}>
                    <p className={style.songTitle}> Tên Bài Hát: {musicdetail.name}</p>
                    <p className={style.songTitle}> Nhà sản xuất: {musicdetail.producer}</p>
                     <p className={style.songArtist}> Ngày phát hành: {formatDate(musicdetail.release_date)}</p>
                    <p className={style.songDuration}> Nhạc sĩ: {musicdetail.composer}</p>
                </div>
                <div className={style.audioPlayer}>
                    <button onClick={handlePlayPause} className={style.playButton}>
                        {isPlaying ? 'Pause' : 'Play'}
                    </button>
                    <span className={style.heartIcon} onClick={handleHeartClick}>&#9829;</span>
                    <audio ref={audioRef} src={musicdetail.url_path} />
                </div>
            </div>
        </div>
        <AlbumHot />
        <MusicPartner />
       
    </div>
        
    );
};

export default SongDetailPage;
