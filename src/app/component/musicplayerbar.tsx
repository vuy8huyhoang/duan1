const MusicPlayerBar = () => {
    return (
        <div className="music-player-bar">
            <div className="player-info">
                <img src="https://laptopdell.com.vn/wp-content/uploads/2022/07/laptop_lenovo_legion_s7_8.jpg" alt="Live 247" className="player-image" />
                <div className="player-details">
                    <h4>Nhạc hay 2024</h4>
                </div>
            </div>
            <div className="player-controls">
                <button className="control-btn">&#10226;</button> {/* Previous */}
                <button className="control-btn">&#9654;</button> {/* Play */}
                <button className="control-btn">&#10227;</button> {/* Next */}
            </div>
            <div className="volume-controls">
                <button className="control-btn">&#128266;</button> {/* Volume Icon */}
                <input type="range" min="0" max="100" className="volume-slider" />
            </div>
            <button className="schedule-btn">Lịch phát sóng</button>
        </div>
    );
};

export default MusicPlayerBar;
