
"use client";

import React, { useEffect, useState } from "react";
import axios from "@/lib/axios";

interface Music {
  id_music: string;
}

const ViewCount: React.FC<Music> = ({ id_music }) => {
  const [viewCount, setViewCount] = useState<number | null>(null);

  useEffect(() => {
    const fetchViewCount = async () => {
      try {
        const response = await axios.get(`/music/view-count/${id_music}`);
        setViewCount(response.data.view_count);
      } catch (error) {
        console.error("Failed to fetch view count", error);
      }
    };
    fetchViewCount();
  }, [id_music]);

  return (
    <p>Lượt xem: {viewCount !== null ? viewCount : "Đang tải..."}</p>
  );
};

export default ViewCount;
