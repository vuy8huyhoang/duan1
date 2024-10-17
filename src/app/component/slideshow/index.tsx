// import React, { useState } from 'react';
// import styles from './slideshow.module.scss'; // Nhập CSS module của bạn

// const images = [
//     "https://photo-zmp3.zmdcdn.me/cover/3/f/4/1/3f41f32d1ca9baeb2206137e5f2eab5c.jpg",
//     "https://photo-zmp3.zmdcdn.me/cover/1/4/b/d/14bde6474eb1bb1c3c3e04e6a6a619fc.jpg",
//     "https://photo-zmp3.zmdcdn.me/cover/2/d/2/d/2d2d88326a507319335ffc2e2887c0b7.jpg",
// ];

// const Slideshow: React.FC = () => {
//     const [currentIndex, setCurrentIndex] = useState(0);

//     const nextSlide = () => {
//         console.log("Next slide clicked");
//         setCurrentIndex((prevIndex) => (prevIndex + 1) % images.length);
//     };

//     const prevSlide = () => {
//         console.log("Previous slide clicked");
//         setCurrentIndex((prevIndex) => (prevIndex - 1 + images.length) % images.length);
//     };

//     return (
//         <div className={styles.slideshow}>
//             <div className={styles.slides}>
//                 {images.map((image, index) => (
//                     <div
//                         key={index}
//                         className={`${styles.slide} ${index === currentIndex ? styles.active : ''}`}
//                     >
//                         <img src={image} alt={`Slide ${index + 1}`} className={styles.slideImage} />
//                     </div>
//                 ))}
//             </div>
//             <button className={styles.prev} onClick={prevSlide}>❮</button>
//             <button className={styles.next} onClick={nextSlide}>❯</button>
//         </div>
//     );
// };

// export default Slideshow;
