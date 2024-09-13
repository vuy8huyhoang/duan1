-- Note
-- add age, id_google to user
-- add on update, on delete

ALTER DATABASE groovo CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
use groovo;

-- Drop tables if they exist
DROP TABLE IF EXISTS FavoriteMusic;
DROP TABLE IF EXISTS MusicHistory;
DROP TABLE IF EXISTS MusicPlaylistDetail;
DROP TABLE IF EXISTS MusicAlbumDetail;
DROP TABLE IF EXISTS MusicArtistDetail;
DROP TABLE IF EXISTS Follow;
DROP TABLE IF EXISTS NotificationStatus;
DROP TABLE IF EXISTS MusicTypeDetail;
DROP TABLE IF EXISTS Lyrics;
DROP TABLE IF EXISTS Music;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS Playlist;
DROP TABLE IF EXISTS UploadMusic;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Artist;
DROP TABLE IF EXISTS Type;
DROP TABLE IF EXISTS Notification;

-- Table: User
CREATE TABLE User (
    id_user VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    fullname VARCHAR(255) NOT NULL,
    phone VARCHAR(12) UNIQUE,
    gender ENUM('male', 'female'),
    url_avatar VARCHAR(255),
    birthday DATE,
    country VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    is_banned TINYINT(1) DEFAULT 0,
    id_google varchar(255),
    reset_token VARCHAR(255),
    reset_token_expired DATETIME
);

-- Table: Artist
CREATE TABLE Artist (
    id_artist VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    slug VARCHAR(255) UNIQUE,
    url_cover VARCHAR(255),
    birthday DATE,
    country VARCHAR(100),
    gender ENUM('male', 'female'),
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    is_show TINYINT(1) DEFAULT 1
);

-- Table: Music
CREATE TABLE Music (
    id_music VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE,
    url_path VARCHAR(255) NOT NULL,
    description TEXT,
    total_duration INT DEFAULT 0,
    publish_time DATETIME,
    release_date DATE,
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    membership_permission TINYINT(1) DEFAULT 0,
    is_show TINYINT(1) DEFAULT 1
);

-- Table: Type
CREATE TABLE Type (
    id_type VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE,
    description TEXT,
    created_at DATETIME DEFAULT NOW(),
    is_show TINYINT(1) DEFAULT 1
);

