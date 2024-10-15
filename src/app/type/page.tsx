"use client";

import { useEffect, useState } from "react";
import axios from "@/lib/axios";
import styles from './type.module.scss'; // Cập nhật đường dẫn đến module CSS
// Định nghĩa interface Type
interface Type {
  id_type: string;
  name: string;
  slug: string;
  created_at: string;
  is_show: boolean;
}

// Component chính
const TypePage = () => {
  const [types, setTypes] = useState<Type[]>([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get("type");
        console.log("API Response:", response); 
        setTypes(response.data); 
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };
    

    fetchData();
  }, []);

  return (
    <div className={styles.container}> 
      <h1 className={styles.title}>Chủ đề & thể loại</h1>
      <ul className={styles.list}> 
        {types.map((type) => (
          <li key={type.id_type} className={styles.listItem}> 
            {type.name} (Slug: {type.slug}, Created At: {type.created_at})
          </li>
        ))}
      </ul>
    </div>
  );
};

export default TypePage;
