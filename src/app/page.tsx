import Sidebar from './component/sidebar';
import Body from './component/home';
import Footer from './component/footer';
import RightSidebar from './component/rightsidebar';
import Header from './component/header';
import MusicPlayerBar from './component/musicplayerbar';

export default function HomePage() {
  return (
    <div className="home-page">
      <div className="main-layout">
        <Sidebar />
        <div className="content-wrapper">
          <Header />

          <Body />
        </div>
        <RightSidebar />
        <MusicPlayerBar/>
      </div>
      <Footer />
    </div>
  );
}
