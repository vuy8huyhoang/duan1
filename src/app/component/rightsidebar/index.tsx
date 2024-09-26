const RightSidebar = () => {
    return (
        <aside className="right-sidebar">
            <div className="live-section">
                <img src="https://laptopdell.com.vn/wp-content/uploads/2022/07/laptop_lenovo_legion_s7_8.jpg" alt="Live Program" className="live-image" />
                <h3>Danh sách nhạc hot</h3>
                <p>Hôm nay</p>
                <div className="program-list">
                    <div className="program">
                        <img src="https://laptopdell.com.vn/wp-content/uploads/2022/07/laptop_lenovo_legion_s7_8.jpg" alt="Live Program" className="live-image" />

                        <div className="program-info">
                            <span className="live-label">ĐANG PHÁT</span>
                            <p>16:44 - 17:51</p>
                            <h4>Once Upon A Time</h4>
                            <p>Những câu chuyện cổ tích thú vị</p>
                        </div>
                    </div>
                    {/* Các chương trình khác */}
                </div>
            </div>
        </aside>
    );
};

export default RightSidebar;
