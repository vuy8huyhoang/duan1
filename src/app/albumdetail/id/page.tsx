import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import axios from '@/lib/axios';
import style from './albumdetail.module.scss';

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

export default function AlbumDetail() {
    const { id } = useParams(); // Lấy id từ URL
    const [albumDetail, setAlbumDetail] = useState<AlbumDetail | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get(`/album/${id}`)
            .then((response: any) => {
                console.log(response);
                if (response && response.data) {
                    setAlbumDetail(response.data);
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
        return <p>Đang tải chi tiết album...</p>;
    }

    if (!albumDetail) {
        return <p>Không tìm thấy album</p>;
    }

    return (
        <div className={style.albumDetail}>
            <h1>{albumDetail.name}</h1>
            <img src={albumDetail.url_cover} alt={albumDetail.name} className={style.albumCover} />
            <p>Ngày phát hành: {albumDetail.release_date ? albumDetail.release_date : 'Chưa có thông tin'}</p>
            <p>Nghệ sĩ: {albumDetail.artist.name}</p>

            <h2>Danh sách bài hát</h2>
            <ul>
                {albumDetail.musics.length > 0 ? (
                    albumDetail.musics.map((track, index) => (
                        <li key={index}>
                            {track.name ? track.name : 'Chưa có tên bài hát'} - {track.total_duration ? track.total_duration : 'Chưa có thời lượng'}
                        </li>
                    ))
                ) : (
                    <p>Album này hiện chưa có bài hát nào.</p>
                )}
            </ul>
        </div>
    );
}
