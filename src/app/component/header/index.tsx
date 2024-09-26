const Header = () => {
    return (
        <div className="search-bar">
            <div className="navigation">
                <button>&larr;</button>
                <button>&rarr;</button>
            </div>
            <input type="text" placeholder="Tìm kiếm bài hát, nghệ sĩ, lời bài hát..." />
            <div className="action-buttons">
                <button className="upgrade">Nâng cấp tài khoản</button>
                <button className="download">Tải bản Windows</button>
                <button className="settings">&#9881;</button>
                <div className="profile">
                    <img src="https://laptopdell.com.vn/wp-content/uploads/2022/07/laptop_lenovo_legion_s7_8.jpg" alt="Profile" />
                </div>
            </div>
        </div>
    );
};

export default Header;
