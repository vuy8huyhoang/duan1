import React, { useEffect, useState } from 'react';
import axios from '@/lib/axios';
import style from './FavoriteAlbum.module.scss';

interface FavoriteAlbum {
    id_album: number;
    name: string;
    url_cover: string;
}

const FavoriteAlbumPage = () => {
    const [favoriteAlbums, setFavoriteAlbums] = useState<FavoriteAlbum[]>([]);

    useEffect(() => {
        const fetchFavoriteAlbums = async () => {
            try {
                const response: any = await axios.get("/favorite-album/me");
                console.log('Favorite Album Data:', response.result.data);

                const albums = response.data.map((album: any) => ({
                  ...album,
                  id_album: Number(album.id_album),  // Chuyển id_album từ string sang number
              }));

              setFavoriteAlbums(albums);
            } catch (error:any) {
                console.error("Failed to fetch favorite albums", error);
            }
        };
        fetchFavoriteAlbums();
    }, []);

    return (
        <div className={style.favoritePage}>
            <div className={style.albumGrid}>
                {favoriteAlbums.map((album) => (
                    <div key={album.id_album} className={style.albumItem}>
                        <img src={album.url_cover || "/default-cover.png"} alt={album.name} />
                        <p>{album.name}</p>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default FavoriteAlbumPage;
