"use client"
import axios from "@/lib/axios";
// import { useRouter } from "next/router";
import { useState } from "react";

const Login = () => {



    const [formData, setFormData] = useState({
        password: '',
        email: '',
    });
    // const router = useRouter();
    console.log(123);

    const handleChange = (e: any) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e: any) => {
        e.preventDefault();
        console.log(formData.email, formData.password);
        axios.post("login", { "email": formData.email, "password": formData.password }).then((data: any) => {
            localStorage.setItem("accessToken", data.result.accessToken)
        })

        // Call API to submit form data
        // const response = await fetch('/api/submit', {
        //     method: 'POST',
        //     headers: {
        //         'Content-Type': 'application/json',
        //     },
        //     body: JSON.stringify(formData),
        // });

        // if (response.ok) {
        //     // Redirect to thank you page after successful submission
        //     router.push('/thank-you');
        // } else {
        //     console.error('Error submitting form');
        // }
    };

    const showProfile = () => {
        axios.get("profile").then(data => console.log(data));
    }

    return (
        <div id="wrapper">
            <form onSubmit={handleSubmit} action="" id="form-login">
                <h1 className="form-heading">Form đăng nhập</h1>
                <div className="form-group">
                    <i className="far fa-user"></i>
                    <input
                        type="text"
                        id="email"
                        name="email"
                        value={formData.email}
                        onChange={handleChange}
                        required
                    />                </div>
                <div className="form-group">
                    <i className="fas fa-key"></i>
                    <input
                        type="text"
                        id="password"
                        name="password"
                        value={formData.password}
                        onChange={handleChange}
                        required
                    />                        <div id="eye">
                        <i className="far fa-eye"></i>
                    </div>
                </div>
                <button value="Đăng nhập" className="form-submit" >đăng nhập</button>
                <button onClick={showProfile}>Show profile</button>
            </form>
        </div>
    );
};

export default Login;