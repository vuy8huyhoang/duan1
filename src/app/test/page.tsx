"use client";
import axios from "@/lib/axios";

const Test = () => {
  axios.get("music").then((data) => console.log(data));

  return <>Test</>;
};

export default Test;
