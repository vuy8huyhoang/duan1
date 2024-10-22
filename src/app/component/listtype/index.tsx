import { useEffect, useState } from 'react';
import axios from '@/lib/axios';
import style from './listtype.module.scss'; // Import file CSS module
import { ReactSVG } from 'react-svg';

interface Type {
    id_type: string;
    name: string;
    slug: string;

}

export default function ListType() {
    const [albumData, setAlbumData] = useState<Type[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get('/type')
            .then((response: any) => {
                console.log('Full API response:', response); 

                if (response && response.result && response.result.data) {
                    setAlbumData(response.result.data.slice(0, 3)); 
                } else {
                    console.error('Response data is undefined or null:', response);
                    setAlbumData([]); 
                }
            })
            .catch((error: any) => {
                console.error('Lỗi fetch album:', error); 
                setAlbumData([]); 
            })
            .finally(() => {
                setLoading(false); 
            });
    }, []);



    return (
        <>
            <div className={style.albumGrid}>
                {loading ? (
                    <p>Đang tải album...</p>
                ) : (
                    albumData.map((album) => (
                        <div key={album.id_type} className={style.albumCard}>
                            <a className={style.albumTitle}>{album.name}</a>
                        </div>
                    ))
                )}
            </div>
        </>
    );
}
