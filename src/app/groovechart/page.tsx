"use client";
import { useEffect, useState } from 'react';
import axios from 'axios';
import styles from './style.module.scss';
interface Music {
    id_music: string;
    name: string;
    url_cover: string;
}

export default function GrooveChartPage() {
    const [musicData, setMusicData] = useState<Music[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchMusicData = async () => {
            try {
                const response = await axios.get('http://localhost:3000/api/music');
                setMusicData(response.data.data.slice(0, 8));  
                console.log(musicData);
            } catch (error) {
                console.error('Lỗi fetch album', error);
            } finally {
                setLoading(false);
            }
        };

        fetchMusicData();
    }, []);

    return (
        <div className={styles.contentwrapper}>

            <h1 className={styles.title}>#Groovechart</h1>
            <div>
                <img src="" alt="" />
            </div>
            <div className={styles.musicList}>
                {musicData.map((music,index) => (
                    
                    <div key={music.id_music} className={styles.musicCard}>
                        <span className={styles.index}>{index + 1}.</span>
                        <img src={music.url_cover} alt={music.name} className={styles.musicCover} />
                        <h5 className="card-title text-success">{music.name} <br /></h5>
                        <div className={styles.moreOptions}>...</div>
                    </div>
                    
                ))}
            </div>
        </div>
    );
}