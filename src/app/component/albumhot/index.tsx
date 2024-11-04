import { useEffect, useState } from 'react';
import axios from '@/lib/axios';
import style from './albumhot.module.scss';
import { ReactSVG } from 'react-svg';
import Link from 'next/link';
interface Album {
    id_album: string;
    name: string;
    url_cover: string;
    artist: {
        name: string;
    };
}
export default function AlbumHot() {
    const [albumData, setAlbumData] = useState<Album[]>([]);
    const [favoriteAlbum, setFavoriteAlbum] = useState<Set<string>>(new Set());
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get("/album")
            .then((response: any) => {
                console.log(response); 
                if (response && response.result && response.result.data) {
                    const albumObj = response.result.data; 
                    setAlbumData(albumObj.slice(0, 5)); 
                } else {
                    console.error('Response result.data is undefined or null', response);
                }
            })
            .catch((error: any) => {
                console.error('Lỗi fetch album', error);
            })
            .finally(() => {
                setLoading(false); 
            });
    }, []);

    const toggleFavorite = async (id_album: string) => {
        const isFavorite = favoriteAlbum.has(id_album);
        setFavoriteAlbum((prev) => {
            const updated = new Set(prev);
            isFavorite ? updated.delete(id_album) : updated.add(id_album);
            return updated;
        });
    
        try {
            if (isFavorite) {
                // Nếu đã là yêu thích, xóa khỏi yêu thích
                await axios.delete(`/favorite-album/me`, { data: { id_album } });
            } else {
                // Nếu chưa yêu thích, thêm vào yêu thích
                await axios.post(`/favorite-album/me`, { id_album, favorite: true });
            }
        } catch (error) {
            console.error('Lỗi khi cập nhật trạng thái yêu thích:', error);
        }
    };


    return (
        <>
            <div className={style.headerSection}>
                <h2>Mới phát hành</h2>
                <div className={style.all}>
                    <a href="#" className={style.viewAllButton}>Tất cả</a>
                    <ReactSVG className={style.csvg} src="/all.svg" />
                </div>
            </div>

            <div className={style.albumGrid}>
                {loading ? (
                    <p>Đang tải album...</p>
                ) : (
                    albumData.map((album) => (
                        <div key={album.id_album} className={style.albumCard}>
                            <div className={style.albumWrapper}>
                                <img src={album.url_cover} alt={album.name} className={style.albumCover} />
                                <div className={style.overlay}>
                                <button className={style.likeButton} onClick={() => toggleFavorite(album.id_album)}>
                                    <ReactSVG src="/heart.svg" className={favoriteAlbum.has(album.id_album) ? style.activeHeart : ''} 
                                    style={{ fill: favoriteAlbum.has(album.id_album) ? 'red' : 'initial' }}
                                    />
                                </button>
                                    <button className={style.playButton}>
                                        <ReactSVG src="/play.svg" />
                                    </button>
                                    <button className={style.moreButton}>
                                        <ReactSVG src="/more.svg" />
                                    </button>
                                </div>
                            </div>
                            <Link href={`/albumdetail/${album.id_album}`}  className={style.albumTitle}>{album.name}</Link>
                            <Link href={`/albumdetail/${album.id_album}`} className={style.artistName}>{album.artist.name}</Link>
                        </div>
                    ))
                )}
            </div>
        </>
    );
}
