"use client";
import { useEffect, useState } from 'react';
import axios from 'axios';
import styles from './type.module.scss';
import { ReactSVG } from 'react-svg';

// Định nghĩa interface Type
interface Type {
  id_type: string;
  name: string;
  slug: string;
  created_at: string;
  is_show: boolean;
}

const TypePage = () => {
  const [types, setTypes] = useState<Type[]>([]);
  const [showExtraAlbums, setShowExtraAlbums] = useState(false); // Nút "Tất cả" phần trên
  const [showAllForFixedTypes3, setShowAllForFixedTypes3] = useState(false); // Nút "Tất cả" phần dưới

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get("http://localhost:3000/api/type");
        setTypes(response.data.data);
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };
    fetchData();
  }, []);

  const imageMapping: {
    "Top 100": string;
    "Nhạc Trẻ": string;
    "Nhạc Cover": string;
    "BHX Nhạc mới": string;
    "Những Chuyến Đi": string;
    "Việt Nam": string;
    "Nhạc Âu Mỹ": string;
    "Nhạc Hàn": string;
    "Nhạc Hoa": string;

    "DINNER": string;
    "CHILL/THƯ GIẢN": string;
    "DU LỊCH": string;
    "LOFI": string;
    "TIỆC TÙNG": string;
    "WORKOUT": string;
    "RUNNING": string;
    "TẬP TRUNG": string;
    "TÌNH YÊU": string;
    "CÀ PHÊ": string;
    "NGỦ NGON": string;
    "GÓC CHỮA LÀNH": string;
    "CHƠI GAME": string;
    "SPA - YOGA": string;
    "KHÚC NHẠC VUI": string;

  } = {
    "Top 100": "https://photo-zmp3.zmdcdn.me/cover/2/d/2/d/2d2d88326a507319335ffc2e2887c0b7.jpg",
    "Nhạc Trẻ": "https://photo-zmp3.zmdcdn.me/cover/6/6/3/5/6635bad85a570ca140e207910b5d44f1.jpg",
    "Nhạc Cover": "https://photo-zmp3.zmdcdn.me/cover/a/b/1/c/ab1c5fcc30db69252a3220d8d49daebc.jpg",
    "BHX Nhạc mới": "https://photo-zmp3.zmdcdn.me/cover/d/b/e/4/dbe426a555b7d680be25232007739019.jpg",
    "Những Chuyến Đi": "https://photo-zmp3.zmdcdn.me/cover/3/f/4/1/3f41f32d1ca9baeb2206137e5f2eab5c.jpg",
    "Việt Nam": "https://photo-zmp3.zmdcdn.me/cover/9/5/8/e/958e9994c6720513cc84a7f7a478020b.jpg",
    "Nhạc Âu Mỹ": "https://photo-zmp3.zmdcdn.me/cover/d/6/4/0/d640e486023bb0bc1bbe4d94209ff648.jpg",
    "Nhạc Hàn": "https://photo-zmp3.zmdcdn.me/cover/9/0/c/6/90c615657364a570232d7f6e86ffa6da.jpg",
    "Nhạc Hoa": "https://photo-zmp3.zmdcdn.me/cover/0/6/e/0/06e09e84d6c6ef29f588e0c6032d72bf.jpg",

    "DINNER": "https://photo-zmp3.zmdcdn.me/cover/0/8/e/1/08e1f820e5b2c16217c11a4f77f3680b.jpg",
    "CHILL/THƯ GIẢN": "https://photo-zmp3.zmdcdn.me/cover/5/d/9/b/5d9b3a5de0e11982a0207c92b7ac4c5a.jpg",
    "DU LỊCH": "https://photo-zmp3.zmdcdn.me/cover/e/3/d/4/e3d43659c6dc756f87f4e44220313f92.jpg",
    "LOFI": "https://photo-zmp3.zmdcdn.me/cover/7/a/0/0/7a00dbc39931345b369fdf61889302f6.jpg",
    "TIỆC TÙNG": "https://photo-zmp3.zmdcdn.me/cover/0/8/7/8/0878113f776f53892e91935f0913cc0b.jpg",
    "WORKOUT": "https://photo-zmp3.zmdcdn.me/cover/a/f/3/4/af347a1785171f3d7aa4f584d5449b09.jpg",
    "RUNNING": "https://photo-zmp3.zmdcdn.me/cover/8/5/d/1/85d1cfedf63d33e676e85071ab023f66.jpg",
    "TẬP TRUNG": "	https://photo-zmp3.zmdcdn.me/cover/3/b/c/0/3bc090f304669e0a01bc5cccdbc0715a.jpg",
    "TÌNH YÊU": "https://photo-zmp3.zmdcdn.me/cover/b/7/7/5/b775816ff23ba94ed879a6282162f011.jpg",
    "CÀ PHÊ": "https://photo-zmp3.zmdcdn.me/cover/6/6/0/4/6604391a24e584b9ee1cbfd178540ace.jpg",
    "NGỦ NGON": "https://photo-zmp3.zmdcdn.me/cover/4/a/3/b/4a3b5265ee2c9e2c84f5a88194382b5d.jpg",
    "GÓC CHỮA LÀNH": "	https://photo-zmp3.zmdcdn.me/cover/5/6/2/f/562fb982380b49103d885bd16286efe9.jpg",
    "CHƠI GAME": "https://photo-zmp3.zmdcdn.me/cover/4/d/f/4/4df44f0a15edb254717c383cf256b193.jpg",
    "SPA - YOGA": "https://photo-zmp3.zmdcdn.me/cover/d/0/d/7/d0d772a6c3e35b3e768d5c3ebf644ecd.jpg",
    "KHÚC NHẠC VUI": "https://photo-zmp3.zmdcdn.me/cover/5/4/5/4/5454a8586d26bd5e5bdb7682b84dce0f.jpg",

  };

  const fixedTypes1 = [
    { id_type: 1, name: "Top 100" },
    { id_type: 2, name: "Nhạc Trẻ" },
    { id_type: 3, name: "Nhạc Cover" },
    { id_type: 4, name: "BHX Nhạc mới" },
  ];

  const fixedTypes2 = [
    { id_type: 5, name: "Việt Nam" },
    { id_type: 6, name: "Nhạc Âu Mỹ" },
    { id_type: 7, name: "Nhạc Hàn" },
    { id_type: 8, name: "Nhạc Hoa" },
  ];

  const fixedTypes3 = [
    { id_type: 9, name: "DINNER" },
    { id_type: 10, name: "CHILL/THƯ GIẢN" },
    { id_type: 11, name: "DU LỊCH" },
    { id_type: 12, name: "LOFI" },
    { id_type: 14, name: "TIỆC TÙNG" },
    { id_type: 15, name: "WORKOUT" },
    { id_type: 16, name: "RUNNING" },
    { id_type: 17, name: "TẬP TRUNG" },
  ];
  // const fixedTypes4 = [
  //   { id_type: 9, name: "Bolero Ngôi Sao Trẻ" },
  //   { id_type: 10, name: "Bolero Mới Nhất" },
  //   { id_type: 11, name: "Bolero Hay Nhất" },
  //   { id_type: 12, name: "Trữ Tình Việt Nổi Bật" },
  //   { id_type: 14, name: "Nhạc Quê Hương Hôm Nay" },
  // ];
  const additionalTypes = [
    { id_type: 18, name: "TÌNH YÊU" },
    { id_type: 19, name: "CÀ PHÊ" },
    { id_type: 20, name: "NGỦ NGON" },
    { id_type: 21, name: "GÓC CHỮA LÀNH" },
    { id_type: 22, name: "CHƠI GAME" },
    { id_type: 23, name: "SPA - YOGA" },
    { id_type: 24, name: "KHÚC NHẠC VUI" },
  ];
  const extraTypes = [
    { id_type: 5, name: "Những Chuyến Đi" }, // Album thêm
  ];

  const handleShowMoreTop = () => {
    setShowExtraAlbums(true); // Nút "Tất cả" phần trên
  };

  const handleShowMoreBottom = () => {
    setShowAllForFixedTypes3(true); // Nút "Tất cả" phần dưới
  };

  return (
    <>
      {/* <Slideshow/> */}
      <div className={styles.banner}>
        <img src="https://photo-zmp3.zmdcdn.me/cover/3/f/4/1/3f41f32d1ca9baeb2206137e5f2eab5c.jpg" alt="Banner" className={styles.bannerImage} />
      </div>

      <div className={styles.headerSection}>
        <h2>Nổi Bật</h2>
      </div>
      <div className={styles.albumGrid}>
        {fixedTypes1.map((type) => (
          <div key={type.id_type} className={styles.albumCard}>
            <div className={styles.albumWrapper}>
              <img
                src={imageMapping[type.name as keyof typeof imageMapping] || "https://default-image-link.com/default.jpg"}
                alt={type.name}
                className={styles.albumCover}
              />
              <a className={styles.albumTitle}>{type.name}</a>
            </div>
          </div>
        ))}

        {showExtraAlbums && extraTypes.map((type) => (
          <div key={type.id_type} className={styles.albumCard}>
            <div className={styles.albumWrapper}>
              <img
                src={"https://photo-zmp3.zmdcdn.me/cover/8/e/4/a/8e4a3346be739dc204d16d1729e0c74e.jpg"}
                alt={type.name}
                className={styles.albumCover}
              />
              <a className={styles.albumTitle}>{type.name}</a>
            </div>
          </div>
        ))}
      </div>

      <div className={styles.buttonContainer}>
        <button className={styles.button} onClick={handleShowMoreTop}>
          <span className={styles.viewAllButton}>Tất cả</span>
        </button>
      </div>

      <div className={styles.headerSection}>
        <h2>Quốc Gia</h2>
      </div>
      <div className={styles.albumGrid}>
        {fixedTypes2.map((type) => (
          <div key={type.id_type} className={styles.albumCard}>
            <div className={styles.albumWrapper}>
              <img
                src={imageMapping[type.name as keyof typeof imageMapping] || "https://default-image-link.com/default.jpg"}
                alt={type.name}
                className={styles.albumCover}
              />
              <a className={styles.albumTitle}>{type.name}</a>
            </div>
          </div>
        ))}
      </div>
      <div className={styles.banner1}>
        <img src="	https://adtima-media.zascdn.me/2024/05/28/1e75f3b2-dd19-46c6-ae1a-84611017eaf9.jpg" alt="Banner" className={styles.bannerImage1} />
      </div>
      <div className={styles.headerSection}>
        <h2>Tâm Trạng Và Hoạt Động</h2>
      </div>
      <div className={styles.albumGrid}>
        {fixedTypes3.map((type) => (
          <div key={type.id_type} className={styles.albumCard}>
            <div className={styles.albumWrapper}>
              <img
                src={imageMapping[type.name as keyof typeof imageMapping] || "https://default-image-link.com/default.jpg"}
                alt={type.name}
                className={styles.albumCover}
              />
              <a className={styles.albumTitle}>{type.name}</a>
            </div>
          </div>
        ))}
      </div>
      {showAllForFixedTypes3 && (
        <div className={styles.albumGrid}>
          {additionalTypes.map((type) => (
            <div key={type.id_type} className={styles.albumCard}>
              <div className={styles.albumWrapper}>
                <img
                  src={imageMapping[type.name as keyof typeof imageMapping] || "https://default-image-link.com/default.jpg"}
                  alt={type.name}
                  className={styles.albumCover}
                />
                <a className={styles.albumTitle}>{type.name}</a>
              </div>
            </div>
          ))}
        </div>
      )}
      <div className={styles.buttonContainer}>
        <button className={styles.button} onClick={handleShowMoreBottom}>
          <span className={styles.viewAllButton}>Tất cả</span>
        </button>
      </div>
      <div className={styles.headerSection}>
        <h2>Trữ Tình & Bolero</h2>
        <div className={styles.all}>
          <a href="#" className={styles.viewAllButton}>Tất cả</a>
          <ReactSVG className={styles.csvg} src="/all.svg" />
        </div>
      </div>
      <div className={styles.albumContainer}>
        {fixedTypes3.slice(0, 5).map((type) => (
          <div key={type.id_type} className={styles.albumItem}>
            <div className={styles.albumWrapper}>
              <img
                src={imageMapping[type.name as keyof typeof imageMapping] || "https://default-image-link.com/default.jpg"}
                alt={type.name}
                className={styles.albumImage}
              />
              <div className={styles.overlay}>
                <button className={styles.likeButton}>
                  <ReactSVG src="/heart.svg" />
                </button>
                <button className={styles.playButton}>
                  <ReactSVG src="/play.svg" />
                </button>
                <button className={styles.moreButton}>
                  <ReactSVG src="/more.svg" />
                </button>
              </div>
            </div>
            <a className={styles.albumLabel}>{type.name}</a>
          </div>
        ))}
      </div>
    </>
  );
};

export default TypePage;
