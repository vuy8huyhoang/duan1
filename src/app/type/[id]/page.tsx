"use client";
import { useEffect, useState } from "react";
import axios from "@/lib/axios";
import { useRouter } from "next/router";

interface Type {
  id_type: string;
  name: string;
  slug: string;
  created_at: string;
  is_show: number;
}

const TypeDetail = () => {
  const router = useRouter();
  const { id } = router.query; // Lấy id từ URL
  const [type, setType] = useState<Type | null>(null); // Khai báo kiểu cho state
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (id) {
      axios.get(`/type/${id}`)
        .then(response => {
          setType(response.data.data);
        })
        .catch(err => {
          setError(err.response?.data || "An error occurred");
        });
    }
  }, [id]);

  if (error) return <div>Error: {error}</div>;
  if (!type) return <div>Loading...</div>;

  return (
    <div>
      <h1>Type Details</h1>
      <p>ID: {type.id_type}</p>
      <p>Name: {type.name}</p>
      <p>Slug: {type.slug}</p>
      <p>Created At: {new Date(type.created_at).toLocaleString()}</p>
      <p>Is Show: {type.is_show ? "Yes" : "No"}</p>
    </div>
  );
};

export default TypeDetail;


