
// "use client";
// import { useEffect, useState } from 'react';
// import axios from 'axios';
// import styles from './type.module.scss'; // Cập nhật đường dẫn đến module CSS
// // Định nghĩa interface Type
// interface Type {
//   id_type: string;
//   name: string;
//   slug: string;
//   created_at: string;
//   is_show: boolean;
// }

// const TypePage = () => {

//   useEffect(() => {
//     const fetchData = async () => {
//       try {
//         const response = await axios.get("type");
//         console.log("API Response:", response); 
//         setTypes(response.data.data ); 
//       } catch (error) {
//         console.error("Error fetching data:", error);
//       }
//     };


//     fetchData();
//   }, []);
//   const [types, setTypes] = useState<Type[]>([]);

//   return (
//     <div className={styles.container}> 
//       <h1 className={styles.title}>Chủ đề & thể loại</h1>
//       <ul className={styles.list}>
//   {types && types.length > 0 ? (
//     types.map((type) => (
//       <li key={type.id_type} className={styles.listItem}>
//         {type.name} (Slug: {type.slug}, Created At: {type.created_at})
//       </li>
//     ))
//   ) : (
//     <p>Không có dữ liệu</p>
//   )}
// </ul>

//     </div>
//   );
// };

// export default TypePage;

// "use client";

// import { useEffect, useState } from "react";
// import axios from "@/lib/axios";
// import styles from './type.module.scss'; // CSS module

// // Định nghĩa kiểu dữ liệu cho Type
// interface Type {
//   id_type: string;
//   name: string;
//   slug: string;
//   created_at: string;
//   is_show: boolean;
// }

// // Component hiển thị danh sách Types
// const TypePage = () => {
//   const [types, setTypes] = useState<Type[]>([]); // State lưu trữ danh sách types
//   const [error, setError] = useState<string | null>(null); // State lưu lỗi (nếu có)

//   useEffect(() => {
//     // Hàm lấy dữ liệu từ API
//     const fetchData = () => {
//       axios
//         .get("/type") // Lấy dữ liệu từ API "/type"
//         .then((response :any) => {
//           const { result } = response; // result chứa dữ liệu trả về từ interceptor
//           setTypes(result); // Cập nhật state với dữ liệu mới
//         })
//         .catch((error) => {
//           console.error("Error fetching data:", error); // Log lỗi
//           setError("Có lỗi xảy ra khi lấy dữ liệu");
//         });
//     };

//     fetchData(); // Gọi hàm lấy dữ liệu
//   }, []);

//   // Nếu có lỗi, hiển thị thông báo lỗi
//   if (error) return <div className={styles.error}>{error}</div>;

//   // Nếu dữ liệu chưa tải xong, hiển thị Loading
//   if (!types.length) return <div className={styles.loading}>Loading...</div>;

//   return (
//     <div className={styles.container}>
//       <h1 className={styles.title}>Chủ đề & Thể loại</h1>
//       <ul className={styles.list}>
//         {types.map((type) => (
//           <li key={type.id_type} className={styles.listItem}>
//             {type.name} (Slug: {type.slug}, Created At: {new Date(type.created_at).toLocaleDateString()})
//           </li>
//         ))}
//       </ul>
//     </div>
//   );
// };

// export default TypePage;
"use client";
import { useEffect, useState } from "react";
import axios from "@/lib/axios";
import styles from "./type.module.scss";

// Định nghĩa interface cho kiểu dữ liệu Type
interface Type {
  id_type: string;
  name: string;
  slug: string;
  created_at: string;
  is_show: boolean;
}

const TypePage = () => {
  const [types, setTypes] = useState<Type[]>([]); // Khởi tạo state cho mảng types
  const [loading, setLoading] = useState(true);  // Quản lý trạng thái tải dữ liệu
  const [error, setError] = useState<string | null>(null); // Trạng thái lỗi

  // Gọi API để lấy dữ liệu từ backend
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get("type"); // Gọi API
        const { data } = response; // Lấy dữ liệu từ response
        setTypes(data.data); // Gán dữ liệu vào state
      } catch (error) {
        setError("Có lỗi xảy ra khi tải dữ liệu.");
      } finally {
        setLoading(false); // Dừng trạng thái loading khi hoàn tất
      }
    };

    fetchData();
  }, []);

  // Hiển thị loading khi đang tải dữ liệu
  if (loading) {
    return <div>Loading...</div>;
  }

  // Hiển thị thông báo nếu có lỗi xảy ra
  if (error) {
    return <div>{error}</div>;
  }

  // Hiển thị thông báo nếu không có dữ liệu
  if (types.length === 0) {
    return <div>Không có dữ liệu để hiển thị</div>;
  }

  // Hiển thị danh sách types sau khi dữ liệu được tải về
  return (
    <>
    <div>
      <h1 className={styles.title}>Chủ đề & Thể loại</h1>
      <ul className={styles.list}>
        {types.map((type) => (
          <li key={type.id_type} className={styles.listItem}>
            {type.name} (Slug: {type.slug}, Created At:{" "}
            {new Date(type.created_at).toLocaleDateString()})
          </li>
        ))}
      </ul>
    </div>
    </>
  );
};

export default TypePage;
