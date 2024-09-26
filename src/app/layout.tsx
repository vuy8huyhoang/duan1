"use client"
import Sidebar from './component/sidebar';
import Footer from './component/footer';
import RightSidebar from './component/rightsidebar';
import Header from './component/header';
import MusicPlayerBar from './component/musicplayerbar';
import "./globals.css";
import axios from '@/lib/axios';

export default function Layout({ children }: any) {

  axios.get("/posts").then((r: any) => {
    console.log(r);
  })

  return (
    <html lang="en">
      <head>
        <title>Soundy - Lofi & Chill</title>
        <meta name="description" content="Soundy website description" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        {/* <link rel="icon" href="../favicon.ico" /> */}
      </head>
      <body
      //  onClick={onClickBodyHandle}
      >
        <div className="home-page">
          <div className="main-layout">
            <Sidebar />
            <div className="content-wrapper">
              <Header />
              {children}
            </div>
            <RightSidebar />
            <MusicPlayerBar />
          </div>
          <Footer />
        </div>
      </body>
    </html>

  );
}
