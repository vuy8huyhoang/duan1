'use client'; // Đảm bảo sử dụng 'use client' đúng chính tả
import { useState } from "react";
import { useRouter } from "next/navigation";
const RegisterPage = () => {
  const router = useRouter();
  const [fullname, setFullname] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [phone, setPhone] = useState("");
  const [gender, setGender] = useState("male");
  const [url_avatar, setUrlAvatar] = useState("");
  const [birthday, setBirthday] = useState("");
  const [country, setCountry] = useState("");
  const [is_banned, setIsBanned] = useState(0); // 0 = không bị cấm, 1 = bị cấm
  const [errorMessage, setErrorMessage] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const response = await fetch("/api/user", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email,
          password,
          role: "user", // Có thể chỉ định vai trò mặc định là "user"
          fullname,
          phone,
          gender,
          url_avatar,
          birthday,
          country,
          is_banned,
        }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        setErrorMessage(errorData.message);
        return;
      }

      const data = await response.json();
      alert(`Đăng ký thành công với ID: ${data.newID}`);
      router.push("/"); // Chuyển hướng về trang chính
    } catch (error) {
      setErrorMessage("Có lỗi xảy ra trong quá trình đăng ký.");
      console.error(error);
    }
  };

  return (
    <div>
      <h1>Đăng Ký</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Họ và tên:</label>
          <input
            type="text"
            value={fullname}
            onChange={(e) => setFullname(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Email:</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Mật khẩu:</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Số điện thoại:</label>
          <input
            type="text"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
          />
        </div>
        <div>
          <label>Giới tính:</label>
          <select value={gender} onChange={(e) => setGender(e.target.value)}>
            <option value="male">Nam</option>
            <option value="female">Nữ</option>
          </select>
        </div>
        <div>
          <label>URL Ảnh đại diện:</label>
          <input
            type="text"
            value={url_avatar}
            onChange={(e) => setUrlAvatar(e.target.value)}
          />
        </div>
        <div>
          <label>Ngày sinh:</label>
          <input
            type="date"
            value={birthday}
            onChange={(e) => setBirthday(e.target.value)}
          />
        </div>
        <div>
          <label>Quốc gia:</label>
          <input
            type="text"
            value={country}
            onChange={(e) => setCountry(e.target.value)}
          />
        </div>
        <div>
          <label>Bị cấm:</label>
          <select
            value={is_banned}
            onChange={(e) => setIsBanned(Number(e.target.value))}
          >
            <option value={0}>Không</option>
            <option value={1}>Có</option>
          </select>
        </div>
        <button type="submit">Đăng Ký</button>
      </form>
      {errorMessage && <p style={{ color: "red" }}>{errorMessage}</p>}
    </div>
  );
};

export default RegisterPage;
