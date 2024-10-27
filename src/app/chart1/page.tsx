"use client";
import { useEffect, useRef } from "react";
import classes from "./Chart1.module.scss";

const Chart1 = () => {
  const canvasRef: any = useRef(null);
  const totalPoint = 144;
  const canvasWidth = 1240;
  const canvasHeight = 600;
  const dataRef: any = useRef([
    {
      name: "Nơi này có anh",
      view: generateRandomNumbers(),
    },
    {
      name: "Thật bất ngờ",
      view: generateRandomNumbers(),
    },
    {
      name: "Bùa yêu",
      view: generateRandomNumbers(),
    },
  ]);
  const data = dataRef.current;

  function generateRandomNumbers() {
    const randomNumbers = [];

    // Khởi tạo với một số ngẫu nhiên trong khoảng từ 1000 đến 10000
    randomNumbers.push(Math.floor(Math.random() * 9001) + 1000);

    for (let i = 1; i < totalPoint; i++) {
      const prevNumber = randomNumbers[i - 1];

      // Tạo một độ dao động ngẫu nhiên từ 20 đến 150
      const randomDiff = Math.floor(Math.random() * 500) + 10;

      // Xác định hướng thay đổi lên hoặc xuống
      const direction = Math.random() < 0.5 ? -1 : 1;

      // Tính toán số tiếp theo trong khoảng lên xuống thất thường
      const nextNumber = Math.min(
        10000,
        Math.max(1000, prevNumber + direction * randomDiff)
      );
      randomNumbers.push(nextNumber);
    }

    return randomNumbers;
  }

  const draw = (index: number, color = "red", width = 1) => {
    const views = data[index].view;
    const maxView = Math.max(...views);
    const viewsByPercent = views.map((view) => (view / maxView) * 600); // Thay đổi cho phù hợp với chiều cao canvas
    const canvas = canvasRef.current;
    const ctx = canvas.getContext("2d");

    ctx.beginPath();
    ctx.moveTo(0, viewsByPercent[0]);

    // Vẽ đường cong Bezier
    for (let i = 1; i < viewsByPercent.length - 1; i++) {
      const x = i * (canvasWidth / totalPoint); // Tính toán vị trí x (mỗi điểm cách nhau 10 pixels)
      const cpX = (x + (i + 1) * (canvasWidth / totalPoint)) / 2; // Tính toán điểm điều khiển x
      const cpY = (viewsByPercent[i] + viewsByPercent[i + 1]) / 2; // Tính toán điểm điều khiển y
      ctx.bezierCurveTo(
        cpX,
        cpY,
        cpX,
        cpY,
        x + canvasWidth / totalPoint,
        viewsByPercent[i + 1]
      ); // Vẽ đường cong Bezier
    }

    ctx.strokeStyle = color;
    ctx.lineWidth = width; // Độ dày đường vẽ
    ctx.stroke();
  };

  useEffect(() => {
    data.map((item, index: number) => {
      index === 0 && draw(index, "red");
      index === 1 && draw(index, "blue");
      index === 2 && draw(index, "green");
    });
  }, []);

  return (
    <canvas
      height={canvasHeight}
      width={canvasWidth}
      ref={canvasRef}
      className={classes.wrapper}
    ></canvas>
  );
};

export default Chart1;
