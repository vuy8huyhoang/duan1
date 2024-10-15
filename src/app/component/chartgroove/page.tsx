import { Line } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js';

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);

const GrooveChart = () => {
  const data = {
    labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ Nhật'],
    datasets: [
      {
        label: 'Em Của Ngày HÔm qua',
        data: [65, 59, 80, 81, 56, 55, 100],
        borderColor: '#ffcc00',
        
        tension: 0.4,
        fill: false,
      },
      {
        label: 'Chắc ai đó sẽ về',
        data: [28, 48, 40, 19, 86, 27, 90],
        borderColor: '#00ffcc',
        
        tension: 0.4,
        fill: false,
      },
      {
        label: 'Không Phải Dạng Vừa Đâu',
        data: [18, 38, 30, 79, 66, 77, 20],
        borderColor: '#ff6600',
        tension: 0.4,
        fill: false,
      }
    ]
  };

  const options = {
    responsive: true,
    plugins: {
      legend: {
        display: false,
      },
    },
    scales: {
      x: {
        display: true,
      },
      y: {
        display: true,
      }
    }
  };

  // Định nghĩa styles trực tiếp
  const chartContainerStyle = {
    display: 'flex',
 
    alignItems: 'center',      // Căn giữa theo chiều dọc

    padding: '0 2rem',        // Thêm padding ngang nếu cần
  };

  const chartStyle = {
    width: '1150px',             // Đặt chiều rộng biểu đồ là 100%
    height: '300px',           // Đặt chiều cao biểu đồ (có thể thay đổi tùy theo nhu cầu)
    borderRadius: '10px',
    boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)',
  };

  return (
    <div style={chartContainerStyle}> {/* Căn giữa container */}
      <div style={chartStyle}> {/* Style cho biểu đồ */}
        <Line data={data} options={options} />
      </div>
    </div>
  );
};

export default GrooveChart;