-- Table: Album
CREATE TABLE Album (
    id_album VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_artist VARCHAR(36),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE,
    url_cover VARCHAR(255),
    release_date DATE,
    publish_date DATETIME,
    description TEXT,
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    is_show TINYINT(1) DEFAULT 1,
    FOREIGN KEY (id_artist) REFERENCES Artist(id_artist) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: Playlist
CREATE TABLE Playlist (
    id_playlist VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_user VARCHAR(36),
    id_type VARCHAR(36),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    url_cover VARCHAR(255),
    created_type ENUM('user', 'admin') DEFAULT 'user',
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_type) REFERENCES Type(id_type) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: MusicArtistDetail
CREATE TABLE MusicArtistDetail (
    id_music_artist_detail VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_artist VARCHAR(36) NOT NULL,
    id_music VARCHAR(36) NOT NULL,
    FOREIGN KEY (id_artist) REFERENCES Artist(id_artist) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE 
);

-- Table: MusicAlbumDetail
CREATE TABLE MusicAlbumDetail (
    id_music_album_detail VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_music VARCHAR(36) NOT NULL,
    id_album VARCHAR(36) NOT NULL,
    index_order INT DEFAULT 0,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_album) REFERENCES Album(id_album) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: MusicPlaylistDetail
CREATE TABLE MusicPlaylistDetail (
    id_music_playing_detail VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_playlist VARCHAR(36) NOT NULL,
    id_music VARCHAR(36) NOT NULL,
    index_order INT DEFAULT 0,
    FOREIGN KEY (id_playlist) REFERENCES Playlist(id_playlist) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: Lyrics
CREATE TABLE Lyrics (
    id_lyrics VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_music VARCHAR(36) NOT NULL,
    lyrics TEXT,
    start_time INT DEFAULT 0,
    end_time INT DEFAULT 0,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: MusicTypeDetail
CREATE TABLE MusicTypeDetail (
    id_music_type_detail VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_music VARCHAR(36) NOT NULL,
    id_type VARCHAR(36) NOT NULL,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_type) REFERENCES Type(id_type) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: Membership
CREATE TABLE Membership (
    id_membership VARCHAR(36) DEFAULT (UUID()) NOT NULL PRIMARY KEY,
    id_user VARCHAR(36) NOT NULL,
    start_date DATETIME NOT NULL DEFAULT NOW(),
    end_date DATETIME NOT NULL,
    price FLOAT NOT NULL,
    type ENUM('1month', '3month', '6month') NOT NULL,
    payment_method ENUM('momo', 'bank') NOT NULL,
    payment_status ENUM('unpaid', 'paid', 'refunded') DEFAULT 'unpaid' NOT NULL,
    created_at DATETIME DEFAULT NOW() NOT NULL,
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE NO ACTION ON UPDATE CASCADE
);


-- Table: UploadMusic
CREATE TABLE UploadMusic (
    id_upload_music VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_user VARCHAR(36) NOT NULL,
    upload_url VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: MusicHistory
CREATE TABLE MusicHistory (
    id_music_history VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_user VARCHAR(36) NOT NULL,
    id_music VARCHAR(36) NOT NULL,
    play_duration INT DEFAULT 0,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: Follow
CREATE TABLE Follow (
    id_follow VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    id_user VARCHAR(36) NOT NULL,
    id_artist VARCHAR(36) NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_artist) REFERENCES Artist(id_artist) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: FavoriteMusic
CREATE TABLE FavoriteMusic (
    id_favorite_music VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_user VARCHAR(36) NOT NULL,
    id_music VARCHAR(36) NOT NULL,
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: Notification
CREATE TABLE Notification (
    id_notification VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    msg TEXT,
    type ENUM('admin', 'auto') DEFAULT 'auto',
    created_at DATETIME DEFAULT NOW()
);

-- Table: NotificationStatus
CREATE TABLE NotificationStatus (
    id_notification_status VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY ,
    id_notification VARCHAR(36) NOT NULL,
    id_user VARCHAR(36) NOT NULL,
    status ENUM('read', 'unread') DEFAULT 'unread',
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_notification) REFERENCES Notification(id_notification) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Trigger for User table
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER before_user_update
-- BEFORE UPDATE ON User
-- FOR EACH ROW
-- BEGIN
--     SET NEW.last_update = NOW();
-- END//

-- DELIMITER ;

-- -- Trigger for Artist table
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER before_artist_update
-- BEFORE UPDATE ON Artist
-- FOR EACH ROW
-- BEGIN
--     SET NEW.last_update = NOW();
-- END//

-- DELIMITER ;

-- -- Trigger for Music table
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER before_music_update
-- BEFORE UPDATE ON Music
-- FOR EACH ROW
-- BEGIN
--     SET NEW.last_update = NOW();
-- END//

-- DELIMITER ;

-- -- Trigger for Album table
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER before_album_update
-- BEFORE UPDATE ON Album
-- FOR EACH ROW
-- BEGIN
--     SET NEW.last_update = NOW();
-- END//

-- DELIMITER ;

-- Trigger for Playlist table
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER before_playlist_update
-- BEFORE UPDATE ON Playlist
-- FOR EACH ROW
-- BEGIN
--     SET NEW.last_update = NOW();
-- END//

-- DELIMITER ;

-- Trigger for Membership table
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER before_membership_update
-- BEFORE UPDATE ON Membership
-- FOR EACH ROW
-- BEGIN
--     SET NEW.last_update = NOW();
-- END//

-- DELIMITER ;

-- Trigger for FavoriteMusic table
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER before_favorite_music_update
-- BEFORE UPDATE ON FavoriteMusic
-- FOR EACH ROW
-- BEGIN
--     SET NEW.last_update = NOW();
-- END//

-- DELIMITER ;

-- -- Trigger for NotificationStatus table
-- DELIMITER //

-- CREATE OR REPLACE TRIGGER before_notification_status_update
-- BEFORE UPDATE ON NotificationStatus
-- FOR EACH ROW
-- BEGIN
--     SET NEW.last_update = NOW();
-- END//

-- DELIMITER ;

-- Insert sample data into the User table with UUIDs
INSERT INTO User (id_user, email, password, role, fullname, phone, gender, url_avatar, birthday, country, created_at, last_update, is_banned)
VALUES
('3974ad8f-ac14-40fd-9303-1fb806c3ef01', 'Bùi Huy Vũ', 'buihuyvu@gmail.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'admin', '1234567890', 'male', 'https://example.com/avatars/johndoe.jpg', '2003-05-15', 'VN',"2024-08-17T15:11:11z","2024-08-17T15:11:11z", 0),
('3974ad8f-ac14-40fd-9303-1f5806c3ef02', 'Phạm Tuấn Anh', 'panh9151@gmail.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'admin', NULL, 'female', NULL, '2003-12-25', 'VN',"2024-08-17T15:11:11z","2024-08-17T15:11:11z", 0),
('3974ad8f-ac14-40fd-9303-1f5b06c3ef03', 'Lê Cao Hữu Phúc', 'lecaohuuphuc@gmail.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'admin', '0987654322', NULL, 'https://example.com/avatars/alicejones.jpg', NULL, 'VN',"2024-08-17T15:11:11z","2024-08-17T15:11:11z", 0),
('3974ad8f-ac14-40fd-9303-1f5b86c3ef04', "Chu Văn Trường", 'chuvantruong@gmail.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'admin', NULL, NULL, NULL, NULL, 'VN',"2024-08-17T15:11:11z","2024-08-17T15:11:11z", 1),
('3974ad8f-ac14-40fd-9303-1f5b80c3ef05', 'Lê Tuấn Kiệt', 'letuankiet@gmail.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'admin', '1231231234', 'female', 'https://example.com/avatars/carolwhite.jpg', '2003-07-20', "VN","2024-08-17T15:11:11z","2024-08-17T15:11:11z", 0),
('bd2a4bd2-e37b-4f3d-a896-043286b6e672', 'sbarnsdale0@symantec.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Sabine Barnsdale', '410 396 2579', 'female', 'https://robohash.org/nisiquocommodi.png?size=50x50&set=set1', '2/26/2024', 'Czech Republic', '2024-08-17T15:11:11Z', '2024-05-13T21:17:38Z', 0),
('1aead782-e2e9-47fc-99c3-3bd8b80f1d1d', 'adrinkale1@cafepress.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Averyl Drinkale', '367 235 6448', 'female', 'https://robohash.org/consequaturmodiveritatis.png?size=50x50&set=set1', '7/24/2024', 'Poland', '2024-08-09T04:23:19Z', '2023-10-10T00:29:31Z', 0),
('8e7009df-72a3-4671-92cd-bf4a3592da52', 'jaxelbey2@nydailynews.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Jonah Axelbey', null, 'female', 'https://robohash.org/estsuntconsectetur.png?size=50x50&set=set1', null, 'Philippines', '2024-01-06T17:17:50Z', '2024-03-19T13:40:13Z', 1),
('d86306ed-451e-4228-87b5-ba3b378c3f30', 'lphilo3@cbsnews.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Laverne Philo', '415 135 3140', 'male', 'https://robohash.org/ametautpariatur.png?size=50x50&set=set1', '3/7/2024', 'Cuba', '2024-08-22T19:12:17Z', '2024-04-20T12:23:50Z', 1),
('37f53b9f-8df6-4c92-a515-a3c2c772d6ec', 'slyst4@fda.gov', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Silvanus Lyst', '372 822 3876', 'male', 'https://robohash.org/veniamdebitistotam.png?size=50x50&set=set1', '4/25/2024', 'China', '2023-12-28T21:46:59Z', '2024-03-14T08:54:36Z', 1),
('412deae6-84ac-4887-bc5f-e01a513cc886', 'dmcclune5@123-reg.co.uk', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Darby McClune', '258 829 0494', 'male', 'https://robohash.org/estmagnamatque.png?size=50x50&set=set1', '7/26/2024', 'Canada', '2024-06-04T01:51:20Z', '2023-09-24T18:36:59Z', 1),
('9bafd76e-d9e2-4bb8-a8c6-c868eacfc859', 'wjaffra6@mozilla.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Wright Jaffra', '798 272 2978', 'male', 'https://robohash.org/eaitaquecorrupti.png?size=50x50&set=set1', null, 'Colombia', '2024-01-07T10:26:25Z', '2023-10-05T19:42:10Z', 1),
('49124b9f-74d9-471e-8a55-64338dd8ce0d', 'dmuckleston7@google.com.br', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Dino Muckleston', null, 'female', 'https://robohash.org/temporefacilisdicta.png?size=50x50&set=set1', '10/28/2023', 'Poland', '2024-01-13T01:50:50Z', '2024-04-22T01:01:44Z', 0),
('e1845700-933a-478a-bce2-bbe19e097754', 'apellissier8@blogs.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Adel Pellissier', '155 160 8308', 'female', 'https://robohash.org/etetsuscipit.png?size=50x50&set=set1', '10/10/2023', 'Argentina', '2024-04-23T07:04:58Z', '2023-09-19T11:08:39Z', 1),
('ae6c679c-9eb5-4181-bca6-1f4bf14c5fff', 'jbedome9@usda.gov', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Janel Bedome', '110 318 2223', 'male', 'https://robohash.org/praesentiumvelnulla.png?size=50x50&set=set1', null, 'Russia', '2023-11-01T19:19:24Z', '2024-02-04T08:27:07Z', 1),
('107169ad-b6b2-4ff5-bc6b-24a6aaec95af', 'pbehna@jugem.jp', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Phillipp Behn', null, 'male', 'https://robohash.org/autisteet.png?size=50x50&set=set1', null, 'Indonesia', '2024-02-13T14:45:13Z', '2023-10-07T23:32:58Z', 0),
('2865b29a-39bd-457f-89df-9f6bed6dbddf', 'lworlidgeb@multiply.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Lauren Worlidge', null, 'female', 'https://robohash.org/eaconsequaturullam.png?size=50x50&set=set1', '11/11/2023', 'Panama', '2024-08-04T12:52:51Z', '2024-08-27T09:34:01Z', 1),
('c1c74145-003d-4ffb-8fcb-19d9b0f0589c', 'kkitsonc@dailymotion.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Kakalina Kitson', null, 'female', 'https://robohash.org/cupiditateipsamalias.png?size=50x50&set=set1', null, 'Philippines', '2024-09-13T00:48:10Z', '2023-12-10T04:26:35Z', 0),
('818c45b7-c44b-4464-8777-278494f2863f', 'eandrejsd@cdbaby.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Estevan Andrejs', '209 943 8292', 'male', 'https://robohash.org/aspernaturmaioresharum.png?size=50x50&set=set1', '9/8/2024', 'Ukraine', '2024-06-22T23:30:33Z', '2023-10-21T11:09:52Z', 0),
('50d4fba3-82ab-4c3a-ae5e-24a3d11bb256', 'ghuffye@cam.ac.uk', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Gwenny Huffy', '949 177 0161', 'female', 'https://robohash.org/delectusquidicta.png?size=50x50&set=set1', '9/23/2023', 'Indonesia', '2023-12-22T20:43:00Z', '2024-07-26T10:45:12Z', 1),
('9f7a97c0-8e75-46a2-9e9c-da5d64ab2de1', 'sdiglinf@redcross.org', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Stanton Diglin', '716 219 8287', 'female', 'https://robohash.org/eaquenamut.png?size=50x50&set=set1', null, 'China', '2023-10-02T23:38:52Z', '2023-12-31T18:56:32Z', 0),
('e7ae8745-ad14-403f-88e5-08bdae4159bc', 'bickovitsg@angelfire.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Babette Ickovits', '857 295 8782', 'female', 'https://robohash.org/etomnisquae.png?size=50x50&set=set1', null, 'Afghanistan', '2024-09-13T01:18:12Z', '2024-06-03T06:51:14Z', 0),
('5bd41383-2ff1-4e0c-a40c-c65f418fd117', 'jweinh@woothemes.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Joelly Wein', null, 'female', 'https://robohash.org/minussimiliqueid.png?size=50x50&set=set1', null, 'Sweden', '2024-01-12T13:13:34Z', '2024-05-16T16:15:23Z', 1),
('6fb14032-cf9e-4372-a433-96e6ddbadab3', 'cestcourti@lulu.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Cody Estcourt', '194 715 2476', 'female', 'https://robohash.org/porroadipisciplaceat.png?size=50x50&set=set1', '4/13/2024', 'Russia', '2023-10-04T08:05:55Z', '2024-02-07T00:33:03Z', 1),
('a980fa0b-efde-413d-ab92-5b544ba7e97e', 'msclandersj@tripod.com', '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2', 'user', 'Mara Sclanders', '438 424 4066', 'female', 'https://robohash.org/voluptaserrorlibero.png?size=50x50&set=set1', '2/28/2024', 'Spain', '2023-12-25T21:00:07Z', '2024-09-08T13:23:02Z', 0);

-- Insert sample data into the Artist table
INSERT INTO Artist (id_artist, name, description, slug, url_cover, birthday, country, gender, created_at, last_update, is_show)
VALUES
('a001', 'Taylor Swift', 'American singer-songwriter known for narrative songs about her personal life.', 'taylor-swift', 'https://example.com/covers/taylor.jpg', '1989-12-13', 'USA', 'female', NOW(), NOW(), 1),
('a002', 'Ed Sheeran', 'English singer-songwriter known for his soulful acoustic pop music.', 'ed-sheeran', 'https://example.com/covers/ed.jpg', '1991-02-17', 'UK', 'male', NOW(), NOW(), 1),
('a003', 'Adele', 'British singer-songwriter famous for her deep, emotional voice.', 'adele', 'https://example.com/covers/adele.jpg', '1988-05-05', 'UK', 'female', NOW(), NOW(), 1),
('a004', 'Bruno Mars', 'American singer-songwriter, record producer, and dancer.', 'bruno-mars', NULL, '1985-10-08', 'USA', 'male', NOW(), NOW(), 0),
('a005', 'Beyoncé', 'American singer, songwriter, and actress, referred to as "Queen Bey".', 'beyonce', 'https://example.com/covers/beyonce.jpg', '1981-09-04', 'USA', 'female', NOW(), NOW(), 1);

-- INSERT INTO Music (id_music, name, slug, url_path, description, total_duration, publish_time, release_date, created_at, last_update, membership_permission, is_show)
-- VALUES
-- ('m001', 'Shape of You', 'shape-of-you', 'https://example.com/music/shape-of-you.mp3', 'Hit song by Ed Sheeran from the album Divide.', 233, '2017-01-06 00:00:00', '2017-01-06', NOW(), NOW(), 0, 1),
-- ('m002', 'Blinding Lights', 'blinding-lights', 'https://example.com/music/blinding-lights.mp3', 'Popular single by The Weeknd from the album After Hours.', 200, '2019-11-29 00:00:00', '2019-11-29', NOW(), NOW(), 1, 1),
-- ('m003', 'Rolling in the Deep', 'rolling-in-the-deep', 'https://example.com/music/rolling-in-the-deep.mp3', "Adele\'s famous song from the album 21.", 228, '2010-11-29 00:00:00', '2010-11-29', NOW(), NOW(), 0, 1),
-- ('m004', 'Uptown Funk', 'uptown-funk', 'https://example.com/music/uptown-funk.mp3', 'Single by Mark Ronson featuring Bruno Mars.', 269, '2014-11-10 00:00:00', '2014-11-10', NOW(), NOW(), 0, 1),
-- ('m005', 'Formation', 'formation', 'https://example.com/music/formation.mp3', 'Lead single from the album Lemonade by Beyoncé.', 210, '2016-02-06 00:00:00', '2016-02-06', NOW(), NOW(), 1, 1),
-- ('m006', 'Bad Blood', 'bad-blood', 'https://example.com/music/bad-blood.mp3', "Taylor Swift\'s single from the album 1989.", 209, '2015-05-17 00:00:00', '2015-05-17', NOW(), NOW(), 0, 1),
-- ('m007', 'Shallow', 'shallow', 'https://example.com/music/shallow.mp3', 'Song from A Star is Born by Lady Gaga and Bradley Cooper.', 216, '2018-10-05 00:00:00', '2018-10-05', NOW(), NOW(), 1, 1),
-- ('m008', 'Levitating', 'levitating', 'https://example.com/music/levitating.mp3', 'Single by Dua Lipa from the album Future Nostalgia.', 203, '2020-10-01 00:00:00', '2020-10-01', NOW(), NOW(), 0, 1),
-- ('m009', 'Peaches', 'peaches', 'https://example.com/music/peaches.mp3', "Justin Bieber\'s single featuring Daniel Caesar and Giveon.", 198, '2021-03-19 00:00:00', '2021-03-19', NOW(), NOW(), 1, 1),
-- ('m010', 'Don’t Start Now', 'dont-start-now', 'https://example.com/music/dont-start-now.mp3', 'Single by Dua Lipa from the album Future Nostalgia.', 183, '2019-10-31 00:00:00', '2019-10-31', NOW(), NOW(), 0, 1);

-- INSERT INTO Type (id_type, name, slug, description, created_at, is_show)
-- VALUES
-- ('t001', 'Pop', 'pop', 'Popular music genre with catchy melodies and lyrics.', NOW(), 1),
-- ('t002', 'Rock', 'rock', 'Music genre characterized by strong rhythms and electric guitars.', NOW(), 1),
-- ('t003', 'Hip-Hop', 'hip-hop', 'Music genre that emerged from street culture with rhythmic vocals and beats.', NOW(), 1),
-- ('t004', 'Jazz', 'jazz', 'A music genre known for improvisation and complex harmonies.', NOW(), 1),
-- ('t005', 'Classical', 'classical', 'Traditional music genre rooted in Western musical traditions.', NOW(), 1),
-- ('t006', 'Electronic', 'electronic', 'Genre of music that primarily uses electronic instruments.', NOW(), 1),
-- ('t007', 'R&B', 'rnb', 'Rhythm and blues, a genre combining jazz, gospel, and blues.', NOW(), 1),
-- ('t008', 'Country', 'country', 'Music genre that originated from American folk music.', NOW(), 1),
-- ('t009', 'Reggae', 'reggae', 'Music genre that originated in Jamaica, characterized by offbeat rhythms.', NOW(), 1),
-- ('t010', 'Blues', 'blues', 'Music genre rooted in African American spirituals and work songs.', NOW(), 1);

-- INSERT INTO Album (id_album, id_artist, name, slug, url_cover, release_date, publish_date, description, created_at, last_update, is_show)
-- VALUES
-- ('a001', 'a001', 'Greatest Hits', 'greatest-hits', 'https://example.com/covers/greatest-hits.jpg', '2020-05-25', '2020-05-25 12:00:00', "A collection of the best songs by Ed Sheeran.", NOW(), NOW(), 1),
-- ('a002', 'a001', 'Divide', 'divide', 'https://example.com/covers/divide.jpg', '2017-03-03', '2017-03-03 08:00:00', "Ed Sheeran's third studio album with hits like Shape of You.", NOW(), NOW(), 1),
-- ('a003', 'a002', '21', '21', 'https://example.com/covers/21.jpg', '2011-01-24', '2011-01-24 09:00:00', "Adele's second studio album featuring hits like Rolling in the Deep.", NOW(), NOW(), 1),
-- ('a004', 'a002', '30', '30', 'https://example.com/covers/30.jpg', '2021-11-19', '2021-11-19 09:00:00', "Adele's highly anticipated fourth studio album.", NOW(), NOW(), 1),
-- ('a005', 'a003', 'Uptown Special', 'uptown-special', 'https://example.com/covers/uptown-special.jpg', '2015-01-16', '2015-01-16 12:00:00', "Mark Ronson's album featuring the hit single Uptown Funk.", NOW(), NOW(), 1),
-- ('a006', 'a004', 'Lemonade', 'lemonade', 'https://example.com/covers/lemonade.jpg', '2016-04-23', '2016-04-23 20:00:00', "Beyoncé's sixth studio album, featuring a mix of genres and powerful messages.", NOW(), NOW(), 1),
-- ('a007', 'a004', 'Beyoncé', 'beyonce', 'https://example.com/covers/beyonce.jpg', '2013-12-13', '2013-12-13 08:00:00', "A surprise visual album from Beyoncé with a variety of tracks.", NOW(), NOW(), 1),
-- ('a008', 'a005', 'Future Nostalgia', 'future-nostalgia', 'https://example.com/covers/future-nostalgia.jpg', '2020-03-27', '2020-03-27 00:00:00', "Dua Lipa's second studio album featuring dance-pop hits.", NOW(), NOW(), 1),
-- ('a009', 'a005', 'Justice', 'justice', 'https://example.com/covers/justice.jpg', '2021-03-19', '2021-03-19 00:00:00', "Justin Bieber's sixth studio album with hit singles like Peaches.", NOW(), NOW(), 1),
-- ('a010', 'a005', 'Club Future Nostalgia', 'club-future-nostalgia', 'https://example.com/covers/club-future-nostalgia.jpg', '2020-08-28', '2020-08-28 00:00:00', "Dua Lipa's remix album featuring club and dance versions of tracks from Future Nostalgia.", NOW(), NOW(), 1);

-- INSERT INTO Playlist (id_playlist, id_user, id_type, name, description, url_cover, created_type, created_at, last_update)
-- VALUES
-- ('p001', 'u001', null, 'Chill Vibes', 'A playlist for relaxing and unwinding.', 'https://example.com/covers/chill-vibes.jpg', 'user', NOW(), NOW()),
-- ('p002', 'u002', null, 'Rock Classics', 'Classic rock tracks from the greatest artists.', 'https://example.com/covers/rock-classics.jpg', 'user', NOW(), NOW()),
-- ('p003', 'u003', null, 'Pop Hits 2024', 'The latest and greatest pop hits of 2024.', 'https://example.com/covers/pop-hits-2024.jpg', 'user', NOW(), NOW()),
-- ('p004', 'u004', null, 'Jazz Essentials', 'A collection of essential jazz tracks for enthusiasts.', 'https://example.com/covers/jazz-essentials.jpg', 'admin', NOW(), NOW()),
-- ('p005', 'u005', null, 'Country Favorites', 'A selection of favorite country tracks from various artists.', 'https://example.com/covers/country-favorites.jpg', 'admin', NOW(), NOW());

-- INSERT INTO MusicArtistDetail (id_music_artist_detail, id_artist, id_music)
-- VALUES
-- ('ma001', 'a001', 'm001'),
-- ('ma002', 'a001', 'm002'),
-- ('ma003', 'a001', 'm003'),
-- ('ma004', 'a002', 'm004'),
-- ('ma005', 'a002', 'm005'),
-- ('ma006', 'a002', 'm006'),
-- ('ma007', 'a003', 'm007'),
-- ('ma008', 'a003', 'm008'),
-- ('ma009', 'a003', 'm009'),
-- ('ma010', 'a003', 'm010'),
-- ('ma012', 'a004', 'm002'),
-- ('ma013', 'a004', 'm003'),
-- ('ma014', 'a004', 'm004'),
-- ('ma015', 'a004', 'm005'),
-- ('ma016', 'a005', 'm006'),
-- ('ma017', 'a005', 'm007'),
-- ('ma018', 'a005', 'm008'),
-- ('ma019', 'a005', 'm009');

-- -- Tạo dữ liệu cho MusicAlbumDetail
-- INSERT INTO MusicAlbumDetail (id_music_album_detail, id_music, id_album, index_order)
-- VALUES
-- ('ma001', 'm001', 'a001', 1),
-- ('ma002', 'm002', 'a002', 2),
-- ('ma003', 'm003', 'a003', 3),
-- ('ma004', 'm004', 'a004', 1),
-- ('ma005', 'm005', 'a005', 2),
-- ('ma006', 'm006', 'a006', 3),
-- ('ma007', 'm007', 'a007', 1),
-- ('ma008', 'm008', 'a008', 2),
-- ('ma009', 'm009', 'a009', 1),
-- ('ma010', 'm010', 'a010', 2),
-- ('ma011', 'm003', 'a001', 1),
-- ('ma012', 'm004', 'a002', 2),
-- ('ma013', 'm005', 'a003', 3),
-- ('ma014', 'm006', 'a004', 4);

-- -- Tạo dữ liệu cho MusicPlaylistDetail
-- INSERT INTO MusicPlaylistDetail (id_music_playing_detail, id_playlist, id_music, index_order)
-- VALUES
-- ('mp001', 'p001', 'm001', 1),
-- ('mp002', 'p002', 'm002', 2),
-- ('mp003', 'p003', 'm003', 3),
-- ('mp004', 'p004', 'm004', 1),
-- ('mp005', 'p005', 'm005', 2),
-- ('mp006', 'p001', 'm006', 3),
-- ('mp007', 'p002', 'm007', 1),
-- ('mp008', 'p003', 'm008', 2),
-- ('mp009', 'p004', 'm009', 1),
-- ('mp010', 'p005', 'm010', 2),
-- ('mp011', 'p001', 'm001', 1),
-- ('mp012', 'p002', 'm002', 2),
-- ('mp013', 'p003', 'm003', 3);

-- -- Tạo dữ liệu cho Lyrics
-- INSERT INTO Lyrics (id_lyrics, id_music, lyrics, start_time, end_time)
-- VALUES
-- ('l001', 'm001', 'Lời bài hát đoạn 1', 0, 15),
-- ('l002', 'm001', 'Lời bài hát đoạn 2', 16, 30),
-- ('l003', 'm002', 'Lời bài hát đoạn 1', 0, 20),
-- ('l004', 'm003', 'Lời bài hát đoạn 2', 21, 40),
-- ('l005', 'm004', 'Lời bài hát đoạn 1', 0, 18),
-- ('l006', 'm005', 'Lời bài hát đoạn 2', 19, 35),
-- ('l007', 'm001', 'Lời bài hát đoạn 1', 0, 22),
-- ('l009', 'm002', 'Lời bài hát đoạn 2', 23, 45),
-- ('l010', 'm003', 'Lời bài hát đoạn 1', 0, 25),
-- ('l011', 'm004', 'Lời bài hát đoạn 2', 26, 50);

-- -- Tạo dữ liệu cho Membership
-- INSERT INTO Membership (id_membership, id_user, start_date, end_date, price, type, payment_method, payment_status, created_at, last_update)
-- VALUES
-- ('m001', 'u001', NOW(), DATE_ADD(NOW(), INTERVAL 1 MONTH), 10.00, '1month', 'momo', 'paid', NOW(), NOW()),
-- ('m002', 'u002', NOW(), DATE_ADD(NOW(), INTERVAL 1 MONTH), 10.00, '1month', 'bank', 'unpaid', NOW(), NOW()),
-- ('m003', 'u003', NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 25.00, '3month', 'momo', 'paid', NOW(), NOW()),
-- ('m004', 'u004', NOW(), DATE_ADD(NOW(), INTERVAL 3 MONTH), 25.00, '3month', 'bank', 'refunded', NOW(), NOW()),
-- ('m005', 'u005', NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 45.00, '6month', 'momo', 'paid', NOW(), NOW()),
-- ('m006', 'u001', NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH), 45.00, '6month', 'bank', 'unpaid', NOW(), NOW());

-- -- Tạo dữ liệu cho UploadMusic
-- INSERT INTO UploadMusic (id_upload_music, id_user, upload_url, created_at)
-- VALUES
-- ('um001', 'u001', 'https://example.com/uploads/music1.mp3', NOW()),
-- ('um002', 'u002', 'https://example.com/uploads/music2.mp3', NOW()),
-- ('um003', 'u003', 'https://example.com/uploads/music3.mp3', NOW()),
-- ('um004', 'u004', 'https://example.com/uploads/music4.mp3', NOW()),
-- ('um005', 'u005', 'https://example.com/uploads/music5.mp3', NOW()),
-- ('um006', 'u006', 'https://example.com/uploads/music6.mp3', NOW()),
-- ('um007', 'u007', 'https://example.com/uploads/music7.mp3', NOW()),
-- ('um008', 'u008', 'https://example.com/uploads/music8.mp3', NOW()),
-- ('um009', 'u009', 'https://example.com/uploads/music9.mp3', NOW());

-- -- Tạo dữ liệu cho MusicHistory
-- INSERT INTO MusicHistory (id_music_history, id_user, id_music, play_duration, created_at)
-- VALUES
-- ('mh001', 'u001', 'm001', 180, NOW()),
-- ('mh002', 'u002', 'm002', 240, NOW()),
-- ('mh003', 'u003', 'm003', 150, NOW()),
-- ('mh004', 'u004', 'm004', 200, NOW()),
-- ('mh005', 'u005', 'm005', 210, NOW()),
-- ('mh006', 'u006', 'm006', 190, NOW()),
-- ('mh007', 'u007', 'm007', 170, NOW());

-- -- Tạo dữ liệu cho Follow
-- INSERT INTO Follow (id_follow, id_user, id_artist, created_at)
-- VALUES
-- ('f001', 'u001', 'a001', NOW()),
-- ('f002', 'u002', 'a002', NOW()),
-- ('f003', 'u003', 'a003', NOW()),
-- ('f004', 'u004', 'a004', NOW()),
-- ('f005', 'u005', 'a005', NOW()),
-- ('f006', 'u001', 'a005', NOW());

-- -- Tạo dữ liệu cho FavoriteMusic
-- INSERT INTO FavoriteMusic (id_favorite_music, id_user, id_music, last_update)
-- VALUES
-- ('fm001', 'u001', 'm001', NOW()),
-- ('fm002', 'u002', 'm002', NOW()),
-- ('fm003', 'u003', 'm003', NOW()),
-- ('fm004', 'u004', 'm004', NOW()),
-- ('fm005', 'u005', 'm005', NOW()),
-- ('fm006', 'u006', 'm006', NOW());

-- -- Tạo dữ liệu cho Notification
-- INSERT INTO Notification (id_notification, msg, type, created_at)
-- VALUES
-- ('n001', 'Your password has been successfully reset.', 'auto', NOW()),
-- ('n002', 'Your subscription has been renewed successfully.', 'auto', NOW()),
-- ('n003', 'Your account has been upgraded to premium.', 'admin', NOW()),
-- ('n004', 'Please verify your email address to activate your account.', 'admin', NOW()),
-- ('n005', 'New features have been added to your favorite playlist.', 'auto', NOW()),
-- ('n006', 'The song you like is now available in higher quality.', 'auto', NOW());

-- -- Tạo dữ liệu cho NotificationStatus
-- INSERT INTO NotificationStatus (id_notification_status, id_notification, id_user, status, last_update)
-- VALUES
-- ('ns001', 'n001', 'u001', 'unread', NOW()),
-- ('ns002', 'n002', 'u002', 'read', NOW()),
-- ('ns003', 'n003', 'u003', 'unread', NOW()),
-- ('ns004', 'n004', 'u004', 'read', NOW()),
-- ('ns005', 'n005', 'u005', 'unread', NOW()),
-- ('ns006', 'n006', 'u006', 'read', NOW());
