"use client";
import Sidebar from './component/sidebar';
import "./globals.css";
import Header from './component/header/Header';
import { usePathname } from 'next/navigation';
import AdminSidebar from './component/AdminSidebar';

export default function Layout({ children }: any) {
  const pathname = usePathname();
  const isAdmin = pathname.startsWith('/admin');

  return (
    <html lang="en">
      <head>
        <title>Groove</title>
        <meta name="description" content="Soundy website description" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/logo.svg" />
        <link
          rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"  />
      </head>
      <body>
        {!isAdmin ? (
          <div className="container">
            <Sidebar />
            <Header />
            <div className="contain">
              {children}
            </div>
          </div>
        ) : (
            <div className="admin-container">
              <AdminSidebar/>
            {children}
          </div>
        )}
      </body>
    </html>
  );
}
