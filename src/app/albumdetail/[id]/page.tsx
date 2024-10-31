'use client';
import { useEffect, useState, useRef, useCallback } from 'react';
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
    release_date: string;
    artist: Artist;
    musics: Music[];
}

// export default function AlbumDetail({ params }) {
//     const id = params.id; // Get id from URL
//     const [albumDetail, setAlbumDetail] = useState<AlbumDetail | null>(null);
//     const [loading, setLoading] = useState(true);

//     useEffect(() => {
//         axios.get(`/album/${id}`)
//             .then((response: any) => {
//                 if (response && response.result.data) {
//                     setAlbumDetail(response.result.data);
//                 } else {
//                     console.error('Response data is undefined or null', response);
//                 }
//             })
//             .catch((error: any) => {
//                 console.error('Error fetching album details', error);
//             })
//             .finally(() => {
//                 setLoading(false);
//             });
//     }, [id]);

//     if (loading) {
//         return <p>Đang tải chi tiết album...</p>;
//     }

//     if (!albumDetail) {
//         return <p>Không tìm thấy album</p>;
//     }

//     return (
//         <div className={style.contentwrapper}>
//             <div className={style.image}>
//                 <img src="./public/banner.jpg" alt="" />
//             </div>
//             <div className={style.albumDetail}>
//                 <div className={style.albumDetailright}>
//                     <h1>{albumDetail.name}</h1>
//                     <img src={albumDetail.url_cover} alt={albumDetail.name} className={style.albumCover} />
//                     <p>Ngày phát hành: {albumDetail.release_date ? albumDetail.release_date : 'Chưa có thông tin'}</p>
//                     <p>Nghệ sĩ: {albumDetail.artist.name}</p>
//                     <button className={style.playButton}>Phát Ngẫu Nhiên</button>
//                 </div>
//                 <div className={style.albumDetailleft}>
//                     <h2>Danh sách bài hát</h2>
//                     <div className={style.songHeader}>
//                         <span className={style.songNumber}></span>
//                         <span className={style.songTitle}>Tên bài hát</span>
//                         <span className={style.songArtist}>Nhà Sản Xuất</span>
//                         <span className={style.songDuration}>Thời gian</span>
//                     </div>
//                     <ul className={style.songList}>
//                         {albumDetail.musics.length > 0 ? (
//                             albumDetail.musics.map((track, index) => (
                                
//                                 <li key={index} className={style.songItem}>
//                                     <span className={style.songNumber}>{index + 1}</span> 
//                                     <span className={style.songTitle}>
//                                         {track.name ? track.name : 'Chưa có tên bài hát'}
//                                     </span>
//                                     <span className={style.songArtist}>
//                                         {track.producer ? track.producer : 'Chưa có nghệ sĩ'}
//                                     </span>
//                                     <span className={style.songDuration}>
//                                         {track.total_duration ? track.total_duration : 'Chưa có thời lượng'}
//                                     </span>
//                                 </li>
//                             ))
//                         ) : (
//                             <p>Album này hiện chưa có bài hát nào.</p>
//                         )}
//                     </ul>
//                 </div>
//             </div>

//             <AlbumHot />
//             <MusicPartner />
//         </div>
//     );
// }
// ... existing code ...

export default function AlbumDetail({ params }) {
    const id = params.id; // Get id from URL
    const [albumDetail, setAlbumDetail] = useState<AlbumDetail | null>(null);
    const [currentSong, setCurrentSong] = useState<Music | null>(null);
    const [isPlaying, setIsPlaying] = useState<boolean>(false);
    const [loading, setLoading] = useState(true);
    const audioRef = useRef<HTMLAudioElement | null>(null);
    const [time, setTime] = useState([]);
    useEffect(() => {
        axios.get(`/album/${id}`)
            .then((response: any) => {
                if (response && response.result.data) {
                    setAlbumDetail(response.result.data);
                } else {
                    console.error('Response data is undefined or null', response);
                }
                response.result.data.musics.map((music)=>{
                    const audio = new Audio(music.url_path)
                    audio.onloadedmetadata = () => {
                        console.log(`Thời lượng: ${audio.duration} giây`);
                        setTime(prev=>{
                            return [
                                ...prev,
                                audio.duration
                            ];

                        })
                    };
                })
            })
            .catch((error: any) => {
                console.error('Error fetching album details', error);
            })
            .finally(() => {
                setLoading(false);
            });
    }, [id]);
    function formatTime(seconds) {
        seconds = Math.ceil(seconds)
        const minutes = Math.floor((seconds % 3600) / 60);
        const secs = seconds % 60;
    
        return `${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
    }
    useEffect(() => {
        if (audioRef.current && currentSong) {
            audioRef.current.src = currentSong.url_path;
            audioRef.current.play();
            setIsPlaying(true);
        }
    }, [currentSong]);
    const handleFollowClick = (id_artist) => {
        axios.post(`/follow/me`, {id_artist})   
            .then((response: any) => {
                console.log('Album followed successfully', response);
            })
            .catch((error: any) => {
                console.error('Error following album', error);
            });
    };
    
    const handleHeartClick = (id_album) => {
        axios.post(`/favorite-album/me`, {id_album}) 
            .then((response: any) => {
                console.log('Album liked successfully', response);
            })
            .catch((error: any) => {
                console.error('Error liking album', error);
            });
    };
    const handlePlayRandomClick = () => {
        if (albumDetail && albumDetail.musics.length > 0) {
            const randomIndex = Math.floor(Math.random() * albumDetail.musics.length);
            const randomSong = albumDetail.musics[randomIndex];
            handlePlayPause(randomSong); 
        } else {
            console.log('No songs available to play.');     
        }
    };
    const handlePlayPause = useCallback((album: Music) => {
        if (currentSong?.id_music === album.id_music && isPlaying) {
            audioRef.current?.pause();
            setIsPlaying(false);
        } else {
            setCurrentSong(album);
            setIsPlaying(true);
        }
    }, [currentSong, isPlaying]);
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
                    <div className={style.buttonGroup}>
                        <button className={style.followButton} onClick={()=>handleFollowClick(albumDetail.artist.id_artist)}>Follow</button>
                        <span className={style.heartIcon} onClick={()=>handleHeartClick(albumDetail.id_album)}>♥</span>
                    </div>
                    <button className={style.playButton} onClick={handlePlayRandomClick}>Phát Ngẫu Nhiên</button>
                </div>
                <div className={style.albumDetailleft}>
                    <h2>Danh sách bài hát</h2>
                    <div className={style.songHeader}>
                        <span className={style.songNumber}></span>
                        <span className={style.songTitle}>Tên bài hát</span>
                        <span className={style.songArtist}>Nhà Sản Xuất</span>
                        <span className={style.songDuration}>Thời lượng</span>
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
                                        {time[index] ? formatTime(time[index])  : 'Chưa có thời lượng'}
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
            <audio ref={audioRef} />
        </div>
    );
}

    