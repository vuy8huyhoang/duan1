"use client";
import { useEffect, useState } from 'react';
import axios from 'axios';
import styles from './style.module.scss';
import { ReactSVG } from 'react-svg';
import Bxh from '../component/bxh';
import ListType from '../component/listtype';
interface Music {
    id_music: string;
    name: string;
    url_cover: string;
    composer: string;
    types: {
        name: string;
    }[];
}

export default function GrooveChartPage() {
    const [musicData, setMusicData] = useState<Music[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchMusicData = async () => {
            try {
                const response = await axios.get('http://localhost:3001/api/music');
                setMusicData(response.data.data.slice(0, 8));  
                console.log(setMusicData);
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
                        <div className={styles.image}>
                        <img src={music.url_cover} alt={music.name} className={styles.musicCover} />
                       
                        <button className={styles.playButton}>
                                        <ReactSVG src="/play.svg" />
                        </button>
                        </div>
                       
                        <div className={styles.Titles}>
                        <h5 className={styles.musicName}>{music.name} <br /></h5>
                        <p className={styles.musicArtist}>{music.composer}</p>
                        </div>      
                        <div className={styles.moreOptions}>...</div>
                    </div>
                ))}
            </div>
            
            {/* <div className={styles.musicList}>
                {musicData.map((music,index) => (
                    <div key={music.id_music} className={styles.musicCard}> 
                        <h2 className={styles.typeName}>{music.types.map(type => type.name).join(", ")} <br /></h2>
                    </div>
                ))}
            </div> */}



            
        </div>
        
    );
}