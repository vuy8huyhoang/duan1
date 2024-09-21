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
                    {/* Thêm danh sách bài hát mới phát hành */}
                </div>
            </div>
        </div>
    );
};

export default Body;
