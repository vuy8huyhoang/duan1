
"use client";

import React, { useEffect, useState } from "react";
import axios from "@/lib/axios";

interface ViewCountProps {
  musicId: string;
}

const ViewCount: React.FC<ViewCountProps> = ({ musicId }) => {
  const [viewCount, setViewCount] = useState<number | null>(null);

  useEffect(() => {
    const fetchViewCount = async () => {
      try {
        const response = await axios.get(`/music/view-count/${musicId}`);
        setViewCount(response.data.view_count);
      } catch (error) {
        console.error("Failed to fetch view count", error);
      }
    };
    fetchViewCount();
  }, [musicId]);

  return (
    <p>Lượt xem: {viewCount !== null ? viewCount : "Đang tải..."}</p>
  );
};

export default ViewCount;
