"use client";
import { useEffect, useState } from 'react';
import axios from '@/lib/axios';
import style from './profile.module.scss';
import { log } from 'console';

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
    const [editingField, setEditingField] = useState<string | null>(null);
    const [editValue, setEditValue] = useState<string>('');
    const [src, setSrc]= useState<string>('');

    useEffect(() => {
        axios.get("profile")
            .then((response: any) => {
                if (response && response.result.data) {
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
    
    const handleEditClick = (field: string, currentValue: string) => {
        setEditingField(field);
        setEditValue(currentValue);
    };

    
    
    const handleSaveClick = () => {
        if (profileData && editingField) {
            const updatedProfile = { ...profileData, [editingField]: editValue };
            setProfileData(updatedProfile);
            setEditingField(null);
            axios.patch("/update-infor", updatedProfile)
                .then(response => {
                    console.log('Profile updated successfully', response);
                })
                .catch(error => {
                    console.error('Error updating profile', error);
                });
        }
    };

    if (loading) return <div className={style.loader}>Đang tải...</div>;

    return (
        <div className={style.profileContainer}>
            <div className={style.header}>
                <h1>Xin chào, <span>{profileData?.fullname || 'Guest'}</span>!</h1>
            </div>
            <div className={style.profileDetails}>
                <div className={style.profileimg}>
                    <img src="/Setting.svg" alt="" />
                    <img 
                        src={profileData?.url_avatar} alt=""
                    />
                </div>
                
                {/* <input type="file" multiple /> */}
                <div className={style.info}>
                    <div className={style.infoItem}>
                        <p><strong>Email:</strong> {profileData?.email}</p>
                    </div>
                    {['phone', 'birthday', 'gender', 'country'].map((field) => (
                        <div className={style.infoItem} key={field}>
                            <p>
                                <strong>{field.charAt(0).toUpperCase() + field.slice(1)}:</strong> 
                                {editingField === field ? (
                                    <input 
                                        type="text" 
                                        value={editValue} 
                                        onChange={(e) => setEditValue(e.target.value)} 
                                    />
                                ) : (
                                    profileData?.[field as keyof Profile]
                                )}
                            </p>
                            {editingField === field ? (
                                <button className={style.editButton} onClick={handleSaveClick}>Lưu</button>
                            ) : (
                                <button className={style.editButton} onClick={() => handleEditClick(field, profileData?.[field as keyof Profile] || '')}>Sửa thông tin</button>
                            )}
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
}




