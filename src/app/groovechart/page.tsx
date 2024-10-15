// 'use client'

// async function getData() {
//     const res = await fetch('http://localhost:3000/api/music', {
//       cache: 'no-store',
//     });
    
//     if (!res.ok) {
//       throw new Error('Loi data');
//     }
    
//     return res.json();
//   }
  
//   export default async function GrooveChartPage() {
//     const data = await getData();
  
//     return (
//       <div className="flex flex-col bg-[#1c1c3a] text-white h-screen">
//         <main className="flex-1 p-6">
//           <div className="text-3xl font-bold mb-4">#Groovechart</div>
  
//           {/* Danh sách bài hát */}
//           <div className="grid grid-cols-1 gap-4">
//             {data.songs.map((song: any, index: number) => (
//               <div key={index} className="flex items-center justify-between">
//                 <div className="flex items-center space-x-4">
//                   {/* <img src={song} alt={song} className="w-16 h-16" /> */}
//                   <div>
//                     <div className="text-xl">{song.id_music}</div>
//                     <div className="text-gray-400">{song.name}</div>
//                   </div>
//                 </div>
//               </div>
//             ))}
//           </div>
//         </main>
//       </div>
//     );
//   }
  
"use client";

import { useEffect, useState } from 'react';
import axios from 'axios';
import styles from './style.module.scss'
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
                setMusicData(response.data.data.slice(0, 3));  // Fetch only 3 albums
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
            <h1 className={styles.title}>Nghe gần đây</h1>
            <div className={styles.musicList}>
                {musicData.map((music) => (
                    
                    <div key={music.id_music} className={styles.musicCard}>
                         <h5 className="card-title text-success">{music.name} <br /></h5>
                        <img src={music.url_cover} alt={music.name} className={styles.musicCover} />
                       
                    </div>
                    
                ))}
            </div>
        </div>
    );
}