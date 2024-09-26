const Body = () => {
    return (
        <div className="main-content">
            {/* Phần hiển thị các banner lớn */}
            <div className="banner-section">
                <div className="banner-item">
                    <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Today Hits" />
                </div>
                <div className="banner-item">
                    <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Anh Trai Say Hi" />
                </div>
                <div className="banner-item">
                    <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Trending" />
                </div>
            </div>

            {/* Phần "Nghe Gần Đây" */}
            <div className="recently-played">
                <h2>Nghe Gần Đây</h2>
                <div className="recently-played-content">
                    {/* Thêm danh sách bài hát gần đây */}
                </div>
            </div>

            {/* Phần "Mới Phát Hành" */}
            <div className="new-releases">
                <h2>Mới Phát Hành</h2>
                <div className="tabs">
                    <button className="tab active">Tất Cả</button>
                    <button className="tab">Việt Nam</button>
                    <button className="tab">Quốc Tế</button>
                </div>
                <div className="new-releases-content">
                    <div className="song-list">
                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Gorgeous" className="song-img" />
                            <div className="song-info">
                                <h4>GORGEOUS <span className="premium-label">PREMIUM</span></h4>
                                <p>Katy Perry, Kim Petras</p>
                                <p>Hôm nay</p>
                            </div>
                        </div>
                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Hop On Da Show" className="song-img" />
                            <div className="song-info">
                                <h4>HOP ON DA SHOW</h4>
                                <p>tlinh, Low G</p>
                                <p>2 ngày trước</p>
                            </div>

                        </div>

                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Hop On Da Show" className="song-img" />
                            <div className="song-info">
                                <h4>HOP ON DA SHOW</h4>
                                <p>tlinh, Low G</p>
                                <p>2 ngày trước</p>
                            </div>

                        </div>
                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Gorgeous" className="song-img" />
                            <div className="song-info">
                                <h4>GORGEOUS <span className="premium-label">PREMIUM</span></h4>
                                <p>Katy Perry, Kim Petras</p>
                                <p>Hôm nay</p>
                            </div>
                        </div>
                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Hop On Da Show" className="song-img" />
                            <div className="song-info">
                                <h4>HOP ON DA SHOW</h4>
                                <p>tlinh, Low G</p>
                                <p>2 ngày trước</p>
                            </div>

                        </div>

                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Hop On Da Show" className="song-img" />
                            <div className="song-info">
                                <h4>HOP ON DA SHOW</h4>
                                <p>tlinh, Low G</p>
                                <p>2 ngày trước</p>
                            </div>

                        </div>
                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Gorgeous" className="song-img" />
                            <div className="song-info">
                                <h4>GORGEOUS <span className="premium-label">PREMIUM</span></h4>
                                <p>Katy Perry, Kim Petras</p>
                                <p>Hôm nay</p>
                            </div>
                        </div>
                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Hop On Da Show" className="song-img" />
                            <div className="song-info">
                                <h4>HOP ON DA SHOW</h4>
                                <p>tlinh, Low G</p>
                                <p>2 ngày trước</p>
                            </div>

                        </div>

                        <div className="song-item">
                            <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Hop On Da Show" className="song-img" />
                            <div className="song-info">
                                <h4>HOP ON DA SHOW</h4>
                                <p>tlinh, Low G</p>
                                <p>2 ngày trước</p>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div className="chill-section">
                <h2>Chill</h2>
                <div className="chill-content">
                    <div className="chill-item">
                        <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Lofi Một Chút Thôi" className="chill-img" />
                        <div className="chill-info">
                            <h4>Lofi Một Chút Thôi</h4>
                            <p>Nhạc Việt "lâu phai" và gây nghiện hoài hoài</p>
                        </div>
                    </div>
                    <div className="chill-item">
                        <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Playlist Này Chill Phết" className="chill-img" />
                        <div className="chill-info">
                            <h4>Playlist Này Chill Phết</h4>
                            <p>Và vào những giai điệu thư giãn của V-Pop</p>
                        </div>
                    </div>
                    <div className="chill-item">
                        <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Lofi Guitar" className="chill-img" />
                        <div className="chill-info">
                            <h4>Lofi Guitar</h4>
                            <p>Thả mình vào những giai điệu Lofi Guitar</p>
                        </div>
                    </div>
                    <div className="chill-item">
                        <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Nhạc Chill Ngày Nay" className="chill-img" />
                        <div className="chill-info">
                            <h4>Nhạc Chill Ngày Nay</h4>
                            <p>Thả mình vào dòng chảy của những giai điệu cực chill</p>
                        </div>
                    </div>
                    <div className="chill-item">
                        <img src="https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg" alt="Nhạc Chill Ngày Nay" className="chill-img" />
                        <div className="chill-info">
                            <h4>Nhạc Chill Ngày Nay</h4>
                            <p>Thả mình vào dòng chảy của những giai điệu cực chill</p>
                        </div>
                    </div>
                </div>
            </div>



        </div>
    );
};

export default Body;
