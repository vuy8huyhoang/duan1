// components/Footer.tsx
"use client"
import classes from "./footer.module.scss"

export default function Footer() {
    console.log(classes);

    return (
        <footer className="bg-gray-900 text-white w-full py-4 px-6 text-center">
            <p>&copy; 2024 ZingMP3. All rights reserved.</p>
            <div className="flex justify-center gap-4 mt-2">
                <a href="/about" className="hover:text-yellow-500">Giới Thiệu</a>
                <a href="/contact" className="hover:text-yellow-500">Liên Hệ</a>
                <a href="/terms" className="hover:text-yellow-500">Điều Khoản</a>
            </div>
            <div className={classes.test}>test</div>
        </footer>
    );
}
