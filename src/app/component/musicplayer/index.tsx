// import React, { useEffect, useRef } from 'react';
// import styles from './musicplayer.module.scss';

// const MusicPlayer: React.FC = () => {

//     const audioRef = useRef<HTMLAudioElement>(new Audio());

//     useEffect(() => {
//         if (currentSong) {
//             audioRef.current.src = currentSong.src;
//             if (isPlaying) {
//                 audioRef.current.play();
//             } else {
//                 audioRef.current.pause();
//             }
//         }
//     }, [currentSong, isPlaying]);

//     return (
//         <div className={styles.musicPlayer}>
//             {currentSong && (
//                 <>
//                     <img src={currentSong.cover} alt="Cover" className={styles.cover} />
//                     <div className={styles.songDetails}>
//                         <h3>{currentSong.name}</h3>
//                         <p>{currentSong.artist}</p>
//                     </div>
//                     <button onClick={togglePlayPause}>
//                         {isPlaying ? '⏸' : '▶️'}
//                     </button>
//                 </>
//             )}
//         </div>
//     );
// };

// export default MusicPlayer;
