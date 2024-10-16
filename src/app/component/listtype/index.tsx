import { useEffect, useState } from 'react';
import axios from 'axios';
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
        const fetchAlbumData = async () => {
            try {
                const response = await axios.get('http://localhost:3000/api/type');
                setAlbumData(response.data.data.slice(0, 3));  // Lấy 3 album như yêu cầu
                console.log(setAlbumData);
            } catch (error) {
                console.error('Lỗi fetch album', error);
            } finally {
                setLoading(false);
            }
        };

        fetchAlbumData();
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
