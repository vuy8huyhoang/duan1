"use client";
import axios from "@/lib/axios";

const Test = () => {
  localStorage.removeItem("accessToken");
  axios.get("music").then((data) => console.log(data));

  return <>Test</>;
};

export default Test;
