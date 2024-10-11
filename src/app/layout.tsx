"use client"
import Sidebar from './component/sidebar';

import "./globals.css";
// import axios from '@/lib/axios';

export default function Layout({ children }: any) {

  // axios.get("/posts").then((r: any) => {
  //   console.log(r);
  // })

  return (
    <html lang="en">
      <head>
        <title>Groove</title>
        
        <meta name="description" content="Soundy website description" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        {/* <link rel="icon" href="../favicon.ico" /> */}
      </head>
      <body
      //  onClick={onClickBodyHandle}
      >
        <div className="container">
          <Sidebar />
          {/* Nội dung chính */}
        </div>
      </body>
    </html>

  );
}
