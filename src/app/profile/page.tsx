"use client";
import { useEffect, useState } from 'react';
import axios from '@/lib/axios';
import style from './profile.module.scss';
import { ReactSVG } from 'react-svg';

interface Profile {
    birthday: string;
    country: string;
    created_at: string;
    email: string;
    fullname: string;
    gender: string;
    last_update: string;
    phone: string;
    role: string;
    url_avatar: string;
}

export default function Profile() {
    const [profileData, setProfileData] = useState<Profile | null>(null);
    const [loading, setLoading] = useState(true);
    useEffect(() => {
        axios.get("profile")
            .then((response: any) => {
                if (response && response.result.data) {
                console.log(response.result.data);
                    setProfileData(response.result.data);
                } else {
                    console.error('Response data is undefined or null', response);
                }
            })
            .catch((error: any) => {
                console.error('Error fetching profile details', error);
            })
            .finally(() => {
                setLoading(false);
            });
    }, []);

    if (loading) return <div className={style.loader}>Đang tải...</div>;

    return (
        <div className={style.profileContainer}>
            <div className={style.header}>
                <h1>Xin chào, <span>{profileData?.fullname || 'Guest'}</span>!</h1>
            </div>
            <div className={style.profileDetails}>
                <img 
                    src={profileData?.url_avatar} 
                    alt="Profile Avatar" 
                />
                <div className={style.info}>
                        <p><strong>Email:</strong> {profileData?.email }</p>
                        <p><strong>Số điện thoại:</strong> {profileData?.phone }</p>
                        <p><strong>Ngày sinh:</strong> {profileData?.birthday }</p>
                        <p><strong>Giới tính:</strong> {profileData?.gender }</p>
                        <p><strong>Quốc gia:</strong> {profileData?.country }</p>  
                </div>
            </div>
            
        </div>
    );
}




