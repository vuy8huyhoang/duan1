"use client";
import axios from "@/lib/axios";

const Test = () => {
  //   axios.get("music").then((data) => console.log(data));
  fetch("https://api-groove.vercel.app/music", {
    headers: {
      "Content-Type": "application/json",
      //   Authorization: "Bearer your-token-here",
    },
  })
    .then((res) => res.json())
    .then((data) => console.log(data));

  return <>Test</>;
};

export default Test;
