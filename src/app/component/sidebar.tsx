const Sidebar = () => {
    return (
        <aside className="sidebar">
            <div className="logo">
                <img src="https://static-zmp3.zmdcdn.me/skins/common/logo600.png" alt="Zing MP3 Logo" />
            </div>
            <nav className="nav-menu">
                <ul>
                    <li><a href="#">Thư Viện</a></li>
                    <li><a href="#">Khám Phá</a></li>
                    <li><a href="#">#zingchart</a></li>
                    <li><a href="#">BXH Nhạc Mới</a></li>
                    <li><a href="#">Chủ Đề & Thể Loại</a></li>
                    <li><a href="#">Top 100</a></li>
                </ul>
            </nav>
            <div className="upgrade">
                <button>Nâng Cấp Tài Khoản</button>
            </div>
        </aside>
    );
};

export default Sidebar;
