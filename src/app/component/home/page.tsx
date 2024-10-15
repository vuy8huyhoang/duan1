"use client";

import styles from './home.module.scss'; 
import { useEffect, useState } from 'react';
import axios from 'axios';
import ListMusic from '../listmusic';
import ListAlbum from '../listalbum';

interface Album {
    id_album: string;
    name: string;
    url_cover: string;
}

export default function Home() {
    const [albumData, setAlbumData] = useState<Album[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchAlbumData = async () => {
            try {
                const response = await axios.get('http://localhost:3000/api/album');
                setAlbumData(response.data.data.slice(0, 3));  
            } catch (error) {
                console.error('Lỗi fetch album', error);
            } finally {
                setLoading(false);
            }
        };

        fetchAlbumData();
    }, []);

    return (<>
        <div className={styles.contentwrapper}>
            <div className={styles.albumList}>
                {albumData.map((album) => (
                    <div key={album.id_album} className={styles.albumCard}>
                        <img src={album.url_cover} alt={album.name} className={styles.albumCover} />
                    </div>
                ))}
            </div>
            
            
        </div>
        <ListMusic />
        <ListAlbum/>
    </>
    );
}
