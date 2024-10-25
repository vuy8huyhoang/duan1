// app/type/route.ts
"use client";
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import Link from 'next/link';

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
    return <div>Đang tải dữ liệu...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  return (
    <div>
      <h1>Danh Sách Thể Loại</h1>
      <ul>
        {Array.isArray(typeList) && typeList.length > 0 ? (
          typeList.map((type: any) => (
            <li key={type.id_type}>
              <Link href={`/type/${type.id_type}`}>{type.name}</Link>
            </li>
          ))
        ) : (
          <li>Không có thể loại nào.</li>
        )}
      </ul>
    </div>
  );
};

export default TypePage;
