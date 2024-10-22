"use client";
import { useEffect, useState } from 'react';
import axios from 'axios';
import styles from './style.module.scss';
import { ReactSVG } from 'react-svg';
import Bxh from '../component/bxh';
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
                const response = await axios.get('http://localhost:3000/api/music');
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
            {/* <Bxh />   */}
            {/* <div className={styles.musicList}>
                {musicData.map((music,index) => (
                    <div key={music.id_music} className={styles.musicCard}> 
                        <h2 className={styles.typeName}>{music.types.map(type => type.name).join(", ")} <br /></h2>
                    </div>
                ))}
            </div> */}
    <div className={styles.chartInAreaMusicTotal}>
  <div className={styles.chartInAreaMusicHeader}>
    <span className={styles.chartInAreaMusicText}>Bảng Xếp Hạng Tuần</span>
  </div>

  <div className={styles.chartInAreaMusicList}>
    {/* Bảng xếp hạng Việt Nam */}
    <div className={styles.itemChartArea}>
      <div className={styles.itemChartAreaMain}>
        <div className={styles.chartHeader}>
          <span className={styles.chartHeaderText}>Việt Nam</span>
          <img
            src="./assets/img/icon/music-chart.png"
            alt=""
            className={styles.chartHeaderImg}
          />
        </div>
        <div className={styles.chartSongItem}>
          <div className={styles.infoItemChart}>
            <div className={styles.media}>
              <div className={styles.mediaLeft}>
                <div className={styles.songPrefix}>
                  <span className={styles.number}>1</span>
                  <div className={styles.sort}>
                    <i className="far fa-window-minimize"></i>
                  </div>
                </div>
                <div className={styles.songThumb}>
                  <img
                    src="./assets/img/picture_song/amee_pic.jpg"
                    alt=""
                    className={styles.songThumbChart}
                  />
                </div>
                <div className={styles.cardInfo}>
                  <div className={styles.nameSong}>Sao anh chưa về</div>
                  <h3 className={styles.nameSinger}>Amee</h3>
                </div>
              </div>
              <div className={styles.mediaRight}>
                <div className={styles.timeSongItem}>
                  <span className={styles.timeSong}>03:34</span>
                </div>
                <div className={styles.actionSongItem}></div>
              </div>
            </div>
          </div>
        </div>
        <div className={styles.buttonWatch100}>
          <button className={styles.watch100Btn}>Xem tất cả</button>
        </div>
      </div>
    </div>

    {/* Bảng xếp hạng Âu Mỹ */}
    <div className={styles.itemChartArea}>
      <div className={styles.itemChartAreaMain}>
        <div className={styles.chartHeader}>
          <span className={styles.chartHeaderText}>Âu Mỹ</span>
          <img
            src="./assets/img/icon/music-chart.png"
            alt=""
            className={styles.chartHeaderImg}
          />
        </div>
        <div className={styles.chartSongItem}>
          <div className={styles.infoItemChart}>
            <div className={styles.media}>
              <div className={styles.mediaLeft}>
                <div className={styles.songPrefix}>
                  <span className={styles.number}>1</span>
                  <div className={styles.sort}>
                    <i className="far fa-window-minimize"></i>
                  </div>
                </div>
                <div className={styles.songThumb}>
                  <img
                    src="./assets/img/chart/baby.png"
                    alt=""
                    className={styles.songThumbChart}
                  />
                </div>
                <div className={styles.cardInfo}>
                  <div className={styles.nameSong}>INDUSTRY BABY</div>
                  <h3 className={styles.nameSinger}>Lil Nas X, Jack Harlow</h3>
                </div>
              </div>
              <div className={styles.mediaRight}>
                <div className={styles.timeSongItem}>
                  <span className={styles.timeSong}>03:34</span>
                </div>
                <div className={styles.actionSongItem}></div>
              </div>
            </div>
          </div>
        </div>
        <div className={styles.buttonWatch100}>
          <button className={styles.watch100Btn}>Xem tất cả</button>
        </div>
      </div>
    </div>

    {/* Bảng xếp hạng Hàn Quốc */}
    <div className={styles.itemChartArea}>
      <div className={styles.itemChartAreaMain}>
        <div className={styles.chartHeader}>
          <span className={styles.chartHeaderText}>Hàn Quốc</span>
          <img
            src="./assets/img/icon/music-chart.png"
            alt=""
            className={styles.chartHeaderImg}
          />
        </div>
        <div className={styles.chartSongItem}>
          <div className={styles.infoItemChart}>
            <div className={styles.media}>
              <div className={styles.mediaLeft}>
                <div className={styles.songPrefix}>
                  <span className={styles.number}>1</span>
                  <div className={styles.sort}>
                    <i className="far fa-window-minimize"></i>
                  </div>
                </div>
                <div className={styles.songThumb}>
                  <img
                    src="./assets/img/chart/blue.jpg"
                    alt=""
                    className={styles.songThumbChart}
                  />
                </div>
                <div className={styles.cardInfo}>
                  <div className={styles.nameSong}>BLUE</div>
                  <h3 className={styles.nameSinger}>Big Bang</h3>
                </div>
              </div>
              <div className={styles.mediaRight}>
                <div className={styles.timeSongItem}>
                  <span className={styles.timeSong}>03:34</span>
                </div>
                <div className={styles.actionSongItem}></div>
              </div>
            </div>
          </div>
        </div>
        <div className={styles.buttonWatch100}>
          <button className={styles.watch100Btn}>Xem tất cả</button>
        </div>
      </div>
    </div>
  </div>
</div>

            
        </div>
        
    );
}