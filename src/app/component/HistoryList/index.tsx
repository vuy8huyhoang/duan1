// 'use client'
// import React, { useEffect, useState } from 'react';
// import axios from '@/lib/axios'; // Đảm bảo bạn có axios cài đặt
// import { useRouter } from 'next/router';

// interface MusicHistory {
//   id_music_history: string;
//   id_music: string;
//   play_duration: number;
//   created_at: string;
//   music: {
//     id_music: string;
//     name: string;
//     slug: string;
//     url_path: string;
//     url_cover: string;
//     producer: string;
//     composer: string;
//     release_date: string | null;
//     created_at: string;
//     last_update: string;
//     is_show: number;
//   };
// }

// const HistoryList: React.FC = () => {
//   const [historyList, setHistoryList] = useState<MusicHistory[]>([]);
//   const router = useRouter();

//   useEffect(() => {
//     // Kiểm tra token truy cập
//     const accessToken = localStorage.getItem('accessToken');
//     if (!accessToken) {
//       // Điều hướng đến trang đăng nhập nếu không có token
//       alert('Vui lòng đăng nhập để xem lịch sử.');
//       router.push('/login');
//       return;
//     }

//     // Gọi API để lấy danh sách bài hát đã xem
//     axios
//       .get('/music/history', {
//         headers: {
//           Authorization: `Bearer ${accessToken}`,
//         },
//       })
//       .then((response) => {
//         if (response && response.data) {
//           setHistoryList(response.data.data);
//         }
//       })
//       .catch((error) => {
//         console.error('Lỗi khi lấy lịch sử bài hát:', error);
//       });
//   }, [router]);

//   return (
//     <div>
//       <h2>Danh sách bài hát đã xem</h2>
//       <ul>
//         {historyList.map((history) => (
//           <li key={history.id_music_history}>
//             <img src={history.music.url_cover} alt={history.music.name} width={100} />
//             <h3>{history.music.name}</h3>
//             <p>Nhà sản xuất: {history.music.producer}</p>
//             <p>Nhạc sĩ: {history.music.composer}</p>
//             <audio controls src={history.music.url_path}></audio>
//           </li>
//         ))}
//       </ul>
//     </div>
//   );
// };

// export default HistoryList;
