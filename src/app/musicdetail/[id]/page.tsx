
'use client'
import React, { useEffect, useState } from 'react';
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
    artists:{
        name:string;
    }[];
    types:{
        name:string;
    }[];
    release_date: string;
    composer: string;
    total_duration: string | null;
}

const SongDetailPage: React.FC = ({params}) => {
    const id = params.id;
    const [musicdetail, setMusic] = useState<Music | null>(null);
    const [loading, setLoading] = useState(true);
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
                    setMusic(response.result.data);
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
    if (loading) {
        return <p>Đang tải chi tiết bài hát...</p>;
    }

    if (!musicdetail) {
        return <p>Không tìm thấy music</p>;
    }
    return (
        <div className={style.contentwrapper}>
                    <div className={style.modalContent}>
                        <div className={style.modalContentRight}>
                        
                        <img src={musicdetail.url_cover} alt={musicdetail.name} className={style.coverImage} />
                        <h2>{musicdetail.name}</h2>
                        <p><strong>Nghệ sĩ:</strong> {musicdetail.artists.map(artist=>artist.name).join(",")}</p>
                        </div>

                       <div className={style.modalContentLeft}>
                        <p>Bài Hát</p>
                        <div className={style.songContent}>
                            <p className={style.songTitle}> Ca sĩ: {musicdetail.name}</p>
                            {musicdetail.release_date && <p className={style.songArtist}> {formatDate(musicdetail.release_date)}</p>}
                            <p className={style.songDuration}> Nhạc sĩ: {musicdetail.composer}</p>
                           
                        </div>
                        <audio controls src={musicdetail.url_path}></audio>
                       </div>
                        
                    </div>
                    <AlbumHot />
                    <MusicPartner />  
        </div>
        
    );
};

export default SongDetailPage;
