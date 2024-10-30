// app/search/page.tsx
'use client';
import React, { useEffect, useState } from 'react';
import { useSearchParams } from 'next/navigation';
import axios from 'axios';
import styles from './search.module.scss';

const SearchResultsPage: React.FC = () => {
    const searchParams = useSearchParams();
    const query = searchParams.get('query') || '';
    const [searchResults, setSearchResults] = useState<any[]>([]);
    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 10; // Số lượng album mỗi trang

    useEffect(() => {
        const fetchSearchResults = async () => {
            if (query) {
                try {
                    const response = await axios.get(
                        `https://api-groove.vercel.app/search?search_text=${encodeURIComponent(query)}`
                    );
                    setSearchResults(response.data.data.musicList || []);
                } catch (error) {
                    console.error('Error fetching search results:', error);
                }
            }
        };

        fetchSearchResults();
    }, [query]);

    // Tính toán các kết quả tìm kiếm cho trang hiện tại
    const paginatedResults = searchResults.slice(
        (currentPage - 1) * itemsPerPage,
        currentPage * itemsPerPage
    );

    const totalItems = searchResults.length; // Tổng số album tìm kiếm
    const totalPages = Math.ceil(totalItems / itemsPerPage); // Tính số trang

    return (
        <div className={styles.searchResultsContainer}>
            <h1>Kết quả tìm kiếm: {query}</h1>
            <div className={styles.searchResultsGrid}>
                {paginatedResults.map((album) => (
                    <div key={album.id_music} className={styles.albumItem}>
                        <img src={album.url_cover} alt={album.name} className={styles.albumImage} />
                        <div className={styles.albumInfo}>
                            <p className={styles.albumName}>{album.name}</p>
                            <p className={styles.composerName}>{album.composer}</p>
                        </div>
                    </div>
                ))}
            </div>

            {/* Điều hướng phân trang */}
            <div className={styles.pagination}>
                <button
                    disabled={currentPage === 1}
                    onClick={() => setCurrentPage(currentPage - 1)}
                >
                    Trước
                </button>
                <span>Trang {currentPage} / {totalPages}</span>
                <button
                    disabled={currentPage === totalPages}
                    onClick={() => setCurrentPage(currentPage + 1)}
                >
                    Sau
                </button>
            </div>
        </div>
    );
};
export default SearchResultsPage;
