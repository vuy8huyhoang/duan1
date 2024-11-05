"use client";
import React, { useState, useEffect, useRef, useContext } from 'react';
import styles from './musicplayer.module.scss';
import axios from '@/lib/axios';
import { AppContext } from '@/app/layout';
import { log } from 'console';
interface Artist {
    id_artist: string;
    name: string;
}
interface Music {
    id_music: string;
    name: string;
    slug: string;
    url_cover: string;
    url_path: string;
}

const MusicPlayer = () => {
    const { state, dispatch } = useContext(AppContext);
    const [music, setMusics] = useState<Music>(state.currentPlaylist[0]);
    const audioRef = useRef<HTMLAudioElement>()
    const currentPlaylist = state.currentPlaylist;
    const volume = state.volume;
    const isPlaying = state.isPlaying;

    useEffect(() => {
        if (localStorage.getItem("currentPlaylist") && localStorage.getItem("currentPlaylist").length > 0)
            setMusics(state.currentPlaylist[0])
    }, [state.currentPlaylist[0]])

    useEffect(() => {
        const loadAndPlayAudio = async () => {
            try {
                audioRef.current.load();
                if (state.isPlaying) {
                    await audioRef.current.play();
                }
            } catch (error) {
                console.error("Error playing audio:", error);
            }
        };

        loadAndPlayAudio();
    }, [state.currentPlaylist[0]?.url_path, state.isPlaying]);


    useEffect(() => {
        audioRef.current.volume = volume;
    }, [state.volume])

    useEffect(() => {
        audioRef.current.volume = volume;
        console.log(111);

        if (isPlaying) {
            audioRef.current.pause();
        } else {
            audioRef.current.play()
        }
    }, [state.isPlaying, state.currentPlaylist[0]])

    useEffect(() => {
        audioRef.current.volume = state.volume;
    }, [state.volume])

    const handlePlayPause = () => {
        console.log(state.isPlaying)
        dispatch({
            type: "IS_PLAYING",
            payload: !state.isPlaying
        })
        console.log(state.isPlaying)
    }

    useEffect(() => {
        setInterval(() => {
            // console.log([audioRef.current.duration, audioRef.current.currentTime]);
            // console.log(audioRef.current.currentTime >= audioRef.current.duration && state.currentPlaylist.length > 1);
            if (audioRef?.current?.currentTime >= audioRef.current?.duration && state.currentPlaylist?.length > 1) {
                dispatch({
                    type: "CURRENT_PLAYLIST",
                    payload: state.currentPlaylist.slice(1)
                })
                dispatch({
                    type: "IS_PLAYING",
                    payload: true
                })
            }
        }, 1000)

    }, [])
    return (
        <div className={styles.musicPlayer}>
            {
                music && music.name
            }
            <audio ref={audioRef} src={music?.url_path} controls></audio>
            <button onClick={handlePlayPause}>
                {state.isPlaying === false ? "Stop" : "Play"}</button>
            <input max={1} min={0} step={0.01} type="range" value={state.volume} onChange={(e) => dispatch({ type: "VOLUME", payload: e.target.value })} />
        </div>
    );
};

export default MusicPlayer;
