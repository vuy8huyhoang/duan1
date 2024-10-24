'use client';
import { useEffect, useState } from 'react';
import axios from '@/lib/axios';
import style from './albumdetail.module.scss';
import AlbumHot from '@/app/component/albumhot';
import MusicPartner from '@/app/component/musicpartner';

interface Artist {
    id_artist: string;
    name: string;
    slug: string;
    url_cover: string;
}

interface Music {
    id_music: string | null;
    name: string | null;
    url_path: string | null;
    total_duration: string | null;
    artist?: Artist; 
    producer:string;
}

interface AlbumDetail {
    id_album: string;
    name: string;
    slug: string;
    url_cover: string;
    release_date: string | null;
    artist: Artist;
    musics: Music[];
}

export default function AlbumDetail({ params }) {
    const id = params.id; // Get id from URL
    const [albumDetail, setAlbumDetail] = useState<AlbumDetail | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get(`/album/${id}`)
            .then((response: any) => {
                if (response && response.result.data) {
                    setAlbumDetail(response.result.data);
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
        return <p>Đang tải chi tiết album...</p>;
    }

    if (!albumDetail) {
        return <p>Không tìm thấy album</p>;
    }

    return (
        <div className={style.contentwrapper}>
            <div className={style.image}>
                <img src="./public/banner.jpg" alt="" />
            </div>
            <div className={style.albumDetail}>
                <div className={style.albumDetailright}>
                    <h1>{albumDetail.name}</h1>
                    <img src={albumDetail.url_cover} alt={albumDetail.name} className={style.albumCover} />
                    <p>Ngày phát hành: {albumDetail.release_date ? albumDetail.release_date : 'Chưa có thông tin'}</p>
                    <p>Nghệ sĩ: {albumDetail.artist.name}</p>
                    <button className={style.playButton}>Phát Ngẫu Nhiên</button>
                </div>
                <div className={style.albumDetailleft}>
                    <h2>Danh sách bài hát</h2>
                    <div className={style.songHeader}>
                        <span className={style.songNumber}></span>
                        <span className={style.songTitle}>Tên bài hát</span>
                        <span className={style.songArtist}>Nhà Sản Xuất</span>
                        <span className={style.songDuration}>Thời gian</span>
                    </div>
                    <ul className={style.songList}>
                        {albumDetail.musics.length > 0 ? (
                            albumDetail.musics.map((track, index) => (
                                
                                <li key={index} className={style.songItem}>
                                    <span className={style.songNumber}>{index + 1}</span> 
                                    <span className={style.songTitle}>
                                        {track.name ? track.name : 'Chưa có tên bài hát'}
                                    </span>
                                    <span className={style.songArtist}>
                                        {track.producer ? track.producer : 'Chưa có nghệ sĩ'}
                                    </span>
                                    <span className={style.songDuration}>
                                        {track.total_duration ? track.total_duration : 'Chưa có thời lượng'}
                                    </span>
                                </li>
                            ))
                        ) : (
                            <p>Album này hiện chưa có bài hát nào.</p>
                        )}
                    </ul>
                </div>
            </div>

            <AlbumHot />
            <MusicPartner />
        </div>
    );
}
