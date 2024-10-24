
'use client'
import React, { useEffect, useState } from 'react';
// import { useParams } from 'react-router-dom';
import axios from '@/lib/axios';
import style from './songdetail.module.scss';   
interface Music {
    id_music: number;
    name: string;
    url_cover: string;
    url_path: string;
    artist: string;
    genre: string;
    release: string;
    composer: string;
    total_duration: string | null;
}

const SongDetailPage: React.FC = ({params}) => {
    const id = params.id;
    const [musicdetail, setMusic] = useState<Music | null>(null);
    const [loading, setLoading] = useState(true);
    useEffect(() => {
        axios.get(`/music/${id}`)
            .then((response: any) => {
                console.log(response);
                if (response && response.result.data) {
                    setMusic(response.result.data);
                } else {
                    console.error('Response data is undefined or null', response);
                }
            })
            .catch((error: any) => {
                console.error('Lỗi fetch chi tiết album', error);
            })
            .finally(() => {
                setLoading(false);
            });
    }, [id]);
    if (loading) {
        return <p>Đang tải chi tiết bài hát...</p>;
    }

    if (!musicdetail) {
        return <p>Không tìm thấy music</p>;
    }
    return (
        <div className={style.modalOverlay}>
            <div className={style.modalContent}>
                <h2>{musicdetail.name}</h2>
                <img src={musicdetail.url_cover} alt={musicdetail.name} className={style.coverImage} />
                <p><strong>Ca sĩ:</strong> {musicdetail.artist}</p>
                <p><strong>Thể loại:</strong> {musicdetail.genre}</p>
                <p><strong>Ngày phát hành:</strong> {musicdetail.release}</p>
                <p><strong>Nhà soạn nhạc:</strong> {musicdetail.composer}</p>
                <audio controls src={musicdetail.url_path}></audio>
            </div>
        </div>
    );
};

export default SongDetailPage;
