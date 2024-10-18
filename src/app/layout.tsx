"use client"
import Sidebar from './component/sidebar';
import "./globals.css"
import Header from './component/header/Header';
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
        <link
          rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" // Thêm Font Awesome
        />
      </head>
      <body
      >
        <div className="container">
          <Sidebar />
          <Header />
          <div className="contain">
            {children}
            </div>
        </div>
      
      </body>
    </html>

  );
}
