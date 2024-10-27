"use client";
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import Link from 'next/link';
import style from './type.module.scss';

const TypePage = () => {
  const [typeList, setTypeList] = useState<any[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  const fetchTypeList = async () => {
    try {
      const response = await axios.get('https://api-groove.vercel.app/type');
      console.log(response.data);
      setTypeList(response.data.data || []); 
    } catch (err) {
      console.error("Error fetching type list:", err);
      setError("Có lỗi xảy ra khi tải danh sách thể loại.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTypeList();
  }, []); 

  if (loading) {
    return <div className={style.loading}>Đang tải dữ liệu...</div>;
  }

  if (error) {
    return <div className={style.error}>{error}</div>;
  }

  return (
    <div className={style.container}>
      <h1 className={style.title}>Danh Sách Thể Loại</h1>
      <ul className={style.typeList}>
        {Array.isArray(typeList) && typeList.length > 0 ? (
          typeList.map((type: any) => (
            <li key={type.id_type} className={style.typeItem}>
              <Link href={`/type/${type.id_type}`} className={style.typeLink}>
                {type.name}
              </Link>
            </li>
          ))
        ) : (
          <li className={style.typeItem}>Không có thể loại nào.</li>
        )}
      </ul>
    </div>
  );
};

export default TypePage;
