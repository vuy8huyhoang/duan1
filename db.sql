-- Note
-- add age, id_google to user
-- add on update, on delete
ALTER DATABASE groovo CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

use groovo;

-- Drop tables if they exist
DROP TABLE IF EXISTS FavoriteAlbum;

DROP TABLE IF EXISTS FavoriteMusic;

DROP TABLE IF EXISTS Follow;

DROP TABLE IF EXISTS MusicHistory;

DROP TABLE IF EXISTS MusicTypeDetail;

DROP TABLE IF EXISTS Lyrics;

DROP TABLE IF EXISTS MusicPlaylistDetail;

DROP TABLE IF EXISTS MusicAlbumDetail;

DROP TABLE IF EXISTS MusicArtistDetail;

DROP TABLE IF EXISTS Playlist;

DROP TABLE IF EXISTS Album;

DROP TABLE IF EXISTS Music;

DROP TABLE IF EXISTS Type;

DROP TABLE IF EXISTS Artist;

DROP TABLE IF EXISTS Notification;

DROP TABLE IF EXISTS User;

-- Table: User
CREATE TABLE User (
    id_user VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
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
    reset_token_expired float
);

-- Table: Artist
CREATE TABLE Artist (
    id_artist VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE,
    url_cover VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    is_show TINYINT(1) DEFAULT 1
);

-- Table: Music
CREATE TABLE Music (
    id_music VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE,
    url_path VARCHAR(255) NOT NULL,
    url_cover VARCHAR(255) NOT NULL,
    total_duration INT DEFAULT 0,
    producer varchar(255),
    composer varchar(255),
    release_date DATE,
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    is_show TINYINT(1) DEFAULT 1
);

-- Table: Type
CREATE TABLE Type (
    id_type VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE,
    created_at DATETIME DEFAULT NOW(),
    is_show TINYINT(1) DEFAULT 1
);

-- Table: Album
CREATE TABLE Album (
    id_album VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    id_artist VARCHAR(36),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE,
    url_cover VARCHAR(255),
    release_date DATE,
    publish_by VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    is_show TINYINT(1) DEFAULT 1,
    FOREIGN KEY (id_artist) REFERENCES Artist(id_artist) ON DELETE
    SET
        NULL ON UPDATE CASCADE
);

-- Table: Playlist
CREATE TABLE Playlist (
    id_playlist VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    id_user VARCHAR(36),
    name VARCHAR(255) NOT NULL,
    url_cover VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: MusicArtistDetail
CREATE TABLE MusicArtistDetail (
    id_artist VARCHAR(36) NOT NULL,
    id_music VARCHAR(36) NOT NULL,
    PRIMARY KEY (id_artist, id_music),
    FOREIGN KEY (id_artist) REFERENCES Artist(id_artist) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: MusicAlbumDetail
CREATE TABLE MusicAlbumDetail (
    id_music VARCHAR(36) NOT NULL,
    id_album VARCHAR(36) NOT NULL,
    index_order INT DEFAULT 0,
    PRIMARY KEY (id_music, id_album),
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_album) REFERENCES Album(id_album) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: MusicPlaylistDetail
CREATE TABLE MusicPlaylistDetail (
    id_playlist VARCHAR(36) NOT NULL,
    id_music VARCHAR(36) NOT NULL,
    index_order INT DEFAULT 0,
    PRIMARY KEY (id_playlist, id_music),
    FOREIGN KEY (id_playlist) REFERENCES Playlist(id_playlist) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: Lyrics
CREATE TABLE Lyrics (
    id_lyrics VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    id_music VARCHAR(36) NOT NULL,
    lyrics TEXT,
    start_time INT DEFAULT 0,
    end_time INT DEFAULT 0,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: MusicTypeDetail
CREATE TABLE MusicTypeDetail (
    id_music VARCHAR(36) NOT NULL,
    id_type VARCHAR(36) NOT NULL,
    PRIMARY KEY (id_music, id_type),
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_type) REFERENCES Type(id_type) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: MusicHistory
CREATE TABLE MusicHistory (
    id_music_history VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    id_user VARCHAR(36) NOT NULL,
    id_music VARCHAR(36) NOT NULL,
    play_duration INT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: Follow
CREATE TABLE Follow (
    id_user VARCHAR(36) NOT NULL,
    id_artist VARCHAR(36) NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (id_user, id_artist),
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_artist) REFERENCES Artist(id_artist) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: FavoriteMusic
CREATE TABLE FavoriteMusic (
    id_user VARCHAR(36) NOT NULL,
    id_music VARCHAR(36) NOT NULL,
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_user, id_music),
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_music) REFERENCES Music(id_music) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FavoriteAlbum (
    id_user VARCHAR(36) NOT NULL,
    id_album VARCHAR(36) NOT NULL,
    last_update DATETIME DEFAULT NOW() ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_user, id_album),
    FOREIGN KEY (id_user) REFERENCES User(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_album) REFERENCES Album(id_album) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: Notification
CREATE TABLE Notification (
    id_notification VARCHAR(36) DEFAULT UUID() NOT NULL PRIMARY KEY,
    id_user VARCHAR(36) NOT NULL,
    msg TEXT not null,
    status ENUM('read', 'unread') DEFAULT 'unread',
    created_at DATETIME DEFAULT NOW(),
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
-- Add user
INSERT INTO
    User (
        id_user,
        fullname,
        email,
        password,
        role,
        phone,
        gender,
        url_avatar,
        birthday,
        country,
        created_at,
        last_update,
        is_banned
    )
VALUES
    (
        'u001',
        'Bùi Huy Vũ',
        'buihuyvu@gmail.com',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'admin',
        '1234567890',
        'male',
        'https://example.com/avatars/johndoe.jpg',
        '2003-05-15',
        'VN',
        "2024-08-17T15:11:11z",
        "2024-08-17T15:11:11z",
        0
    ),
    (
        'u002',
        'Phạm Tuấn Anh',
        'anhpt2611@gmail.com',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'admin',
        NULL,
        'female',
        NULL,
        '2003-12-25',
        'VN',
        "2024-08-17T15:11:11z",
        "2024-08-17T15:11:11z",
        0
    ),
    (
        'u003',
        'Lê Cao Hữu Phúc',
        'lecaohuuphuc@gmail.com',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'admin',
        '0987654322',
        NULL,
        'https://example.com/avatars/alicejones.jpg',
        NULL,
        'VN',
        "2024-08-17T15:11:11z",
        "2024-08-17T15:11:11z",
        0
    ),
    (
        'u004',
        "Chu Văn Trường",
        'chuvantruong@gmail.com',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'admin',
        NULL,
        NULL,
        NULL,
        NULL,
        'VN',
        "2024-08-17T15:11:11z",
        "2024-08-17T15:11:11z",
        1
    ),
    (
        'u005',
        'Lê Tuấn Kiệt',
        'letuankiet@gmail.com',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'admin',
        '1231231234',
        'female',
        'https://example.com/avatars/carolwhite.jpg',
        '2003-07-20',
        "VN",
        "2024-08-17T15:11:11z",
        "2024-08-17T15:11:11z",
        0
    ),
    (
        'u006',
        'Membership Account',
        'membership@gmail.com',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        null,
        null,
        'https://example.com/avatars/carolwhite.jpg',
        '2003-07-20',
        "VN",
        "2024-08-17T15:11:11z",
        "2024-08-17T15:11:11z",
        0
    ),
    (
        'u007',
        'User Account',
        'user@gmail.com',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        null,
        null,
        'https://example.com/avatars/carolwhite.jpg',
        '2003-07-20',
        "VN",
        "2024-08-17T15:11:11z",
        "2024-08-17T15:11:11z",
        0
    );

insert into
    User (
        id_user,
        password,
        role,
        fullname,
        email,
        phone,
        gender,
        url_avatar,
        birthday,
        is_banned
    )
values
    (
        '42345758-0d91-412d-922a-942b0700ddaf',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Babb Heyburn',
        'babb.heyburn@gmail.com',
        '1872318438',
        null,
        null,
        '10/1/2023',
        1
    ),
    (
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Tabina Djokic',
        'tabina.djokic@gmail.com',
        '1478437202',
        null,
        null,
        null,
        0
    ),
    (
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Leonard Bransdon',
        'leonard.bransdon@gmail.com',
        null,
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/y1t83x6vwbxazwnmcgke.png',
        null,
        0
    ),
    (
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Tabby Radbourne',
        'tabby.radbourne@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/qz4kqwj4f4curejrrc7x.png',
        '3/14/2024',
        0
    ),
    (
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Sada Baszkiewicz',
        'sada.baszkiewicz@gmail.com',
        null,
        null,
        null,
        '10/10/2023',
        1
    ),
    (
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Bertha Astles',
        'bertha.astles@gmail.com',
        '2966293522',
        'male',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/hiegaoaqc31vld7iiyxx.png',
        null,
        0
    ),
    (
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Layney Treppas',
        'layney.treppas@gmail.com',
        null,
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/zv8i7byhf6uhgrxwir9a.png',
        '3/4/2024',
        0
    ),
    (
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Ariella Matley',
        'ariella.matley@gmail.com',
        '7917887887',
        null,
        null,
        '1/19/2024',
        0
    ),
    (
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Doe Cicero',
        'doe.cicero@gmail.com',
        '4232141192',
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/wmwifpgevvpwcb78tvxi.png',
        '10/10/2023',
        0
    ),
    (
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Valaree Luberti',
        'valaree.luberti@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/r74itcqp4mbsrvnozg3o.png',
        '8/2/2024',
        0
    ),
    (
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Ignatius Fouracre',
        'ignatius.fouracre@gmail.com',
        '2827043216',
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/l5mfkivokjtwayirww6j.png',
        '5/19/2024',
        1
    ),
    (
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Catharine Carrabott',
        'catharine.carrabott@gmail.com',
        '2386969751',
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/y1t83x6vwbxazwnmcgke.png',
        '9/11/2024',
        1
    ),
    (
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Clark Shevlan',
        'clark.shevlan@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/e8dr5blfidt0ougqayd9.png',
        null,
        0
    ),
    (
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Roselia Danilchev',
        'roselia.danilchev@gmail.com',
        null,
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/hiegaoaqc31vld7iiyxx.png',
        null,
        0
    ),
    (
        '5beae775-0838-4778-8853-7f41275c0e37',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Ciro Kharchinski',
        'ciro.kharchinski@gmail.com',
        null,
        'female',
        null,
        null,
        1
    ),
    (
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Karol Stanyer',
        'karol.stanyer@gmail.com',
        null,
        null,
        null,
        null,
        1
    ),
    (
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Bradly Bonham',
        'bradly.bonham@gmail.com',
        null,
        'female',
        null,
        '6/3/2024',
        1
    ),
    (
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Kerr Menelaws',
        'kerr.menelaws@gmail.com',
        null,
        null,
        null,
        '9/16/2023',
        0
    ),
    (
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Berta Hebard',
        'berta.hebard@gmail.com',
        '9917375949',
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/l5mfkivokjtwayirww6j.png',
        null,
        1
    ),
    (
        'a1943068-54de-433b-9281-cc8f239039df',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Donica Wait',
        'donica.wait@gmail.com',
        '3767474529',
        'male',
        null,
        null,
        0
    ),
    (
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Duky Arlidge',
        'duky.arlidge@gmail.com',
        null,
        'female',
        null,
        '10/5/2023',
        0
    ),
    (
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Natalina Foakes',
        'natalina.foakes@gmail.com',
        '6272624549',
        'female',
        null,
        null,
        1
    ),
    (
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Ailsun Tregien',
        'ailsun.tregien@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/fdywfgg5usn96yyfy9bf.png',
        '12/8/2023',
        1
    ),
    (
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Brok Jaze',
        'brok.jaze@gmail.com',
        '9439602673',
        'male',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/bntxyial7tgerlkiueyu.png',
        null,
        1
    ),
    (
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Clair Sebastian',
        'clair.sebastian@gmail.com',
        null,
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/utkhrxchgmkjsirfmrmp.png',
        null,
        0
    ),
    (
        'f5f5946b-2834-447e-937e-1587df58d305',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Miguelita Pinckney',
        'miguelita.pinckney@gmail.com',
        '5053114347',
        'male',
        null,
        null,
        1
    ),
    (
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Giles Gabbidon',
        'giles.gabbidon@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/l5mfkivokjtwayirww6j.png',
        '6/5/2024',
        1
    ),
    (
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Rodrick English',
        'rodrick.english@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/bntxyial7tgerlkiueyu.png',
        null,
        1
    ),
    (
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Niles Skirving',
        'niles.skirving@gmail.com',
        null,
        'male',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/fdywfgg5usn96yyfy9bf.png',
        '12/15/2023',
        1
    ),
    (
        '060adf54-6678-479d-a85c-2ffa48344583',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Rose Brockhouse',
        'rose.brockhouse@gmail.com',
        null,
        null,
        null,
        null,
        0
    ),
    (
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Venita MacGilrewy',
        'venita.macgilrewy@gmail.com',
        null,
        null,
        null,
        null,
        1
    ),
    (
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Perrine Atte-Stone',
        'perrine.atte-stone@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/utkhrxchgmkjsirfmrmp.png',
        '9/25/2023',
        0
    ),
    (
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Wolfie Valencia',
        'wolfie.valencia@gmail.com',
        null,
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/qz4kqwj4f4curejrrc7x.png',
        '12/22/2023',
        0
    ),
    (
        '5703dd83-7177-4205-abe7-ba36962edc86',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Nadine Vaen',
        'nadine.vaen@gmail.com',
        null,
        'female',
        null,
        null,
        0
    ),
    (
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Ronny Sheavills',
        'ronny.sheavills@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/fdywfgg5usn96yyfy9bf.png',
        '8/16/2024',
        0
    ),
    (
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Georgina Learmouth',
        'georgina.learmouth@gmail.com',
        '6594060661',
        'male',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/utkhrxchgmkjsirfmrmp.png',
        null,
        1
    ),
    (
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Royall Lowensohn',
        'royall.lowensohn@gmail.com',
        '2203317558',
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/l5mfkivokjtwayirww6j.png',
        '10/24/2023',
        1
    ),
    (
        '0a055668-c845-4814-a58b-d28952026ff0',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Inessa Roderham',
        'inessa.roderham@gmail.com',
        '1689106393',
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/y1t83x6vwbxazwnmcgke.png',
        null,
        0
    ),
    (
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Rodrigo Spoerl',
        'rodrigo.spoerl@gmail.com',
        null,
        null,
        null,
        null,
        0
    ),
    (
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Koressa Sully',
        'koressa.sully@gmail.com',
        '7248726951',
        'male',
        null,
        null,
        0
    ),
    (
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Brooke De Vuyst',
        'brooke.de.vuyst@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/e8dr5blfidt0ougqayd9.png',
        '7/27/2024',
        0
    ),
    (
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Rene Ruecastle',
        'rene.ruecastle@gmail.com',
        null,
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/l5mfkivokjtwayirww6j.png',
        '2/9/2024',
        1
    ),
    (
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Hana Cleugher',
        'hana.cleugher@gmail.com',
        null,
        null,
        null,
        null,
        0
    ),
    (
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Thomasa Caush',
        'thomasa.caush@gmail.com',
        null,
        null,
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/r74itcqp4mbsrvnozg3o.png',
        '3/7/2024',
        1
    ),
    (
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Vivyanne Guidone',
        'vivyanne.guidone@gmail.com',
        '2479999281',
        'male',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/e8dr5blfidt0ougqayd9.png',
        '1/27/2024',
        0
    ),
    (
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Maryl Dupoy',
        'maryl.dupoy@gmail.com',
        '2544360280',
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/wmwifpgevvpwcb78tvxi.png',
        '12/29/2023',
        0
    ),
    (
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Nessie Potteril',
        'nessie.potteril@gmail.com',
        null,
        null,
        null,
        null,
        0
    ),
    (
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Claus Sacaze',
        'claus.sacaze@gmail.com',
        null,
        'male',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445362/groovo/wmwifpgevvpwcb78tvxi.png',
        '3/3/2024',
        0
    ),
    (
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Lammond Bauldry',
        'lammond.bauldry@gmail.com',
        null,
        'female',
        'https://res.cloudinary.com/dmiaubxsm/image/upload/v1726445361/groovo/l5mfkivokjtwayirww6j.png',
        null,
        1
    ),
    (
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '$2a$12$FuDE3q6FuHB1wwrN9OACCu1rS0R67uMVDkuYrB5iqhjwesgt8YhK2',
        'user',
        'Matti Kenealy',
        'matti.kenealy@gmail.com',
        null,
        'male',
        null,
        null,
        1
    );

;

-- Add Artist
insert into
    Artist (id_artist, name, slug, url_cover, is_show)
values
    (
        '907d73b1-be85-401c-915e-f97f45f167fb',
        'Sơn Tùng MTP',
        "son-tung-mtp",
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401448/f2xmimptoidxl1k8a1zg.jpg',
        true
    ),
    (
        'e4846d68-076f-4076-89e2-eb5324c538b8',
        'Mỹ Tâm',
        "my-tam",
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400292/ptjrn3zzdidsr88790at.jpg',
        true
    ),
    (
        'f9f4bb44-d5cd-46ec-8eec-c9590131c028',
        'Hồ Ngọc Hà',
        "ho-ngoc-ha",
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401476/g4xfzzbxntyn9jcewmch.jpg',
        true
    ),
    (
        '48a8dcc1-457f-4a3a-a1e3-b178a24ddaa6',
        'Noo Phước Thịnh',
        'noo-phuoc-thinh',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401336/zorva8tn2t9jayome2vs.jpg',
        true
    ),
    (
        '0f7e195e-0229-4d1c-8ce0-ce37c9d5e7b8',
        'Bích Phương',
        "bich-phuong",
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400792/qgaxfu5i07xoczhdiekj.jpg',
        true
    ),
    (
        '90ad932b-0eae-4da7-9a4e-c0cc7d50ecb8',
        'Erik',
        'erik',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400746/qdjzvkvk4pogcyqzzdwl.jpg',
        true
    ),
    (
        'a7f7aa29-32ee-4714-8ded-3375e5b2cbcf',
        'Hoàng Thùy Linh',
        'hoang-thuy-linh',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400537/fu3h5geowhjpwmyycjlr.jpg',
        true
    ),
    (
        '445fb681-2655-4f7a-91fc-d112911f5de6',
        'Hương Tràm',
        'huong-tram',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401501/nc7wus6jhjkw1kmqldsh.jpg',
        true
    ),
    (
        'a51722a1-f7dd-4eff-8d3f-d7d14106aa9c',
        'Đông Nhi',
        'dong-nhi',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400367/qarb5aomgunr0og4hedt.webp',
        true
    ),
    (
        '0199b8e3-530e-4d7c-967f-02522fab4ca1',
        'Tóc Tiên',
        'toc-tien',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401057/nqrlkvuszpsdlx5n3pwo.jpg',
        true
    ),
    (
        '786c5686-170f-440f-96de-6a9f7ed9a80e',
        'Trúc Nhân',
        'truc-nhan',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400367/qarb5aomgunr0og4hedt.webp',
        true
    ),
    (
        '520b1363-9305-43dd-a449-6e27e64bf806',
        'Phan Mạnh Quỳnh',
        'phan-manh-quynh',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401248/i1wugwfsufuiucolgdny.jpg',
        true
    ),
    (
        '711dd6e3-12d2-4e76-aa94-1cd4071e6152',
        'Thùy Chi',
        'thuy-chi',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400992/ldhtivf1ex36bkwt7gxc.jpg',
        true
    ),
    (
        '62dae2c3-db15-4d9f-ac51-87ac6f6d689e',
        'Đức Phúc',
        'duc-phuc',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400579/vlkyw6eox5kwe4qqq75z.jpg',
        true
    ),
    (
        '5960936c-7903-4478-a618-991c1faf5213',
        'Vũ Cát Tường',
        'vu-cat-tuong',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400922/d9ebbbj6ga3fzshm2fw8.jpg',
        true
    ),
    (
        '14569232-facc-4326-a132-707dbd4949eb',
        'Soobin Hoàng Sơn',
        'soobin-hoang-son',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401115/baywp6pb0tlqhcyxppna.jpg',
        true
    ),
    (
        '21343433-e331-4612-9cde-a34ace9bcfaa',
        'Binz',
        'binz',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401210/dc7s3uhgjp9wpol0c7jg.jpg',
        true
    ),
    (
        'd14e0baa-9d23-4db7-8d17-7024b56b251f',
        'Ngô Kiến Huy',
        'ngo-kien-huy',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401651/ondxd4glcqikaliywytq.webp',
        true
    ),
    (
        'bf5f843c-cdb4-453b-a7fc-ff8ec4f35ee6',
        'Hương Giang',
        'huong-giang',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400893/b0qkd5hy1auhtymuw5fo.jpg',
        true
    ),
    (
        '12946523-5547-432a-80ee-cb93ca4dc12e',
        'Bảo Anh',
        'bao-anh',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401544/jarxa5m7fvvpheal6rxv.jpg',
        true
    ),
    (
        '67f39292-bcde-4d01-a548-e397dfa65c34',
        'Văn Mai Hương',
        'van-mai-huong',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400491/hwfxvp7idopukkd9vkpl.jpg',
        true
    ),
    (
        '36d11afb-2209-4601-92b4-0a76665c52d7',
        'Bùi Anh Tuấn',
        'bui-anh-tuan',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400468/k2zasc2wcf8964nhqjfb.jpg',
        true
    ),
    (
        '039151b5-ca1d-4d34-9d73-fc2d526204ad',
        'Isaac',
        'isaac',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401366/dbp7wshzrae9g0ecgfh7.jpg',
        true
    ),
    (
        'c27b360e-cafc-4405-9d5e-5d981e6b58ee',
        'Lynk Lee',
        'lynk-lee',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401686/czztnx0xhkajevkzy1wg.jpg',
        true
    ),
    (
        'aa2803fa-664e-4761-8449-d2f09926d352',
        'JustaTee',
        'justatee',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400719/e3fo0lw8zrkxbepce7d2.jpg',
        true
    ),
    (
        '4fff9e5a-a6cb-429f-a23c-8e18e8edf476',
        'Khởi My',
        'khoi-my',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401625/iix26tgsrihqpncrn9w7.webp',
        true
    ),
    (
        'bbb9ef72-f785-47be-abb9-259b259f26e1',
        'Đen Vâu',
        'den-vau',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401709/vlcaf2g7vak9zxgch1cx.jpg',
        true
    ),
    (
        'd66b1d03-572e-434d-8f4a-ece5c4f2b4ea',
        'Phương Mỹ Chi',
        'phuong-my-chi',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401133/xfncwacyfb7jhpgi9vzj.jpg',
        true
    ),
    (
        '08267cb7-c7f5-4e4b-9551-b16ed1705c79',
        'Vicky Nhung',
        'vicky-nhung',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400519/ta95nobu4nbcpuctmdsc.jpg',
        true
    ),
    (
        '4a192888-e08b-4a72-9009-1d205c66d042',
        'Beyoncé',
        'beyonce',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400421/eynidgoqrvosk69ltguq.webp',
        true
    ),
    (
        '13de5d5b-181b-4987-b602-2cb2497b10c6',
        'Taylor Swift',
        'taylor-swift',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401029/x2us7g3sozjrvnwud5tm.jpg',
        true
    ),
    (
        '06dceb61-618b-473e-a21a-1ed649056652',
        'Ed Sheeran',
        'ed-sheeran',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401750/msxu528ndoaxqomaihd1.jpg',
        true
    ),
    (
        '2716d1b5-832b-4ef6-a153-a2f515637930',
        'Adele',
        'adele',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400404/yt9wruktriizp5umxvcb.jpg',
        true
    ),
    (
        '01c4e7a4-5047-4b5a-b8b0-3df257ad43e1',
        'Justin Bieber',
        'justin-bieber',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401790/alykgefsvx6vgp7vctx5.webp',
        true
    ),
    (
        'd09bb6f8-7841-4612-aca2-44a0c8e20332',
        'Ariana Grande',
        'ariana-grande',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401601/kjeawebzmeax1qslhyxd.jpg',
        true
    ),
    (
        '28858c3e-ea45-4d8c-a877-23050846588a',
        'Billie Eilish',
        'billie eilish',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400333/wuk7338uefz3pp2zzer4.jpg',
        true
    ),
    (
        '46e7fcf5-0855-4630-a5fe-77c816f094bf',
        'Lady Gaga',
        'lady-gaga',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401764/zylmo5ztk2ur87sgirwz.jpg',
        true
    ),
    (
        'c1d6664f-9594-457e-b31c-b9e857a98a5b',
        'Bruno Mars',
        'bruno-mars',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401577/wxtfezbtkqaztwpssxku.jpg',
        true
    ),
    (
        'f3e06442-f888-45d1-98d6-1365537f19cd',
        'Katy Perry',
        'katy-perry',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727401192/jhcnhiwflzkkgnolwxg6.jpg',
        true
    ),
    (
        '17105254-7bcf-4f8c-87fb-844fd1b38e08',
        'Shakira',
        'shakira',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400958/juiqt7q2iyot5eghi2t5.jpg',
        true
    ),
    (
        '17105254-7bcf-4f8c-87fb-844fd1b38e02',
        'Alan Walker',
        'alan-walker',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727400958/juiqt7q2iyot5eghi2t5.jpg',
        true
    );

-- Add Type
insert into
    Type (id_type, name, slug, is_show)
values
    (
        '2462b1a4-7c6e-4d53-9c60-3b7788b228b9',
        'V-Pop',
        null,
        1
    ),
    (
        '71b247ee-fecd-482a-b437-6ae887e607e4',
        'Bolero',
        null,
        1
    ),
    (
        '43282b65-eace-4232-b0f6-f6b155df9de6',
        'Rap',
        null,
        1
    ),
    (
        'c0790a9d-8549-40ec-a661-a00866f9b44c',
        'EDM',
        'jazz',
        0
    ),
    (
        'ce29bf8b-6470-428f-9c16-f94288772baf',
        'Rock',
        null,
        0
    ),
    (
        '95825405-d19d-4506-a4e8-9b893d14e3b0',
        'Truyền thống',
        'electronic',
        0
    ),
    (
        '876e35b7-86e5-4323-8d00-354ff25d7e22',
        'Aucoustic',
        'classical',
        1
    ),
    (
        '13ca475e-f8e3-4716-8496-9d8c853e9546',
        'R&B',
        null,
        1
    );

-- Add Music
-- Sơn tùng MTP
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Em của ngày hôm qua',
        'em-cua-ngay-hom-qua',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727431913/nt1ptm3xf8lpfhljngpn.webm',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727430691/uhklis6zlvwdkxkzunv5.jpg',
        null,
        'Long Halo',
        'Sơn Tùng MTP',
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Chắc ai đó sẽ về',
        'chac-ai-do-se-ve',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727431478/rpmqyciepjvsuwjesfky.mp3',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727430608/fy9iie84ei9sybtk8mxu.jpg',
        null,
        'Nguyễn Hà',
        'Sơn Tùng MTP',
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Không phải dạng vừa đâu',
        'khong-phai-dang-vua-dau',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727431624/llkm5v1bhdtxdrww4bpc.mp4',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727430716/btaojl8ocwi3kgeltyjc.jpg',
        null,
        'SlimV',
        'Sơn Tùng MTP',
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Âm thầm bên em',
        'am-tham-ben-em',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727431433/eh85nupsxzs6yye39twq.mp3',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727430574/nv4jvs1nxolq1y4beijx.jpg',
        null,
        'SlimV',
        'Sơn Tùng MTP',
        1
    ),
    (
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Chúng ta không thuộc về nhau',
        'chung-ta-khong-thuoc-ve-nhau',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727431545/tcjn5xnbwhwo0degil13.mp4',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727430666/gcnqhe8ez8z3kvp6j0kd.jpg',
        null,
        'Triple D',
        'Sơn Tùng MTP',
        1
    ),
    (
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Lạc trôi',
        'lac-troi',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727431817/mnriqsdarjeas9isj5wd.webm',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727430741/jzxoogccndvmrqyaduqo.jpg',
        null,
        'Triple D, Masew',
        'Sơn Tùng MTP',
        1
    ),
    (
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Nơi này có anh',
        'noi-nay-co-anh',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727431686/idwz5xiq1evzxa2jxhpe.mp4',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727430767/m1aaiz2kyvadwz7hgsof.jpg',
        null,
        'Khắc Hưng',
        'Sơn Tùng MTP',
        1
    ),
    (
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Chạy ngay đi',
        'chay-ngay-di',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727431511/ubkei3l2qjd1kdfmaqlz.mp3',
        'http://res.cloudinary.com/dmiaubxsm/image/upload/v1727430645/kypexv2qzdwyj84jhpm6.jpg',
        null,
        'Onionn',
        'Sơn Tùng MTP',
        1
    );

-- Mỹ Tâm
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hẹn ước từ hư vô',
        'hen-uoc-tu-hu-vo',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727492933/ctt35bgevef1np7ze0yl.mp3',
        'cover',
        null,
        'My Entertainment',
        'Phan Mạnh Quỳnh',
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Như một giấc mơ',
        'nhu-mot-giac-mo',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727493052/szjc60mztifispank0ty.mp3',
        'cover',
        null,
        'My Entertainment',
        null,
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Người hãy quên em đi',
        'nguoi-hay-quen-em-di',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727493364/ujo5fssyyxl3dy11sugq.mp3',
        'cover',
        null,
        'Khắc Hưng',
        null,
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Niềm tin chiến thắng',
        'niem-tin-chien-thang',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727493394/ok1mkd6qciv8ryhsjtxq.mp3',
        'cover',
        null,
        null,
        'Nhạc sĩ Lê Quang',
        1
    ),
    (
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Ước gì',
        'uoc-gi',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727493084/lglt757r6cxniuv9tujx.mp3',
        'cover',
        null,
        null,
        'Nhạc sĩ Võ Thiện Thanh',
        1
    ),
    (
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Cây đàn sinh viên',
        'cay-dan-sinh-vien',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727493020/n8xiaev3fddnlz2zk5zw.mp3',
        'cover',
        null,
        null,
        'Nhạc sĩ Quốc An',
        1
    ),
    (
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Cứ vui lên',
        'cu-vui-len',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727493159/fiu6z95hr2gse7kfxfil.mp3',
        'cover',
        null,
        null,
        'Trịnh Bảo Bàng',
        1
    );

-- Bích Phương
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bùa yêu',
        'bua-yeu',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727575241/venmkmzf8q6bcupp8wwc.mp3',
        'https://i1.sndcdn.com/artworks-000350133636-mil48l-t500x500.jpg',
        null,
        null,
        'Tiên Cookie, Phạm Thanh Hà, DươngK',
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Đi đu đưa đi',
        'di-du-dua-di',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727575256/zycvzm0ujeewkfjw2hr2.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_ieTDrsIz1nRnTUxWVy_TaLen6lHjN2t0Ig&s',
        null,
        null,
        'Tiên Cookie, Phạm Thanh Hà',
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Một cú lừa',
        'mot-cu-lua',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727575269/aycgjpsqwhp8g75ogzht.mp3',
        'https://avatar-ex-swe.nixcdn.com/song/share/2020/05/31/0/e/7/e/1590919525767.jpg',
        null,
        null,
        'Tiên Cookie',
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Từ chối nhẹ nhàng thôi',
        'tu-choi-nhe-nhang-thoi',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727575315/vousfrp4qhctqwonfpp0.mp3',
        'https://i.ytimg.com/vi/h23OBd1VZsg/maxresdefault.jpg',
        null,
        null,
        'Tiên Cookie',
        1
    );

-- Trúc Nhân
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Có không giữ mất đừng tìm',
        'co-khong-giu-mat-dung-tim',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572254/ub965yum6scuarkzvd6z.mp3',
        'https://photo-resize-zmp3.zmdcdn.me/w600_r1x1_jpeg/cover/0/3/9/7/0397842eb359d014b1928c3a7ff7d548.jpg',
        null,
        'TDK, Minh Hoàng, Long X, Nguyễn Hải Phong',
        'Bùi Công Nam',
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Vẽ',
        've-truc-nhan',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572381/by19zhmwwuvyt1mpabmp.mp3',
        'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/covers/c/2/c270eb7dd0e8b6b2e46e7b8efb3a1362_1417392544.jpg',
        null,
        'Khắc Hưng',
        'Nguyễn Thúc Thùy Tiên',
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Sáng mắt chưa',
        'sang-mat-chua',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572340/iuiowuyficpoktrul2n7.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR67QorbrNlM-3Y6qakPEMB99IC8qoeCvD0xQ&s',
        null,
        'Nguyễn Hải Phong',
        'Mew Amzing',
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Lớn rồi còn khóc nhè',
        'lon-roi-con-khoc-nhe',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572281/ugukwlrcgusdggcuvtzx.mp3',
        'https://i1.sndcdn.com/artworks-000541716087-rp4kxc-t500x500.jpg',
        null,
        null,
        'Nguyễn Hải Phong',
        1
    ),
    (
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Bốn chữ lắm',
        'bon-chu-lam',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572228/yfhlnr7sa3wbqvipk6md.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSenuDJJVjd_QWhnpM4TX7U8f5Wm73w5dt0XA&s',
        null,
        null,
        'Phạm Toàn Thắng & Nguyễn Duy Anh',
        1
    ),
    (
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Thật bất ngờ',
        'that-bat-ngo',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572360/m0em11acbbcuu08btg3t.mp3',
        'https://i.ytimg.com/vi/hlGSgR8sljw/maxresdefault.jpg',
        null,
        null,
        'Mew Amazing, Dương Khắc Linh & Cao Bá Hưng',
        1
    ),
    (
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Ngồi hát đớ buồn',
        'ngoi-hat-do-buon',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572313/qwsnkm4pfc3lsh3zi3cs.mp3',
        'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/covers/8/d/8d0e9de9056dc4f3a6aac5f3dfad1b8d_1499396093.jpg',
        null,
        null,
        'Nguyễn Hải Phong',
        1
    );

-- Phan Mạnh Quỳnh
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Sau lời từ khước',
        'sau-loi-tu-khuoc',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572578/p92ue4cy9xs5qkj30cun.mp3',
        'https://photo-resize-zmp3.zmdcdn.me/w256_r1x1_jpeg/cover/e/d/0/7/ed0741228ad36870e13624120474e50a.jpg',
        null,
        'Warner Music Vietnam',
        'Phan Mạnh Quỳnh',
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Có chàng trai viết lên cây',
        'co-chang-trai-viet-len-cay',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572430/xgw7vauul8u04ynaz79l.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3Bd82r4DcyeudeQ_030LXf-nwZi0NiueNPw&s',
        null,
        'Future Da Producer',
        'Phan Mạnh Quỳnh',
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Chuyến xe',
        'chuyen-xe',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572411/up8y1nwnmq7l2otdjezp.mp3',
        'https://i.ytimg.com/vi/uM6UAXLa3ck/maxresdefault.jpg',
        null,
        null,
        'Phan Mạnh Quỳnh',
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Nước ngoài',
        'nuoc-ngoai',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572548/fnvczzn3ybqdzye4psku.mp3',
        'https://i.ytimg.com/vi/_j3LFYBBXY0/maxresdefault.jpg',
        null,
        null,
        'Phan Mạnh Quỳnh',
        1
    ),
    (
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Từ đó',
        'tu-do',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572600/mm6xxdmcr6b0cqfoivtd.mp3',
        'https://i.ytimg.com/vi/HsgTIMDA6ps/maxresdefault.jpg',
        null,
        null,
        'Phan Mạnh Quỳnh',
        1
    );

-- Đen Vâu
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hai triệu năm',
        'hai-trieu-nam',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572645/pkqjuswdlil20pkmb1mo.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtTScq3FxtIEEHbKuJk1LmimRaiTs_xIkTWw&s',
        null,
        null,
        'Đen Vâu',
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Mười năm',
        'chac-ai-do-se-ve',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572733/d1vxfmxnv8aqf3gany9n.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSEAIEXIDsTk6vn_wlDXfyitq6bpjAJo2c5g&s',
        null,
        null,
        'Đen Vâu',
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Mang tiền về cho mẹ',
        'mang-tien-ve-cho-me',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572498/z8ua5jc5ut26zufsvmv8.mp3',
        'https://image.sggp.org.vn/w1000/Uploaded/2024/evofjasfzyr/2022_01_17/1-den-vau_KELX.jpg.webp',
        null,
        null,
        'Đen Vâu',
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Đi về nhà',
        'di-ve-nha',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572455/oy6wahzpxhuukfpkfmlj.mp3',
        'https://i.ytimg.com/vi/Eb7NLJwejoU/maxresdefault.jpg',
        null,
        null,
        'Đen Vâu',
        1
    );

-- Phương Mỹ Chi
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bóng Phù Hoa',
        'bong-phu-hoa',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572759/ljozjythwgclgknngdpb.mp3',
        'https://i.ytimg.com/vi/jhln5b4wOfI/maxresdefault.jpg',
        null,
        null,
        null,
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Những ngôi sao xa xôi',
        'nhung-ngoi-sao-xa-xoi',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572810/na9iesbcesybkxmsiovx.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1JsheXVm35xqs_0nTDufhwukYn6Z6H18rBw&s',
        null,
        null,
        null,
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Chiếc áo bà ba',
        'chiec-ao-ba-ba',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572788/q4wsj67yctncgcfna1zr.mp3',
        'https://i.ytimg.com/vi/odrMPD2mxWs/maxresdefault.jpg',
        null,
        null,
        null,
        1
    );

-- Vicky Nhung
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Việt nam những chuyến đi',
        'viet-nam-nhung-chuyen-di',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572872/nybt34lzaexoewznbqax.mp3',
        'https://photo-resize-zmp3.zmdcdn.me/w256_r1x1_jpeg/cover/c/1/0/9/c10933c1432673fd0db936d200afbb29.jpg',
        null,
        null,
        null,
        1
    );

-- Beyonce
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Halo',
        'halo',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572883/fy0bqznwj81xnqaup7rw.mp3',
        'https://upload.wikimedia.org/wikipedia/en/a/ac/Beyonce_-_Halo.png',
        null,
        null,
        null,
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Run the world',
        'run-the-world',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572932/gnytqjgkgqac5fyqcyrb.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReamHBvuwJA3F8K_dRThIEFSEu7LgSNLMafg&s',
        null,
        null,
        null,
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'If I were a boy',
        'if-i-were-a-boy',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572914/zzklss1ggcogypwaikcf.mp3',
        'https://upload.wikimedia.org/wikipedia/en/4/4b/Beyonce_-_If_I_Were_a_Boy_%28single%29.png',
        null,
        null,
        null,
        1
    );

-- Taylor Swift
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Love story',
        'love-story',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572982/v2gvwlyn0z9djy5oxcww.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStlVwv0kJme5AnfPm8JxDKdTkfUSQcV6WShA&s',
        null,
        null,
        null,
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Look what you you made me do',
        'look-what-you-made-me-do',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727572960/j0gqhgiyn3cbar12x9ds.mp3',
        'https://upload.wikimedia.org/wikipedia/vi/f/fd/LWYMMD_Official_single_cover.jpg',
        null,
        null,
        null,
        1
    );

-- Ed Sheeran
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'The A Team',
        'the-a-team',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573182/dw1doseiybl82ytdj7vd.mp3',
        'https://upload.wikimedia.org/wikipedia/en/6/60/Ed_Sheeran_-_The_A_Team.png',
        null,
        null,
        null,
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Lego house',
        'lego-house',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573094/mmgqrt1imfcfmizldjoc.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrKJTajcZ6RfjuNHuGISvY9pn_YepIqriTiw&s',
        null,
        null,
        null,
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Shape of you',
        'shape-of-you',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573107/vwmxcjfoenof2ylw0tsw.mp3',
        'https://i.ytimg.com/vi/JGwWNGJdvx8/sddefault.jpg',
        null,
        null,
        null,
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Castle on the hill',
        'castle-on-the-hill',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573018/dms1muhmfbftppcimnl4.mp3',
        'https://m.media-amazon.com/images/M/MV5BNGE2OTdlNjktYzIzZC00YzNiLWJjMjUtMjIwNDlhMDAzZmFjXkEyXkFqcGc@._V1_.jpg',
        null,
        null,
        null,
        1
    );

-- Adele
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Someone like you',
        'someone-like-you',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573132/jplghw7m3zgoge7nffbv.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMEFPcTxQe2UHfvABcSptaYhhrMc_lEyp2qg&s',
        null,
        null,
        null,
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Hello',
        'hello',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573032/lwrkar899te6bivoaad5.mp3',
        'https://m.media-amazon.com/images/M/MV5BNTc4ODVkMmMtZWY3NS00OWI4LWE1YmYtN2NkNDA3ZjcyNTkxXkEyXkFqcGc@._V1_.jpg',
        null,
        null,
        null,
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Rolling in the deep',
        'rolling-in-the-deep',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573205/bvymardefnft8yr2wuol.mp3',
        'https://upload.wikimedia.org/wikipedia/en/7/74/Adele_-_Rolling_in_the_Deep.png',
        null,
        null,
        null,
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Set fire to the rain',
        'set-fire-to-the-rain',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573227/blubyoxy5cky4udjtezt.mp3',
        'https://i1.sndcdn.com/artworks-8ULFu6bD4KrQITve-ZxopmQ-t500x500.jpg',
        null,
        null,
        null,
        1
    );

-- Justin Bieber
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Stay',
        'stay',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573348/czw9xfuqrdfk44mryofa.mp3',
        'https://i1.sndcdn.com/artworks-NTWumskIAtzxndKO-yz1ryA-t500x500.jpg',
        null,
        null,
        null,
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Baby',
        'baby',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573256/lkgpebnc4cgoqvbj1q1j.mp3',
        'https://upload.wikimedia.org/wikipedia/vi/d/d1/Babycoverart.jpg',
        null,
        null,
        null,
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Onetime',
        'onetime',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573318/sxtczsoej2xgxi2ynan2.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScHXTs6zj4mheKgXoKtFZbGxGTS2vmegVCDQ&s',
        null,
        null,
        null,
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Love me',
        'love-me',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573280/nidpbqzitsxfdhluv4ks.mp3',
        'https://i.scdn.co/image/ab67616d0000b2737c3bb9f74a98f60bdda6c9a7',
        null,
        null,
        null,
        1
    ),
    (
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Mood',
        'mood',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573309/uzt9yc2wpy4xpiiwrzws.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThtSUy9UFmBYq9B_dqWisgE-snyMnqfeAA1g&s',
        null,
        null,
        null,
        1
    ),
    (
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Sorry',
        'sorry',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573332/enct9j5fl2ngc78vmsxm.mp3',
        'https://upload.wikimedia.org/wikipedia/en/d/dc/Justin_Bieber_-_Sorry_%28Official_Single_Cover%29.png',
        null,
        null,
        null,
        1
    );

-- Katy Perry
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Roar',
        'roar',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573419/lew1eftwp99tcdn817b0.mp3',
        'https://i.ytimg.com/vi/CevxZvSJLk8/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLACmGBvA_4JDjhAvcm88duJUJZBFw',
        null,
        null,
        null,
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Dark horse',
        'dark-horse',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573376/ugjoi8pjnvrh48yfoerk.mp3',
        'https://static.independent.co.uk/s3fs-public/thumbnails/image/2014/02/26/10/katy-perry-dark-horse-v2.jpg',
        null,
        null,
        null,
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hot N Cold',
        'hot-n-cold',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573408/q496shibxfo583y4yepb.mp3',
        'https://upload.wikimedia.org/wikipedia/vi/a/ab/Katy_Perry_Hot_N_Cold.jpg',
        null,
        null,
        null,
        1
    );

-- Alan Walker
insert into
    Music (
        id_music,
        name,
        slug,
        url_path,
        url_cover,
        total_duration,
        producer,
        composer,
        is_show
    )
values
    (
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Faded',
        'faded',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573542/iqpa4fauvwcrilx2kp9v.mp3',
        'https://i.ytimg.com/vi/pasha7KJ6_o/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBggqWZEe0s69iUEBjwnQXwBaWI7Q',
        null,
        null,
        null,
        1
    ),
    (
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'All I want for chrismas',
        'all-i-want-for-chrismas',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573586/ovycqdevikvjcx4nlprc.mp3',
        'https://i.ytimg.com/vi/Yd_uia5us-c/maxresdefault.jpg',
        null,
        null,
        null,
        1
    ),
    (
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Lonely',
        'lonely',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573626/tluxgzjesnsx0zq3vmg5.mp3',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRk619y4eeOacxQVANaQvKItYhWkTTgRx5S8Q&s',
        null,
        null,
        null,
        1
    ),
    (
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'What do you mean',
        'what-do-you-mean',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573650/whdbpppaazzwqmdzlm4y.mp3',
        'https://helios-i.mashable.com/imagery/articles/031nHILV3WVKY9J9zJSxbyF/hero-image.fill.size_1200x900.v1611607646.jpg',
        null,
        null,
        null,
        1
    ),
    (
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Stay',
        'stay',
        'http://res.cloudinary.com/dmiaubxsm/video/upload/v1727573687/xyhmlf1hca3ubyseaim4.mp3',
        'https://i1.sndcdn.com/artworks-y7nXhwuaVIot4FOl-Z8LivA-t500x500.jpg',
        null,
        null,
        null,
        1
    );

-- Add Album
insert into
    Album (
        id_album,
        id_artist,
        name,
        slug,
        url_cover,
        release_date,
        publish_date,
        publish_by,
        is_show
    )
values
    (
        'e299c5c8-f780-48f5-9bea-41ccfdcd54d5',
        'f9f4bb44-d5cd-46ec-8eec-c9590131c028',
        'Electric Dreams',
        'electric-dreams',
        'https://ovh.net/congue/diam/id/ornare/imperdiet.jsp?euismod=luctus&scelerisque=ultricies&quam=eu&turpis=nibh&adipiscing=quisque&lorem=id&vitae=justo&mattis=sit&nibh=amet&ligula=sapien&nec=dignissim&sem=vestibulum&duis=vestibulum&aliquam=ante&convallis=ipsum&nunc=primis&proin=in&at=faucibus&turpis=orci&a=luctus&pede=et&posuere=ultrices&nonummy=posuere&integer=cubilia&non=curae&velit=nulla&donec=dapibus&diam=dolor&neque=vel&vestibulum=est&eget=donec&vulputate=odio&ut=justo&ultrices=sollicitudin&vel=ut&augue=suscipit&vestibulum=a&ante=feugiat&ipsum=et&primis=eros&in=vestibulum&faucibus=ac&orci=est&luctus=lacinia&et=nisi&ultrices=venenatis&posuere=tristique',
        '1/14/2024',
        null,
        null,
        1
    ),
    (
        '1ef1e156-f296-4d7f-8ac1-5796d5d346ed',
        '445fb681-2655-4f7a-91fc-d112911f5de6',
        'Midnight Moonlight',
        null,
        'https://com.com/curabitur/at/ipsum.jpg?sed=vehicula&vestibulum=condimentum&sit=curabitur&amet=in&cursus=libero&id=ut&turpis=massa&integer=volutpat&aliquet=convallis&massa=morbi&id=odio',
        '2/14/2024',
        '2023-11-26T17:06:03Z',
        null,
        1
    ),
    (
        '1f9bbfb0-6878-46a1-8fb4-269c491e93a8',
        'e4846d68-076f-4076-89e2-eb5324c538b8',
        'Midnight Moonlight',
        'midnight-moonlight',
        'https://youku.com/orci/nullam/molestie/nibh/in/lectus.html?viverra=porttitor&dapibus=id&nulla=consequat&suscipit=in&ligula=consequat&in=ut&lacus=nulla&curabitur=sed&at=accumsan&ipsum=felis&ac=ut&tellus=at&semper=dolor&interdum=quis&mauris=odio&ullamcorper=consequat&purus=varius&sit=integer&amet=ac&nulla=leo&quisque=pellentesque&arcu=ultrices&libero=mattis&rutrum=odio&ac=donec',
        null,
        '2024-03-13T02:40:15Z',
        null,
        0
    ),
    (
        'f626f92f-35fd-47e8-82b4-af93e19866c5',
        '0f7e195e-0229-4d1c-8ce0-ce37c9d5e7b8',
        'Crystal Clear',
        'crystal-clear',
        'https://indiegogo.com/mauris.js?justo=ipsum&aliquam=primis&quis=in&turpis=faucibus&eget=orci&elit=luctus&sodales=et&scelerisque=ultrices&mauris=posuere&sit=cubilia&amet=curae&eros=nulla&suspendisse=dapibus&accumsan=dolor&tortor=vel&quis=est&turpis=donec&sed=odio&ante=justo&vivamus=sollicitudin&tortor=ut&duis=suscipit&mattis=a&egestas=feugiat&metus=et&aenean=eros&fermentum=vestibulum&donec=ac&ut=est&mauris=lacinia&eget=nisi&massa=venenatis&tempor=tristique&convallis=fusce&nulla=congue&neque=diam&libero=id&convallis=ornare&eget=imperdiet&eleifend=sapien&luctus=urna&ultricies=pretium&eu=nisl&nibh=ut&quisque=volutpat&id=sapien&justo=arcu&sit=sed&amet=augue&sapien=aliquam&dignissim=erat&vestibulum=volutpat&vestibulum=in&ante=congue&ipsum=etiam&primis=justo',
        '11/20/2023',
        '2024-01-21T18:55:23Z',
        'Beat Street Publishing',
        1
    ),
    (
        '358b945c-56c5-44dd-aab9-80747151d171',
        '0f7e195e-0229-4d1c-8ce0-ce37c9d5e7b8',
        'Wildfire Whispers',
        null,
        'http://ask.com/in/faucibus/orci/luctus/et/ultrices/posuere.js?velit=vulputate&donec=ut&diam=ultrices&neque=vel&vestibulum=augue&eget=vestibulum&vulputate=ante&ut=ipsum&ultrices=primis&vel=in&augue=faucibus&vestibulum=orci&ante=luctus&ipsum=et&primis=ultrices&in=posuere&faucibus=cubilia&orci=curae&luctus=donec&et=pharetra&ultrices=magna&posuere=vestibulum&cubilia=aliquet&curae=ultrices&donec=erat&pharetra=tortor&magna=sollicitudin&vestibulum=mi&aliquet=sit&ultrices=amet&erat=lobortis&tortor=sapien&sollicitudin=sapien&mi=non&sit=mi&amet=integer&lobortis=ac&sapien=neque&sapien=duis&non=bibendum&mi=morbi&integer=non&ac=quam&neque=nec&duis=dui&bibendum=luctus&morbi=rutrum&non=nulla&quam=tellus&nec=in&dui=sagittis&luctus=dui&rutrum=vel&nulla=nisl&tellus=duis&in=ac&sagittis=nibh&dui=fusce&vel=lacus&nisl=purus&duis=aliquet&ac=at&nibh=feugiat&fusce=non&lacus=pretium&purus=quis&aliquet=lectus&at=suspendisse&feugiat=potenti&non=in&pretium=eleifend&quis=quam&lectus=a&suspendisse=odio&potenti=in&in=hac&eleifend=habitasse&quam=platea&a=dictumst&odio=maecenas&in=ut&hac=massa&habitasse=quis&platea=augue&dictumst=luctus&maecenas=tincidunt&ut=nulla&massa=mollis',
        '7/31/2024',
        '2024-05-28T22:33:36Z',
        null,
        0
    ),
    (
        '115eac33-c7f7-416a-8ab8-e0b378ac4ddb',
        '0f7e195e-0229-4d1c-8ce0-ce37c9d5e7b8',
        'Neon Nights',
        'neon-nights',
        'http://netlog.com/in/hac.js?amet=id&sem=turpis&fusce=integer&consequat=aliquet&nulla=massa&nisl=id&nunc=lobortis&nisl=convallis&duis=tortor&bibendum=risus&felis=dapibus&sed=augue&interdum=vel&venenatis=accumsan&turpis=tellus&enim=nisi&blandit=eu&mi=orci&in=mauris&porttitor=lacinia&pede=sapien&justo=quis&eu=libero&massa=nullam&donec=sit&dapibus=amet&duis=turpis&at=elementum&velit=ligula&eu=vehicula&est=consequat&congue=morbi&elementum=a&in=ipsum&hac=integer&habitasse=a&platea=nibh&dictumst=in&morbi=quis&vestibulum=justo&velit=maecenas&id=rhoncus&pretium=aliquam&iaculis=lacus&diam=morbi&erat=quis&fermentum=tortor&justo=id&nec=nulla&condimentum=ultrices&neque=aliquet&sapien=maecenas&placerat=leo&ante=odio&nulla=condimentum&justo=id&aliquam=luctus&quis=nec&turpis=molestie&eget=sed&elit=justo&sodales=pellentesque&scelerisque=viverra&mauris=pede&sit=ac&amet=diam&eros=cras&suspendisse=pellentesque&accumsan=volutpat&tortor=dui&quis=maecenas&turpis=tristique&sed=est&ante=et&vivamus=tempus&tortor=semper&duis=est&mattis=quam&egestas=pharetra&metus=magna&aenean=ac',
        null,
        null,
        'Harmony House Music',
        0
    ),
    (
        'b07eb2ab-12d4-46c5-8577-8d99404370b6',
        '0f7e195e-0229-4d1c-8ce0-ce37c9d5e7b8',
        'Mystic Melodies',
        null,
        'http://ning.com/nulla/nunc/purus.png?elementum=ridiculus&pellentesque=mus&quisque=vivamus&porta=vestibulum&volutpat=sagittis&erat=sapien&quisque=cum&erat=sociis&eros=natoque&viverra=penatibus&eget=et&congue=magnis&eget=dis&semper=parturient&rutrum=montes&nulla=nascetur&nunc=ridiculus&purus=mus&phasellus=etiam&in=vel&felis=augue&donec=vestibulum&semper=rutrum&sapien=rutrum&a=neque&libero=aenean&nam=auctor&dui=gravida&proin=sem&leo=praesent&odio=id&porttitor=massa&id=id&consequat=nisl&in=venenatis&consequat=lacinia&ut=aenean&nulla=sit&sed=amet&accumsan=justo&felis=morbi&ut=ut&at=odio&dolor=cras&quis=mi&odio=pede&consequat=malesuada&varius=in&integer=imperdiet',
        '11/29/2023',
        null,
        'Harmony House Music',
        0
    ),
    (
        '0b9aff1e-a524-40dd-8a05-f84687945427',
        '0f7e195e-0229-4d1c-8ce0-ce37c9d5e7b8',
        'Silver Shadows',
        null,
        'http://umich.edu/consequat/lectus.json?quisque=leo&porta=odio&volutpat=condimentum&erat=id&quisque=luctus&erat=nec&eros=molestie&viverra=sed&eget=justo&congue=pellentesque&eget=viverra&semper=pede&rutrum=ac&nulla=diam&nunc=cras&purus=pellentesque&phasellus=volutpat&in=dui&felis=maecenas&donec=tristique&semper=est&sapien=et&a=tempus&libero=semper&nam=est&dui=quam&proin=pharetra&leo=magna&odio=ac&porttitor=consequat&id=metus&consequat=sapien&in=ut&consequat=nunc&ut=vestibulum',
        null,
        '2024-09-05T05:24:46Z',
        null,
        1
    ),
    (
        '6a60a074-2be8-4551-9bad-e9c264f35dbb',
        'e4846d68-076f-4076-89e2-eb5324c538b8',
        'Wildfire Whispers',
        null,
        'http://slate.com/nam/nulla/integer/pede/justo/lacinia.html?duis=auctor&at=gravida&velit=sem&eu=praesent&est=id&congue=massa&elementum=id&in=nisl&hac=venenatis&habitasse=lacinia&platea=aenean&dictumst=sit&morbi=amet&vestibulum=justo&velit=morbi&id=ut&pretium=odio&iaculis=cras&diam=mi&erat=pede&fermentum=malesuada&justo=in&nec=imperdiet&condimentum=et&neque=commodo&sapien=vulputate&placerat=justo&ante=in&nulla=blandit&justo=ultrices&aliquam=enim&quis=lorem&turpis=ipsum&eget=dolor&elit=sit&sodales=amet&scelerisque=consectetuer&mauris=adipiscing&sit=elit&amet=proin&eros=interdum&suspendisse=mauris&accumsan=non&tortor=ligula&quis=pellentesque&turpis=ultrices&sed=phasellus&ante=id&vivamus=sapien&tortor=in&duis=sapien&mattis=iaculis&egestas=congue&metus=vivamus&aenean=metus&fermentum=arcu&donec=adipiscing&ut=molestie&mauris=hendrerit&eget=at&massa=vulputate&tempor=vitae&convallis=nisl',
        '5/1/2024',
        '2023-12-20T17:33:41Z',
        'Melody Makers Publishing',
        0
    ),
    (
        '06e51b25-b0a1-41b1-b571-6f0b16c2b70e',
        '445fb681-2655-4f7a-91fc-d112911f5de6',
        'Sunset Serenade',
        null,
        'https://dropbox.com/etiam/justo.xml?eros=faucibus&elementum=orci&pellentesque=luctus&quisque=et&porta=ultrices&volutpat=posuere&erat=cubilia&quisque=curae&erat=duis&eros=faucibus&viverra=accumsan&eget=odio&congue=curabitur',
        null,
        '2023-09-29T02:27:12Z',
        'Tune Town Publishing',
        1
    );

-- Add Playlist
insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '6369cce8-cc84-4128-955c-2853cd9dc8ac',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'Summer Jams',
        'https://smugmug.com/sem/mauris/laoreet/ut.html?sed=lectus&ante=pellentesque&vivamus=at&tortor=nulla&duis=suspendisse&mattis=potenti&egestas=cras&metus=in&aenean=purus&fermentum=eu&donec=magna&ut=vulputate&mauris=luctus&eget=cum&massa=sociis&tempor=natoque&convallis=penatibus&nulla=et&neque=magnis&libero=dis&convallis=parturient&eget=montes&eleifend=nascetur&luctus=ridiculus&ultricies=mus&eu=vivamus&nibh=vestibulum&quisque=sagittis&id=sapien&justo=cum&sit=sociis&amet=natoque&sapien=penatibus&dignissim=et&vestibulum=magnis&vestibulum=dis&ante=parturient&ipsum=montes&primis=nascetur&in=ridiculus&faucibus=mus&orci=etiam&luctus=vel&et=augue&ultrices=vestibulum&posuere=rutrum&cubilia=rutrum&curae=neque&nulla=aenean&dapibus=auctor&dolor=gravida&vel=sem&est=praesent&donec=id&odio=massa&justo=id&sollicitudin=nisl&ut=venenatis&suscipit=lacinia&a=aenean&feugiat=sit&et=amet&eros=justo&vestibulum=morbi&ac=ut&est=odio&lacinia=cras&nisi=mi&venenatis=pede&tristique=malesuada&fusce=in&congue=imperdiet&diam=et&id=commodo&ornare=vulputate&imperdiet=justo&sapien=in&urna=blandit&pretium=ultrices&nisl=enim&ut=lorem&volutpat=ipsum&sapien=dolor&arcu=sit&sed=amet&augue=consectetuer&aliquam=adipiscing&erat=elit&volutpat=proin'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'b818eaa7-061b-4ca2-bf75-9327d041469a',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'Road Trip Mix',
        'https://prweb.com/porttitor/lorem/id/ligula/suspendisse.js?vulputate=cum&nonummy=sociis&maecenas=natoque&tincidunt=penatibus&lacus=et&at=magnis&velit=dis&vivamus=parturient&vel=montes&nulla=nascetur&eget=ridiculus&eros=mus&elementum=etiam&pellentesque=vel&quisque=augue&porta=vestibulum&volutpat=rutrum&erat=rutrum&quisque=neque&erat=aenean&eros=auctor&viverra=gravida&eget=sem&congue=praesent&eget=id&semper=massa&rutrum=id&nulla=nisl&nunc=venenatis&purus=lacinia&phasellus=aenean&in=sit&felis=amet&donec=justo&semper=morbi&sapien=ut&a=odio&libero=cras&nam=mi&dui=pede&proin=malesuada&leo=in&odio=imperdiet&porttitor=et&id=commodo&consequat=vulputate&in=justo&consequat=in&ut=blandit&nulla=ultrices&sed=enim&accumsan=lorem&felis=ipsum&ut=dolor&at=sit&dolor=amet&quis=consectetuer&odio=adipiscing&consequat=elit&varius=proin&integer=interdum&ac=mauris&leo=non&pellentesque=ligula&ultrices=pellentesque&mattis=ultrices&odio=phasellus&donec=id&vitae=sapien&nisi=in&nam=sapien&ultrices=iaculis&libero=congue&non=vivamus&mattis=metus&pulvinar=arcu&nulla=adipiscing&pede=molestie&ullamcorper=hendrerit&augue=at&a=vulputate&suscipit=vitae&nulla=nisl&elit=aenean&ac=lectus&nulla=pellentesque'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'f71adb5f-d5f6-4832-ae30-c05cf581a5db',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        'Study Playlist',
        'https://home.pl/suscipit/a/feugiat/et/eros/vestibulum.jpg?nibh=diam&fusce=id&lacus=ornare&purus=imperdiet&aliquet=sapien&at=urna'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '5c66a99d-e47c-4627-a553-13c56bf7d39d',
        'u001',
        'Summer Jams',
        'https://harvard.edu/mi/nulla/ac/enim/in/tempor/turpis.png?morbi=fusce&odio=consequat&odio=nulla&elementum=nisl&eu=nunc&interdum=nisl&eu=duis&tincidunt=bibendum&in=felis&leo=sed&maecenas=interdum&pulvinar=venenatis&lobortis=turpis&est=enim&phasellus=blandit&sit=mi&amet=in&erat=porttitor&nulla=pede&tempus=justo&vivamus=eu&in=massa&felis=donec&eu=dapibus&sapien=duis&cursus=at&vestibulum=velit&proin=eu&eu=est&mi=congue&nulla=elementum&ac=in&enim=hac&in=habitasse&tempor=platea&turpis=dictumst&nec=morbi&euismod=vestibulum&scelerisque=velit&quam=id&turpis=pretium&adipiscing=iaculis&lorem=diam&vitae=erat&mattis=fermentum&nibh=justo&ligula=nec&nec=condimentum&sem=neque&duis=sapien&aliquam=placerat&convallis=ante&nunc=nulla&proin=justo&at=aliquam&turpis=quis&a=turpis&pede=eget&posuere=elit&nonummy=sodales&integer=scelerisque&non=mauris&velit=sit&donec=amet&diam=eros&neque=suspendisse&vestibulum=accumsan'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '553d06d5-3e6f-4acd-89d1-22ae247c67b7',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'Road Trip Mix',
        'http://behance.net/imperdiet/nullam/orci.js?sapien=vestibulum&a=sagittis&libero=sapien&nam=cum&dui=sociis&proin=natoque&leo=penatibus&odio=et&porttitor=magnis&id=dis&consequat=parturient&in=montes&consequat=nascetur&ut=ridiculus&nulla=mus&sed=etiam&accumsan=vel&felis=augue&ut=vestibulum&at=rutrum&dolor=rutrum&quis=neque&odio=aenean&consequat=auctor&varius=gravida&integer=sem&ac=praesent&leo=id&pellentesque=massa&ultrices=id&mattis=nisl&odio=venenatis&donec=lacinia&vitae=aenean&nisi=sit&nam=amet&ultrices=justo&libero=morbi&non=ut&mattis=odio&pulvinar=cras&nulla=mi&pede=pede&ullamcorper=malesuada&augue=in&a=imperdiet&suscipit=et&nulla=commodo&elit=vulputate&ac=justo&nulla=in&sed=blandit&vel=ultrices&enim=enim&sit=lorem&amet=ipsum&nunc=dolor&viverra=sit&dapibus=amet&nulla=consectetuer&suscipit=adipiscing&ligula=elit&in=proin&lacus=interdum&curabitur=mauris&at=non&ipsum=ligula&ac=pellentesque&tellus=ultrices&semper=phasellus&interdum=id&mauris=sapien&ullamcorper=in&purus=sapien&sit=iaculis&amet=congue&nulla=vivamus&quisque=metus&arcu=arcu&libero=adipiscing&rutrum=molestie&ac=hendrerit&lobortis=at&vel=vulputate&dapibus=vitae&at=nisl&diam=aenean&nam=lectus&tristique=pellentesque&tortor=eget&eu=nunc'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '3a07fca8-082d-4b93-bfdd-02030aff34c9',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'Acoustic Sessions',
        'https://twitpic.com/proin/risus/praesent/lectus/vestibulum/quam/sapien.jsp?ligula=cum&sit=sociis&amet=natoque&eleifend=penatibus&pede=et&libero=magnis&quis=dis&orci=parturient&nullam=montes&molestie=nascetur&nibh=ridiculus&in=mus&lectus=vivamus&pellentesque=vestibulum&at=sagittis&nulla=sapien&suspendisse=cum&potenti=sociis&cras=natoque&in=penatibus&purus=et&eu=magnis&magna=dis&vulputate=parturient&luctus=montes&cum=nascetur&sociis=ridiculus&natoque=mus&penatibus=etiam&et=vel&magnis=augue&dis=vestibulum&parturient=rutrum&montes=rutrum&nascetur=neque&ridiculus=aenean&mus=auctor&vivamus=gravida&vestibulum=sem&sagittis=praesent&sapien=id&cum=massa&sociis=id&natoque=nisl&penatibus=venenatis&et=lacinia&magnis=aenean&dis=sit&parturient=amet&montes=justo&nascetur=morbi&ridiculus=ut&mus=odio&etiam=cras&vel=mi'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '1d8f3f6c-00e4-4525-bbbb-fcacdb61596e',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        'Late Night Beats',
        'http://businessweek.com/consequat.jpg?sed=tincidunt&tincidunt=eu&eu=felis&felis=fusce&fusce=posuere&posuere=felis&felis=sed&sed=lacus&lacus=morbi&morbi=sem&sem=mauris&mauris=laoreet&laoreet=ut&ut=rhoncus&rhoncus=aliquet&aliquet=pulvinar&pulvinar=sed&sed=nisl&nisl=nunc&nunc=rhoncus&rhoncus=dui&dui=vel&vel=sem&sem=sed&sed=sagittis&sagittis=nam&nam=congue&congue=risus&risus=semper&semper=porta&porta=volutpat&volutpat=quam&quam=pede&pede=lobortis&lobortis=ligula&ligula=sit&sit=amet&amet=eleifend&eleifend=pede&pede=libero&libero=quis&quis=orci&orci=nullam&nullam=molestie&molestie=nibh&nibh=in&in=lectus&lectus=pellentesque&pellentesque=at&at=nulla&nulla=suspendisse'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '9454d1a0-1a33-49b6-9911-4f058aba2ae6',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'Throwback Hits',
        'http://samsung.com/nunc/rhoncus.xml?lacinia=venenatis&aenean=non&sit=sodales&amet=sed&justo=tincidunt&morbi=eu&ut=felis&odio=fusce&cras=posuere&mi=felis&pede=sed&malesuada=lacus'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '33d871e9-1d70-45a4-922b-0779a5892a0a',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'Summer Jams',
        'http://globo.com/diam/vitae.html?ultrices=nam&posuere=dui&cubilia=proin&curae=leo&mauris=odio&viverra=porttitor&diam=id&vitae=consequat&quam=in&suspendisse=consequat&potenti=ut&nullam=nulla&porttitor=sed&lacus=accumsan&at=felis&turpis=ut&donec=at&posuere=dolor&metus=quis'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '3a5ec5f8-2a3b-47f7-ad29-cdfdba4ae71f',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'Feel Good Tunes',
        'http://nydailynews.com/integer/aliquet/massa/id/lobortis.jsp?etiam=sed&pretium=augue&iaculis=aliquam&justo=erat&in=volutpat&hac=in&habitasse=congue&platea=etiam&dictumst=justo&etiam=etiam&faucibus=pretium&cursus=iaculis&urna=justo&ut=in&tellus=hac&nulla=habitasse&ut=platea&erat=dictumst&id=etiam&mauris=faucibus&vulputate=cursus&elementum=urna&nullam=ut&varius=tellus&nulla=nulla&facilisi=ut&cras=erat&non=id&velit=mauris&nec=vulputate&nisi=elementum&vulputate=nullam&nonummy=varius&maecenas=nulla&tincidunt=facilisi&lacus=cras&at=non&velit=velit&vivamus=nec&vel=nisi&nulla=vulputate&eget=nonummy&eros=maecenas&elementum=tincidunt&pellentesque=lacus&quisque=at&porta=velit&volutpat=vivamus&erat=vel&quisque=nulla&erat=eget&eros=eros&viverra=elementum&eget=pellentesque&congue=quisque&eget=porta&semper=volutpat&rutrum=erat&nulla=quisque&nunc=erat&purus=eros&phasellus=viverra&in=eget&felis=congue&donec=eget&semper=semper&sapien=rutrum&a=nulla&libero=nunc&nam=purus&dui=phasellus&proin=in&leo=felis&odio=donec&porttitor=semper&id=sapien&consequat=a&in=libero&consequat=nam&ut=dui&nulla=proin&sed=leo&accumsan=odio&felis=porttitor&ut=id&at=consequat&dolor=in&quis=consequat&odio=ut&consequat=nulla&varius=sed&integer=accumsan&ac=felis&leo=ut&pellentesque=at'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '634dfd22-c5ba-4be1-9866-3439092811a7',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'Feel Good Tunes',
        'http://wunderground.com/tincidunt.png?sed=amet&lacus=erat&morbi=nulla&sem=tempus&mauris=vivamus&laoreet=in&ut=felis&rhoncus=eu&aliquet=sapien&pulvinar=cursus&sed=vestibulum&nisl=proin&nunc=eu&rhoncus=mi&dui=nulla&vel=ac&sem=enim&sed=in&sagittis=tempor&nam=turpis&congue=nec&risus=euismod&semper=scelerisque&porta=quam&volutpat=turpis&quam=adipiscing&pede=lorem&lobortis=vitae&ligula=mattis&sit=nibh&amet=ligula&eleifend=nec&pede=sem&libero=duis&quis=aliquam&orci=convallis&nullam=nunc&molestie=proin&nibh=at&in=turpis&lectus=a&pellentesque=pede&at=posuere&nulla=nonummy&suspendisse=integer&potenti=non'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '300f01c5-4540-4821-ac1f-822aeea0b35a',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'Summer Jams',
        'http://google.co.jp/rutrum.jpg?ornare=ipsum&consequat=integer&lectus=a&in=nibh&est=in&risus=quis&auctor=justo&sed=maecenas&tristique=rhoncus&in=aliquam&tempus=lacus&sit=morbi&amet=quis&sem=tortor&fusce=id&consequat=nulla&nulla=ultrices&nisl=aliquet&nunc=maecenas&nisl=leo&duis=odio&bibendum=condimentum&felis=id&sed=luctus&interdum=nec&venenatis=molestie&turpis=sed&enim=justo&blandit=pellentesque&mi=viverra&in=pede&porttitor=ac&pede=diam&justo=cras&eu=pellentesque&massa=volutpat&donec=dui&dapibus=maecenas&duis=tristique&at=est&velit=et&eu=tempus&est=semper&congue=est&elementum=quam&in=pharetra&hac=magna&habitasse=ac&platea=consequat&dictumst=metus&morbi=sapien&vestibulum=ut&velit=nunc&id=vestibulum&pretium=ante&iaculis=ipsum&diam=primis&erat=in&fermentum=faucibus&justo=orci&nec=luctus&condimentum=et&neque=ultrices&sapien=posuere&placerat=cubilia&ante=curae&nulla=mauris&justo=viverra&aliquam=diam&quis=vitae&turpis=quam&eget=suspendisse&elit=potenti&sodales=nullam&scelerisque=porttitor&mauris=lacus&sit=at&amet=turpis&eros=donec&suspendisse=posuere&accumsan=metus&tortor=vitae&quis=ipsum&turpis=aliquam&sed=non&ante=mauris&vivamus=morbi&tortor=non&duis=lectus&mattis=aliquam&egestas=sit&metus=amet&aenean=diam&fermentum=in&donec=magna&ut=bibendum&mauris=imperdiet&eget=nullam'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '8266b4c2-322a-406c-be84-44fd9629d542',
        '5beae775-0838-4778-8853-7f41275c0e37',
        'Throwback Hits',
        'https://ask.com/ligula/sit/amet/eleifend/pede.xml?vel=blandit&ipsum=mi&praesent=in&blandit=porttitor&lacinia=pede&erat=justo&vestibulum=eu&sed=massa&magna=donec&at=dapibus&nunc=duis&commodo=at&placerat=velit&praesent=eu&blandit=est&nam=congue&nulla=elementum&integer=in&pede=hac&justo=habitasse&lacinia=platea&eget=dictumst&tincidunt=morbi&eget=vestibulum&tempus=velit&vel=id&pede=pretium&morbi=iaculis&porttitor=diam&lorem=erat&id=fermentum&ligula=justo&suspendisse=nec&ornare=condimentum&consequat=neque&lectus=sapien&in=placerat&est=ante&risus=nulla&auctor=justo&sed=aliquam&tristique=quis&in=turpis&tempus=eget&sit=elit&amet=sodales&sem=scelerisque&fusce=mauris&consequat=sit&nulla=amet&nisl=eros&nunc=suspendisse'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'e4019cfe-896c-499d-8447-276127357fed',
        'u005',
        'Summer Jams',
        'http://ucoz.ru/vitae/nisi/nam/ultrices/libero.aspx?at=pellentesque&lorem=at&integer=nulla&tincidunt=suspendisse&ante=potenti&vel=cras&ipsum=in&praesent=purus&blandit=eu&lacinia=magna&erat=vulputate&vestibulum=luctus&sed=cum&magna=sociis&at=natoque&nunc=penatibus&commodo=et&placerat=magnis&praesent=dis&blandit=parturient&nam=montes&nulla=nascetur&integer=ridiculus&pede=mus&justo=vivamus&lacinia=vestibulum&eget=sagittis&tincidunt=sapien&eget=cum&tempus=sociis&vel=natoque&pede=penatibus&morbi=et&porttitor=magnis&lorem=dis&id=parturient&ligula=montes&suspendisse=nascetur&ornare=ridiculus&consequat=mus&lectus=etiam&in=vel&est=augue&risus=vestibulum&auctor=rutrum&sed=rutrum&tristique=neque&in=aenean&tempus=auctor&sit=gravida&amet=sem&sem=praesent&fusce=id&consequat=massa&nulla=id&nisl=nisl&nunc=venenatis&nisl=lacinia&duis=aenean&bibendum=sit&felis=amet&sed=justo&interdum=morbi&venenatis=ut&turpis=odio&enim=cras&blandit=mi&mi=pede&in=malesuada&porttitor=in&pede=imperdiet&justo=et&eu=commodo&massa=vulputate&donec=justo&dapibus=in&duis=blandit&at=ultrices&velit=enim&eu=lorem&est=ipsum&congue=dolor&elementum=sit'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'a3dc1f03-a3a2-4e80-8575-be7777d47ae3',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        'Late Night Beats',
        'https://e-recht24.de/tortor.xml?nunc=quis&purus=justo&phasellus=maecenas&in=rhoncus&felis=aliquam&donec=lacus&semper=morbi&sapien=quis&a=tortor&libero=id&nam=nulla&dui=ultrices&proin=aliquet&leo=maecenas&odio=leo&porttitor=odio&id=condimentum&consequat=id&in=luctus'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '9076373f-cc04-4b94-a1a1-8609c0383c49',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'Study Playlist',
        'http://apache.org/nisl/duis/bibendum.png?sapien=quam&varius=sapien&ut=varius&blandit=ut&non=blandit&interdum=non&in=interdum&ante=in&vestibulum=ante&ante=vestibulum&ipsum=ante&primis=ipsum&in=primis&faucibus=in&orci=faucibus&luctus=orci&et=luctus&ultrices=et&posuere=ultrices&cubilia=posuere&curae=cubilia&duis=curae&faucibus=duis&accumsan=faucibus&odio=accumsan&curabitur=odio'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '2f011a8a-18d2-46c5-b9b9-3ca212848512',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'Summer Jams',
        'http://dyndns.org/faucibus.html?pede=gravida&venenatis=sem&non=praesent&sodales=id&sed=massa&tincidunt=id&eu=nisl&felis=venenatis&fusce=lacinia&posuere=aenean&felis=sit&sed=amet&lacus=justo&morbi=morbi&sem=ut&mauris=odio&laoreet=cras&ut=mi&rhoncus=pede&aliquet=malesuada&pulvinar=in&sed=imperdiet&nisl=et&nunc=commodo&rhoncus=vulputate&dui=justo&vel=in&sem=blandit&sed=ultrices&sagittis=enim&nam=lorem&congue=ipsum&risus=dolor&semper=sit&porta=amet&volutpat=consectetuer&quam=adipiscing&pede=elit&lobortis=proin&ligula=interdum&sit=mauris&amet=non&eleifend=ligula&pede=pellentesque&libero=ultrices&quis=phasellus'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '53f923ba-994b-46bc-9d8d-935dbfe0acae',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'Feel Good Tunes',
        'http://sakura.ne.jp/pede/morbi/porttitor/lorem/id/ligula/suspendisse.aspx?rhoncus=consequat&aliquet=metus&pulvinar=sapien&sed=ut&nisl=nunc&nunc=vestibulum&rhoncus=ante&dui=ipsum&vel=primis&sem=in&sed=faucibus&sagittis=orci&nam=luctus&congue=et&risus=ultrices&semper=posuere&porta=cubilia'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'fa1b5c64-d1cf-4cfe-9ee1-6f991b64005e',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        'Chill Vibes',
        'http://shareasale.com/sollicitudin/vitae/consectetuer/eget/rutrum/at.html?adipiscing=molestie&elit=sed&proin=justo&interdum=pellentesque&mauris=viverra&non=pede&ligula=ac&pellentesque=diam&ultrices=cras&phasellus=pellentesque&id=volutpat&sapien=dui&in=maecenas&sapien=tristique'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'e9cbcdb5-6553-4a08-90bf-5484efa492ae',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        'Road Trip Mix',
        'http://reuters.com/nec.html?bibendum=blandit&morbi=ultrices&non=enim&quam=lorem&nec=ipsum&dui=dolor&luctus=sit&rutrum=amet&nulla=consectetuer&tellus=adipiscing&in=elit&sagittis=proin&dui=interdum&vel=mauris&nisl=non&duis=ligula&ac=pellentesque&nibh=ultrices&fusce=phasellus&lacus=id&purus=sapien&aliquet=in&at=sapien&feugiat=iaculis&non=congue&pretium=vivamus&quis=metus&lectus=arcu&suspendisse=adipiscing&potenti=molestie&in=hendrerit&eleifend=at&quam=vulputate&a=vitae&odio=nisl&in=aenean&hac=lectus&habitasse=pellentesque&platea=eget&dictumst=nunc&maecenas=donec&ut=quis&massa=orci&quis=eget&augue=orci&luctus=vehicula&tincidunt=condimentum&nulla=curabitur&mollis=in&molestie=libero&lorem=ut&quisque=massa&ut=volutpat&erat=convallis&curabitur=morbi&gravida=odio&nisi=odio&at=elementum&nibh=eu&in=interdum&hac=eu&habitasse=tincidunt&platea=in&dictumst=leo&aliquam=maecenas&augue=pulvinar&quam=lobortis&sollicitudin=est&vitae=phasellus'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '664c3c53-998e-4266-a061-42feb903aef3',
        'u005',
        'Feel Good Tunes',
        'http://ezinearticles.com/duis/bibendum/felis/sed/interdum.jsp?enim=curabitur&blandit=convallis&mi=duis&in=consequat&porttitor=dui&pede=nec&justo=nisi&eu=volutpat&massa=eleifend&donec=donec&dapibus=ut&duis=dolor&at=morbi&velit=vel&eu=lectus&est=in&congue=quam&elementum=fringilla&in=rhoncus&hac=mauris&habitasse=enim&platea=leo'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '9f8a699b-bc69-422c-8ae9-47d023e00b55',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'Road Trip Mix',
        'https://cbslocal.com/malesuada.jpg?mi=habitasse&integer=platea&ac=dictumst&neque=morbi&duis=vestibulum&bibendum=velit&morbi=id&non=pretium&quam=iaculis&nec=diam&dui=erat&luctus=fermentum&rutrum=justo&nulla=nec&tellus=condimentum&in=neque&sagittis=sapien&dui=placerat&vel=ante&nisl=nulla&duis=justo&ac=aliquam&nibh=quis&fusce=turpis&lacus=eget&purus=elit&aliquet=sodales&at=scelerisque&feugiat=mauris&non=sit&pretium=amet&quis=eros&lectus=suspendisse&suspendisse=accumsan&potenti=tortor&in=quis&eleifend=turpis&quam=sed&a=ante&odio=vivamus&in=tortor&hac=duis&habitasse=mattis'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'a709f789-cb1e-4938-8b2a-9b9aa13e7f13',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'Road Trip Mix',
        'https://symantec.com/at/nulla/suspendisse/potenti.aspx?eleifend=eget&pede=tempus&libero=vel&quis=pede&orci=morbi&nullam=porttitor&molestie=lorem&nibh=id&in=ligula&lectus=suspendisse&pellentesque=ornare&at=consequat&nulla=lectus&suspendisse=in'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '08469e91-2111-4d78-bb44-009ec5f9d98d',
        'u004',
        'Throwback Hits',
        'https://joomla.org/blandit/non/interdum/in/ante/vestibulum.json?justo=ut&in=massa&hac=volutpat&habitasse=convallis&platea=morbi&dictumst=odio&etiam=odio&faucibus=elementum&cursus=eu&urna=interdum&ut=eu&tellus=tincidunt&nulla=in&ut=leo&erat=maecenas&id=pulvinar&mauris=lobortis&vulputate=est&elementum=phasellus&nullam=sit&varius=amet&nulla=erat&facilisi=nulla&cras=tempus&non=vivamus&velit=in&nec=felis&nisi=eu&vulputate=sapien&nonummy=cursus'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '7dc2540b-8a6b-480b-8fa1-720b044cd53e',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        'Workout Pump-Up',
        'http://twitpic.com/montes/nascetur/ridiculus.jpg?rutrum=euismod&rutrum=scelerisque&neque=quam&aenean=turpis&auctor=adipiscing&gravida=lorem&sem=vitae&praesent=mattis&id=nibh&massa=ligula&id=nec&nisl=sem&venenatis=duis&lacinia=aliquam&aenean=convallis&sit=nunc&amet=proin&justo=at&morbi=turpis&ut=a&odio=pede&cras=posuere&mi=nonummy&pede=integer&malesuada=non&in=velit&imperdiet=donec&et=diam&commodo=neque&vulputate=vestibulum&justo=eget&in=vulputate&blandit=ut&ultrices=ultrices&enim=vel&lorem=augue&ipsum=vestibulum&dolor=ante&sit=ipsum&amet=primis&consectetuer=in&adipiscing=faucibus&elit=orci&proin=luctus&interdum=et&mauris=ultrices&non=posuere&ligula=cubilia&pellentesque=curae&ultrices=donec&phasellus=pharetra&id=magna&sapien=vestibulum&in=aliquet&sapien=ultrices&iaculis=erat&congue=tortor&vivamus=sollicitudin&metus=mi&arcu=sit&adipiscing=amet&molestie=lobortis&hendrerit=sapien&at=sapien&vulputate=non&vitae=mi&nisl=integer&aenean=ac&lectus=neque&pellentesque=duis&eget=bibendum&nunc=morbi&donec=non&quis=quam&orci=nec&eget=dui&orci=luctus&vehicula=rutrum&condimentum=nulla&curabitur=tellus&in=in&libero=sagittis&ut=dui&massa=vel&volutpat=nisl&convallis=duis&morbi=ac&odio=nibh&odio=fusce&elementum=lacus'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '2e85ff9c-39ee-4aa5-8448-ecdf60b9ad43',
        'u007',
        'Throwback Hits',
        'https://wikispaces.com/ante/nulla/justo/aliquam/quis/turpis/eget.json?turpis=nam&elementum=congue'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'f3b95c7c-e5b2-431b-8280-a600847902b2',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'Study Playlist',
        'https://ebay.co.uk/eu/interdum/eu/tincidunt/in/leo/maecenas.aspx?sapien=nullam&a=varius&libero=nulla&nam=facilisi&dui=cras&proin=non&leo=velit&odio=nec&porttitor=nisi&id=vulputate&consequat=nonummy&in=maecenas&consequat=tincidunt&ut=lacus&nulla=at&sed=velit&accumsan=vivamus&felis=vel&ut=nulla&at=eget&dolor=eros'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'fc3fe39c-ec0c-4848-a57c-402cb09c2b98',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'Throwback Hits',
        'http://mtv.com/aliquam/lacus.xml?iaculis=quisque&justo=arcu&in=libero&hac=rutrum&habitasse=ac&platea=lobortis&dictumst=vel&etiam=dapibus&faucibus=at&cursus=diam&urna=nam&ut=tristique&tellus=tortor'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '2d085267-3b30-4bee-8736-1da2a7ebe0fc',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'Workout Pump-Up',
        'http://wp.com/lectus/in/est/risus/auctor.js?ut=sapien&massa=quis&volutpat=libero&convallis=nullam&morbi=sit&odio=amet&odio=turpis&elementum=elementum&eu=ligula&interdum=vehicula&eu=consequat&tincidunt=morbi&in=a&leo=ipsum&maecenas=integer&pulvinar=a&lobortis=nibh&est=in&phasellus=quis&sit=justo&amet=maecenas&erat=rhoncus&nulla=aliquam&tempus=lacus&vivamus=morbi&in=quis&felis=tortor&eu=id&sapien=nulla&cursus=ultrices&vestibulum=aliquet&proin=maecenas&eu=leo&mi=odio&nulla=condimentum&ac=id&enim=luctus&in=nec&tempor=molestie&turpis=sed&nec=justo&euismod=pellentesque&scelerisque=viverra&quam=pede&turpis=ac&adipiscing=diam&lorem=cras&vitae=pellentesque&mattis=volutpat'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'eb3e4bbd-4ba1-41a0-a88b-ae390af686c4',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        'Throwback Hits',
        'https://weebly.com/at/feugiat/non/pretium.js?faucibus=nec&accumsan=dui&odio=luctus&curabitur=rutrum&convallis=nulla&duis=tellus&consequat=in&dui=sagittis&nec=dui&nisi=vel&volutpat=nisl&eleifend=duis&donec=ac&ut=nibh&dolor=fusce&morbi=lacus&vel=purus&lectus=aliquet&in=at&quam=feugiat&fringilla=non&rhoncus=pretium&mauris=quis&enim=lectus&leo=suspendisse&rhoncus=potenti&sed=in&vestibulum=eleifend&sit=quam&amet=a&cursus=odio&id=in&turpis=hac&integer=habitasse&aliquet=platea&massa=dictumst&id=maecenas&lobortis=ut&convallis=massa&tortor=quis&risus=augue&dapibus=luctus&augue=tincidunt&vel=nulla&accumsan=mollis&tellus=molestie&nisi=lorem&eu=quisque&orci=ut&mauris=erat&lacinia=curabitur&sapien=gravida&quis=nisi&libero=at&nullam=nibh&sit=in&amet=hac&turpis=habitasse&elementum=platea&ligula=dictumst&vehicula=aliquam&consequat=augue&morbi=quam&a=sollicitudin&ipsum=vitae'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'b33449e4-fdde-4a1e-a5b0-47d6f7b638c8',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        'Late Night Beats',
        'http://washington.edu/a/libero/nam/dui/proin/leo.jpg?pellentesque=duis&ultrices=faucibus&mattis=accumsan&odio=odio&donec=curabitur&vitae=convallis&nisi=duis&nam=consequat&ultrices=dui&libero=nec&non=nisi&mattis=volutpat&pulvinar=eleifend&nulla=donec&pede=ut&ullamcorper=dolor&augue=morbi&a=vel&suscipit=lectus&nulla=in&elit=quam&ac=fringilla&nulla=rhoncus&sed=mauris&vel=enim&enim=leo&sit=rhoncus&amet=sed&nunc=vestibulum&viverra=sit&dapibus=amet&nulla=cursus&suscipit=id&ligula=turpis&in=integer&lacus=aliquet&curabitur=massa&at=id&ipsum=lobortis&ac=convallis&tellus=tortor&semper=risus&interdum=dapibus'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '1b99b3b1-d300-43f5-969b-dc77cd16eb34',
        'u004',
        'Study Playlist',
        'http://about.me/eros.xml?donec=eros&ut=viverra&mauris=eget&eget=congue&massa=eget&tempor=semper&convallis=rutrum&nulla=nulla&neque=nunc&libero=purus&convallis=phasellus&eget=in&eleifend=felis&luctus=donec&ultricies=semper&eu=sapien&nibh=a&quisque=libero&id=nam&justo=dui'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'a08a16e8-9c6c-45e6-abc1-6ac5be471d4c',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'Late Night Beats',
        'http://ask.com/et/magnis.jpg?pede=non&malesuada=velit&in=nec&imperdiet=nisi&et=vulputate&commodo=nonummy&vulputate=maecenas&justo=tincidunt&in=lacus&blandit=at&ultrices=velit&enim=vivamus&lorem=vel&ipsum=nulla&dolor=eget&sit=eros&amet=elementum&consectetuer=pellentesque&adipiscing=quisque&elit=porta&proin=volutpat&interdum=erat&mauris=quisque&non=erat&ligula=eros&pellentesque=viverra&ultrices=eget&phasellus=congue&id=eget&sapien=semper&in=rutrum&sapien=nulla&iaculis=nunc&congue=purus&vivamus=phasellus&metus=in&arcu=felis&adipiscing=donec&molestie=semper&hendrerit=sapien&at=a&vulputate=libero&vitae=nam&nisl=dui&aenean=proin&lectus=leo&pellentesque=odio&eget=porttitor&nunc=id&donec=consequat&quis=in&orci=consequat&eget=ut&orci=nulla&vehicula=sed&condimentum=accumsan&curabitur=felis&in=ut&libero=at&ut=dolor&massa=quis&volutpat=odio&convallis=consequat&morbi=varius&odio=integer&odio=ac&elementum=leo&eu=pellentesque&interdum=ultrices&eu=mattis&tincidunt=odio&in=donec&leo=vitae&maecenas=nisi'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '667b994d-57ee-4cd3-9670-376beb1cda04',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'Road Trip Mix',
        'https://homestead.com/amet/cursus/id/turpis/integer/aliquet/massa.html?est=volutpat&donec=convallis&odio=morbi&justo=odio&sollicitudin=odio&ut=elementum&suscipit=eu&a=interdum&feugiat=eu&et=tincidunt&eros=in&vestibulum=leo&ac=maecenas&est=pulvinar&lacinia=lobortis&nisi=est&venenatis=phasellus&tristique=sit&fusce=amet&congue=erat&diam=nulla&id=tempus&ornare=vivamus&imperdiet=in&sapien=felis&urna=eu&pretium=sapien&nisl=cursus&ut=vestibulum&volutpat=proin&sapien=eu&arcu=mi&sed=nulla&augue=ac&aliquam=enim&erat=in&volutpat=tempor&in=turpis&congue=nec&etiam=euismod&justo=scelerisque&etiam=quam&pretium=turpis&iaculis=adipiscing&justo=lorem&in=vitae&hac=mattis&habitasse=nibh&platea=ligula&dictumst=nec&etiam=sem&faucibus=duis&cursus=aliquam&urna=convallis'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '39bdfe8a-1111-40a1-856b-890ec1451342',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'Dance Party Anthems',
        'http://e-recht24.de/duis/bibendum/felis/sed/interdum.json?condimentum=habitasse&neque=platea&sapien=dictumst&placerat=aliquam&ante=augue&nulla=quam&justo=sollicitudin&aliquam=vitae&quis=consectetuer&turpis=eget&eget=rutrum&elit=at&sodales=lorem&scelerisque=integer&mauris=tincidunt&sit=ante&amet=vel&eros=ipsum&suspendisse=praesent&accumsan=blandit&tortor=lacinia&quis=erat&turpis=vestibulum&sed=sed&ante=magna'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'b08b646c-dac3-4de1-8cd8-bc0d28294db1',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'Chill Vibes',
        'http://unblog.fr/non/ligula/pellentesque.png?mattis=ipsum&pulvinar=primis&nulla=in&pede=faucibus&ullamcorper=orci&augue=luctus&a=et&suscipit=ultrices&nulla=posuere&elit=cubilia&ac=curae&nulla=donec&sed=pharetra&vel=magna&enim=vestibulum&sit=aliquet&amet=ultrices&nunc=erat'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '99f8d664-7620-4052-ac85-ef4f30bb924b',
        'u006',
        'Acoustic Sessions',
        'http://squidoo.com/montes.jsp?erat=donec&quisque=quis&erat=orci&eros=eget&viverra=orci&eget=vehicula&congue=condimentum&eget=curabitur&semper=in&rutrum=libero&nulla=ut&nunc=massa&purus=volutpat&phasellus=convallis&in=morbi&felis=odio&donec=odio&semper=elementum&sapien=eu&a=interdum&libero=eu&nam=tincidunt&dui=in&proin=leo&leo=maecenas&odio=pulvinar&porttitor=lobortis&id=est&consequat=phasellus&in=sit&consequat=amet&ut=erat&nulla=nulla&sed=tempus&accumsan=vivamus&felis=in&ut=felis&at=eu&dolor=sapien&quis=cursus&odio=vestibulum&consequat=proin&varius=eu&integer=mi&ac=nulla&leo=ac&pellentesque=enim&ultrices=in&mattis=tempor&odio=turpis&donec=nec&vitae=euismod&nisi=scelerisque&nam=quam&ultrices=turpis&libero=adipiscing&non=lorem&mattis=vitae&pulvinar=mattis&nulla=nibh&pede=ligula&ullamcorper=nec&augue=sem&a=duis&suscipit=aliquam&nulla=convallis&elit=nunc&ac=proin&nulla=at&sed=turpis&vel=a&enim=pede&sit=posuere&amet=nonummy&nunc=integer&viverra=non&dapibus=velit&nulla=donec&suscipit=diam&ligula=neque&in=vestibulum&lacus=eget&curabitur=vulputate&at=ut&ipsum=ultrices&ac=vel&tellus=augue&semper=vestibulum&interdum=ante&mauris=ipsum&ullamcorper=primis&purus=in&sit=faucibus&amet=orci&nulla=luctus&quisque=et&arcu=ultrices&libero=posuere'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '014ecf8f-baf1-4b75-9719-f554c2f46682',
        'u004',
        'Feel Good Tunes',
        'https://jimdo.com/nibh/fusce/lacus.json?sapien=dui&sapien=maecenas&non=tristique&mi=est&integer=et&ac=tempus&neque=semper&duis=est&bibendum=quam&morbi=pharetra&non=magna&quam=ac'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '7c90cbf3-d6fd-4b44-9e16-82e0e4308f58',
        'u006',
        'Road Trip Mix',
        'http://fc2.com/ante/ipsum.xml?augue=ut&vestibulum=nunc&rutrum=vestibulum&rutrum=ante&neque=ipsum&aenean=primis&auctor=in&gravida=faucibus&sem=orci&praesent=luctus&id=et&massa=ultrices&id=posuere&nisl=cubilia&venenatis=curae&lacinia=mauris'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'ebe3aa59-1d3c-4724-9f63-c92401872911',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'Workout Pump-Up',
        'http://tripod.com/at/vulputate/vitae/nisl.jpg?at=orci&nulla=pede&suspendisse=venenatis&potenti=non&cras=sodales&in=sed&purus=tincidunt&eu=eu&magna=felis&vulputate=fusce&luctus=posuere&cum=felis&sociis=sed&natoque=lacus&penatibus=morbi&et=sem&magnis=mauris&dis=laoreet&parturient=ut&montes=rhoncus&nascetur=aliquet&ridiculus=pulvinar&mus=sed&vivamus=nisl&vestibulum=nunc&sagittis=rhoncus&sapien=dui&cum=vel&sociis=sem&natoque=sed&penatibus=sagittis&et=nam&magnis=congue&dis=risus&parturient=semper&montes=porta&nascetur=volutpat&ridiculus=quam&mus=pede&etiam=lobortis&vel=ligula&augue=sit&vestibulum=amet&rutrum=eleifend&rutrum=pede&neque=libero&aenean=quis&auctor=orci&gravida=nullam&sem=molestie&praesent=nibh&id=in&massa=lectus&id=pellentesque'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '73506061-0179-4667-89a4-3dce62a1d4e6',
        'a1943068-54de-433b-9281-cc8f239039df',
        'Acoustic Sessions',
        'https://ebay.co.uk/ante/vivamus/tortor/duis.json?lobortis=vestibulum&ligula=eget&sit=vulputate&amet=ut&eleifend=ultrices&pede=vel&libero=augue&quis=vestibulum&orci=ante&nullam=ipsum&molestie=primis&nibh=in&in=faucibus&lectus=orci&pellentesque=luctus&at=et&nulla=ultrices&suspendisse=posuere&potenti=cubilia&cras=curae&in=donec&purus=pharetra&eu=magna&magna=vestibulum&vulputate=aliquet&luctus=ultrices&cum=erat&sociis=tortor&natoque=sollicitudin&penatibus=mi&et=sit&magnis=amet&dis=lobortis&parturient=sapien&montes=sapien&nascetur=non&ridiculus=mi&mus=integer&vivamus=ac&vestibulum=neque&sagittis=duis&sapien=bibendum&cum=morbi&sociis=non&natoque=quam&penatibus=nec&et=dui&magnis=luctus&dis=rutrum&parturient=nulla&montes=tellus&nascetur=in&ridiculus=sagittis&mus=dui&etiam=vel&vel=nisl&augue=duis&vestibulum=ac&rutrum=nibh&rutrum=fusce&neque=lacus&aenean=purus&auctor=aliquet&gravida=at&sem=feugiat&praesent=non&id=pretium&massa=quis&id=lectus&nisl=suspendisse&venenatis=potenti&lacinia=in&aenean=eleifend&sit=quam&amet=a&justo=odio&morbi=in&ut=hac&odio=habitasse&cras=platea&mi=dictumst&pede=maecenas'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '748899b9-d23d-4c3c-8edf-32eebff121bb',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'Feel Good Tunes',
        'https://domainmarket.com/posuere/cubilia/curae/nulla.html?vel=pellentesque&accumsan=at&tellus=nulla&nisi=suspendisse&eu=potenti&orci=cras&mauris=in&lacinia=purus&sapien=eu&quis=magna&libero=vulputate&nullam=luctus&sit=cum&amet=sociis&turpis=natoque&elementum=penatibus&ligula=et&vehicula=magnis&consequat=dis&morbi=parturient&a=montes&ipsum=nascetur&integer=ridiculus&a=mus&nibh=vivamus&in=vestibulum&quis=sagittis&justo=sapien&maecenas=cum&rhoncus=sociis&aliquam=natoque&lacus=penatibus&morbi=et&quis=magnis&tortor=dis&id=parturient&nulla=montes&ultrices=nascetur&aliquet=ridiculus&maecenas=mus&leo=etiam&odio=vel&condimentum=augue&id=vestibulum&luctus=rutrum&nec=rutrum&molestie=neque&sed=aenean&justo=auctor&pellentesque=gravida&viverra=sem'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '005cc2e7-7f07-4a82-95e8-537d4d3d16d8',
        'u002',
        'Throwback Hits',
        'http://jalbum.net/amet/consectetuer/adipiscing/elit.aspx?nibh=tristique&ligula=in&nec=tempus&sem=sit&duis=amet&aliquam=sem&convallis=fusce&nunc=consequat&proin=nulla&at=nisl&turpis=nunc&a=nisl&pede=duis&posuere=bibendum'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'e27f6630-a6f2-42f5-9b50-89ab7cbe28c7',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'Road Trip Mix',
        'https://mapquest.com/vestibulum/sagittis/sapien.jpg?ultrices=mattis&phasellus=pulvinar&id=nulla&sapien=pede&in=ullamcorper&sapien=augue&iaculis=a&congue=suscipit&vivamus=nulla&metus=elit&arcu=ac&adipiscing=nulla&molestie=sed&hendrerit=vel&at=enim'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '1c3df42b-d3ee-4a07-a659-b96eb7e7aacd',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'Summer Jams',
        'https://telegraph.co.uk/sit.json?pulvinar=blandit&sed=nam&nisl=nulla&nunc=integer&rhoncus=pede&dui=justo&vel=lacinia&sem=eget&sed=tincidunt&sagittis=eget&nam=tempus&congue=vel&risus=pede&semper=morbi&porta=porttitor&volutpat=lorem&quam=id&pede=ligula&lobortis=suspendisse&ligula=ornare&sit=consequat&amet=lectus&eleifend=in&pede=est&libero=risus&quis=auctor&orci=sed&nullam=tristique&molestie=in&nibh=tempus&in=sit&lectus=amet&pellentesque=sem&at=fusce&nulla=consequat&suspendisse=nulla&potenti=nisl&cras=nunc&in=nisl&purus=duis&eu=bibendum&magna=felis&vulputate=sed&luctus=interdum&cum=venenatis&sociis=turpis&natoque=enim&penatibus=blandit&et=mi&magnis=in&dis=porttitor&parturient=pede&montes=justo&nascetur=eu&ridiculus=massa&mus=donec&vivamus=dapibus&vestibulum=duis&sagittis=at&sapien=velit&cum=eu&sociis=est&natoque=congue&penatibus=elementum&et=in&magnis=hac&dis=habitasse&parturient=platea&montes=dictumst&nascetur=morbi&ridiculus=vestibulum&mus=velit&etiam=id&vel=pretium&augue=iaculis&vestibulum=diam&rutrum=erat&rutrum=fermentum&neque=justo&aenean=nec&auctor=condimentum&gravida=neque&sem=sapien&praesent=placerat&id=ante&massa=nulla&id=justo&nisl=aliquam&venenatis=quis&lacinia=turpis'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '93a9a752-8654-4bee-9e36-86ddfd0fa8fa',
        'u003',
        'Throwback Hits',
        'http://eventbrite.com/tincidunt/in/leo/maecenas/pulvinar/lobortis/est.xml?tincidunt=magna&lacus=vestibulum&at=aliquet&velit=ultrices&vivamus=erat&vel=tortor&nulla=sollicitudin&eget=mi&eros=sit&elementum=amet&pellentesque=lobortis&quisque=sapien&porta=sapien&volutpat=non&erat=mi&quisque=integer&erat=ac&eros=neque&viverra=duis&eget=bibendum&congue=morbi&eget=non&semper=quam&rutrum=nec&nulla=dui&nunc=luctus&purus=rutrum&phasellus=nulla&in=tellus&felis=in&donec=sagittis&semper=dui&sapien=vel&a=nisl&libero=duis&nam=ac'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '3b28a0af-4f90-4d2a-8eb4-f4b21e7baae6',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'Workout Pump-Up',
        'http://lulu.com/imperdiet/sapien/urna/pretium/nisl.aspx?aliquam=porttitor&convallis=lorem&nunc=id&proin=ligula&at=suspendisse&turpis=ornare&a=consequat&pede=lectus&posuere=in&nonummy=est&integer=risus&non=auctor&velit=sed&donec=tristique&diam=in&neque=tempus&vestibulum=sit&eget=amet&vulputate=sem&ut=fusce&ultrices=consequat&vel=nulla&augue=nisl&vestibulum=nunc&ante=nisl&ipsum=duis&primis=bibendum&in=felis&faucibus=sed&orci=interdum&luctus=venenatis&et=turpis&ultrices=enim&posuere=blandit&cubilia=mi&curae=in&donec=porttitor&pharetra=pede&magna=justo&vestibulum=eu&aliquet=massa&ultrices=donec&erat=dapibus&tortor=duis&sollicitudin=at&mi=velit&sit=eu&amet=est&lobortis=congue&sapien=elementum&sapien=in&non=hac&mi=habitasse&integer=platea&ac=dictumst&neque=morbi&duis=vestibulum&bibendum=velit&morbi=id&non=pretium&quam=iaculis&nec=diam&dui=erat&luctus=fermentum&rutrum=justo&nulla=nec&tellus=condimentum&in=neque&sagittis=sapien&dui=placerat&vel=ante&nisl=nulla&duis=justo&ac=aliquam&nibh=quis'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '349f0766-40a5-4976-b73e-cbf647d9a526',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        'Workout Pump-Up',
        'https://symantec.com/ligula/nec.xml?vitae=dapibus&quam=augue&suspendisse=vel&potenti=accumsan&nullam=tellus&porttitor=nisi&lacus=eu&at=orci&turpis=mauris&donec=lacinia&posuere=sapien&metus=quis&vitae=libero&ipsum=nullam&aliquam=sit&non=amet&mauris=turpis&morbi=elementum&non=ligula&lectus=vehicula&aliquam=consequat&sit=morbi&amet=a&diam=ipsum&in=integer&magna=a&bibendum=nibh&imperdiet=in&nullam=quis&orci=justo&pede=maecenas&venenatis=rhoncus&non=aliquam&sodales=lacus&sed=morbi&tincidunt=quis&eu=tortor&felis=id&fusce=nulla&posuere=ultrices&felis=aliquet&sed=maecenas&lacus=leo&morbi=odio&sem=condimentum&mauris=id&laoreet=luctus&ut=nec&rhoncus=molestie&aliquet=sed&pulvinar=justo&sed=pellentesque&nisl=viverra&nunc=pede&rhoncus=ac&dui=diam&vel=cras&sem=pellentesque&sed=volutpat&sagittis=dui&nam=maecenas&congue=tristique&risus=est&semper=et&porta=tempus&volutpat=semper&quam=est'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        '3541b407-3820-4755-b6f2-f7d8956e098a',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'Summer Jams',
        'http://gravatar.com/in/imperdiet/et/commodo/vulputate/justo/in.html?integer=pellentesque&a=ultrices&nibh=phasellus&in=id&quis=sapien&justo=in&maecenas=sapien&rhoncus=iaculis&aliquam=congue&lacus=vivamus&morbi=metus&quis=arcu&tortor=adipiscing&id=molestie&nulla=hendrerit&ultrices=at&aliquet=vulputate&maecenas=vitae&leo=nisl&odio=aenean&condimentum=lectus&id=pellentesque&luctus=eget&nec=nunc&molestie=donec&sed=quis&justo=orci&pellentesque=eget&viverra=orci&pede=vehicula&ac=condimentum&diam=curabitur&cras=in&pellentesque=libero&volutpat=ut&dui=massa&maecenas=volutpat&tristique=convallis&est=morbi&et=odio&tempus=odio&semper=elementum&est=eu&quam=interdum&pharetra=eu&magna=tincidunt&ac=in&consequat=leo&metus=maecenas&sapien=pulvinar&ut=lobortis&nunc=est&vestibulum=phasellus&ante=sit&ipsum=amet&primis=erat&in=nulla&faucibus=tempus&orci=vivamus&luctus=in&et=felis&ultrices=eu&posuere=sapien&cubilia=cursus&curae=vestibulum&mauris=proin&viverra=eu&diam=mi&vitae=nulla&quam=ac&suspendisse=enim&potenti=in&nullam=tempor&porttitor=turpis&lacus=nec&at=euismod&turpis=scelerisque&donec=quam&posuere=turpis&metus=adipiscing&vitae=lorem&ipsum=vitae&aliquam=mattis&non=nibh&mauris=ligula&morbi=nec&non=sem&lectus=duis&aliquam=aliquam&sit=convallis&amet=nunc&diam=proin&in=at&magna=turpis&bibendum=a&imperdiet=pede'
    );

insert into
    Playlist (id_playlist, id_user, name, url_cover)
values
    (
        'a552f772-eed1-401f-b62b-33cd1ec494a3',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        'Study Playlist',
        'http://people.com.cn/vel/nisl/duis/ac/nibh.aspx?potenti=vehicula&nullam=consequat&porttitor=morbi&lacus=a&at=ipsum&turpis=integer&donec=a&posuere=nibh&metus=in&vitae=quis&ipsum=justo&aliquam=maecenas&non=rhoncus&mauris=aliquam&morbi=lacus&non=morbi&lectus=quis&aliquam=tortor&sit=id&amet=nulla&diam=ultrices&in=aliquet&magna=maecenas&bibendum=leo&imperdiet=odio&nullam=condimentum&orci=id&pede=luctus&venenatis=nec&non=molestie&sodales=sed&sed=justo&tincidunt=pellentesque'
    );

-- Add Lyrics
insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0adf569f-10e8-4abd-861a-eb539c364cea',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I''m walking on sunshine',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5e187305-45cd-4748-a275-8544b03be399',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e5969c6a-e73a-41bd-8594-c528415ef33d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9081739b-1700-45da-bfa9-79f07c2e20e8',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'I''m walking on sunshine',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e66ec2b9-ce4e-4633-b15b-c0a667040afb',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I''m walking on sunshine',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2f2403a6-d47f-4b86-9816-5ab1acba217a',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f95b66f0-dba0-4be4-83eb-07c3f6acd817',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hey Jude',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c680e955-5de4-454e-92a1-d423b35751e8',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Sweet Caroline',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ed47ecef-19c5-40d7-aa5f-59387f7c2951',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '272db529-2bcc-484f-9d69-3f35893e0b1e',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Dancing Queen',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f05e2cf2-ae68-438d-8d40-7d34dd8aa7d2',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5e7cc7e3-c3a0-4d9a-a929-b647355cd187',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Don''t stop believing',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9e3d9411-ed1d-4b47-b76d-90a5d6e31dbc',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Don''t stop believing',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1d58683c-2f04-4b46-8365-ae21426dc2ef',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8051eca8-5ac3-4047-a15c-4119ed0d2be3',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Shake it off',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6cd74ae9-c19b-4847-a447-e4ab10d552bb',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e2344054-7e3f-4cd6-861f-06917d3702af',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '61e09f7c-29ec-44c4-a4b3-6c3fb039dd01',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Don''t stop believing',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a9f07eed-9f54-450a-91d0-3f417a80f4db',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Bohemian Rhapsody',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6d2ffff5-815b-42cc-a748-d45ed5b17756',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I will always love you',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '04c1f52a-08e6-4a93-b5d4-88cc03a98c44',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Hey Jude',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '12db1e8d-ad1e-4cd8-88c1-29239fbdf6c7',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f7424133-08b4-4f8a-8036-b68405d369b3',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '15740490-6165-4dcf-8642-960909f6bc41',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'af697be9-29e6-4c3c-b4d8-a2bb224d7b97',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '13ccb3cd-626c-4ee8-b3e5-0f2e2b49edda',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I''m walking on sunshine',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '23a04754-8e4c-4f85-9450-1f76c8a62c33',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Shake it off',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bcd6f9a6-365f-4569-9f2b-3f39da1e74b3',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b8ad8139-ded4-4b80-a47c-8fa72cf7053e',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Hey Jude',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f14e59d1-4b20-4f50-ad96-d5d98ad7c4b3',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hey Jude',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '15c40a81-c67d-4988-855f-51437d6f598a',
        '3c02184c-b1f3-4430-912b-202415653398',
        'I''m walking on sunshine',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'eb8875fc-c69b-4e0c-9cae-2805a58ce87d',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c7e36cda-b528-4f49-9fa3-5f4d7fe52f90',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '466d12a7-360a-454b-aec6-e2c63499c998',
        '3c02184c-b1f3-4430-912b-202415653398',
        'I will always love you',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '884e61c9-44c7-4dc6-a9d0-091df2ebd331',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1d1eba0a-cb8b-41a6-8f5c-fce1b0c5f9d6',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Shake it off',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1be18f9b-451d-4701-a502-94d386f01833',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hey Jude',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '581aacc6-d1f4-42cb-b35b-8cd0195b5fd8',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '44b45539-ff88-4523-b91d-ea86107977eb',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3c4e2d6f-6f8c-4ec0-ab15-82afdf8e1e40',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '13c51bac-c74d-4664-9c4c-866854e44383',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Don''t stop believing',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '104e8040-a461-4fab-867d-780645a2208a',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e4c60027-47ad-4991-ae48-c25c3596753d',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '888d5135-906e-4d75-9b61-811c93741d03',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'I''m walking on sunshine',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f4828c9c-21df-405a-ba0a-a2de149ad84c',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Bohemian Rhapsody',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c8604437-dfe4-4708-bed1-a11476da0b8b',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '36e110ed-2b9d-4ca0-88c5-ad58214a6353',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Shake it off',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b30e0769-fe36-40e1-8a19-7bc863c850ef',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'I will always love you',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6c838186-6250-4097-981d-aa0e3590cc69',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Don''t stop believing',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b6a1f003-48d4-4a50-800a-6358498d0f26',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '36d2d21b-ac1f-4756-8461-13c738bcb66a',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '25b0fdb8-e259-48e3-a901-228afa17b73c',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Dancing Queen',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '31dd3a94-adcb-4a8b-b77f-eaf7d741b036',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '500ada49-3b44-4de5-be05-3f5b3e1588b2',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Don''t stop believing',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '34205b41-8efe-4152-9bfc-9688af91aace',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2421b1b4-e679-47de-ba82-d2719867a863',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4d1215ba-1881-41ba-b384-800d54ece194',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Shake it off',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '072e317a-af73-411c-ba3f-0e5179108d76',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '00abceeb-81b5-445a-a757-9417dd515547',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Don''t stop believing',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '25f7b2de-297c-433e-affa-2db5097551da',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Don''t stop believing',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8a2d4da8-4d63-4bdb-bf52-f20088c28502',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Hey Jude',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f5be7244-4ce3-42c7-90f1-0423feb41678',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b2d7d51b-c8b1-4c3f-a4be-fb49bba110ea',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9ea3ef0b-b5a4-4f05-9765-5dd6cd92ff7b',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hey Jude',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '418c6f93-2dfb-4a5c-b163-8de08e131510',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Dancing Queen',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5b44027e-5192-4fff-a647-40056039de6e',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2b492dc3-8cae-48a5-8d78-cd8a8bd9c353',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'I will always love you',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '642b7445-7540-48bd-9f7f-25fb9ee465bb',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fd1c6e40-5b24-4fab-bf6a-8a911854f3fe',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Livin'' on a prayer',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd1cc27a6-e46b-45b8-b180-c4f7ab3035a8',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e0ae752c-604d-4d59-be82-e0b1646aad29',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Bohemian Rhapsody',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dfc939c3-4649-469f-8cdc-d43738136cab',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '53838c2a-86bf-4224-9ddf-827f5eae5ab1',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'I will always love you',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'caaefeb6-8899-48a6-bb34-722a8e172e59',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hey Jude',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '25527f7d-8ec6-4c37-a4ee-7017ab6d5c58',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hey Jude',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c855e2dc-682c-4d2b-b951-70d994620833',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I will always love you',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '44518a0b-fd67-407b-8ce0-0ca22bc9e680',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8509c2ef-2786-4316-818e-ef2e870f6f18',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '82c6a9d7-459b-451c-9d6b-81a670ebd98c',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '63f185a2-ee6d-4a73-8727-f381d34027c4',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hallelujah',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4a6bfdd4-5fc8-428f-a47c-ec67e228c116',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aa4d364b-2cd7-48e8-9075-3a06d61a93a6',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I''m walking on sunshine',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8d876e8d-e2a2-4b29-b915-0e68112b361d',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Dancing Queen',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ff640061-ec88-41f0-944e-cb55a2c5361e',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b3208a20-1d57-4fdc-87cc-0d09248570cc',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bb4599ee-f8cf-4a44-80bf-d7614cc8b527',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Dancing Queen',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '229390c8-7856-4cf3-a7a5-d5e46b19c52e',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5cffbe9c-759c-4d41-b558-af120bcce5f0',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7fc7b104-00a8-4ba8-bfd6-e2b0cf350b41',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I will always love you',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2d9a2477-b309-4d3b-8ff6-a4fbec62dab8',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Shake it off',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a3f871cf-2557-4d93-bbb8-d06d0e4101bd',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4d0b7c76-6872-42e5-b9cc-d474fa99e387',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Bohemian Rhapsody',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '75e235e1-cf5f-451b-b38d-a842f21771f1',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9791ded4-385c-499f-9cb3-199f74f93d39',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e4d4a522-d209-47b6-92c4-711813b290b8',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Sweet Caroline',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '523bf28d-dfd4-4457-a66b-9ad98b8991ba',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Bohemian Rhapsody',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6c89765e-452a-4515-bfd8-8db061cc5cae',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Livin'' on a prayer',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd26876f0-5cb0-4a08-a294-840fcb05bad3',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Hallelujah',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '20d34d79-c4aa-4ae8-b63c-7e235ded0c02',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '32bee886-8273-450a-9eb1-b6b6abea7135',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Dancing Queen',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bb3d43e7-a7a3-4f37-9dde-a02d69f058b8',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I will always love you',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '84bb0661-5611-493c-adad-45e1084219df',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Sweet Caroline',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a4b8a29c-c341-4b99-a740-3931e5550faf',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9347c03c-2017-43d2-a186-f033cbbbf693',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e768d3ef-70a9-405c-952b-a549e962d644',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '876416cc-ce56-4831-a6e8-f251ac4dcaa5',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I''m walking on sunshine',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '873f7f6a-e06c-4090-b48c-32c09e902791',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'I''m walking on sunshine',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0daab720-c326-4e00-b3d9-6f01a2eaea36',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I''m walking on sunshine',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9cd543ef-acb8-42d7-bb38-6fbbc4f2d9e7',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I''m walking on sunshine',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8f5277a7-abc7-4498-a016-4246c46bb63a',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Don''t stop believing',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b21e2096-d74d-4563-8eb2-45fba0bfe02c',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'I''m walking on sunshine',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0697d3e9-f9ea-4e08-afeb-5cdd044c8da8',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Livin'' on a prayer',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f62e1f9a-aded-4efc-b30e-e38eec55bb6d',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'be844ec0-92ed-4288-9aa8-6b7e856f514e',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7aea621c-e7cf-4b9e-90ca-0b37cc58299d',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4ef513db-4923-46f9-b53b-7c7005be9bad',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '22120bd1-c5d7-4710-9529-46b33a7677f4',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'I''m walking on sunshine',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f65951ce-0540-4dc4-822b-89150e000096',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3e3ab009-6405-4aec-9e99-1ed67b2ae3a1',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2f957ee3-49de-48af-9a15-84ad5f2df4fd',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Shake it off',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ef54803b-1b33-4322-b9e0-9c3f3c8c19f5',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Dancing Queen',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '973ca919-5acf-4648-b1c5-3900cd13996c',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hey Jude',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9f8a3aad-57a9-4473-bd49-a6b1e82e379d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5b0e87b4-0316-48bb-8a6b-845a3c9ac6f6',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Shake it off',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '470b418b-a9e5-48d8-b8de-b126a9dc0bfb',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aaac7bed-f4d2-474e-bd5b-c16c423d59d5',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Don''t stop believing',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'baa59104-2aa5-40f4-9cdf-1343489940bb',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Dancing Queen',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cd8d0fd5-5b1a-4e18-93ac-eb492d462c09',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'I''m walking on sunshine',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0d0f0721-bcb4-42c9-ab97-7f116d9b3431',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I''m walking on sunshine',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0f370def-d3e7-4bf0-8c85-33f184221e5a',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a393423d-6778-40af-a88f-01af52aa9dd3',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '84375c12-1597-4637-9de3-405896b7dadf',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4673d07a-d03d-4947-a22c-6cda1ae80bcf',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '17326967-dd91-4d75-864b-2c24f596caf4',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Livin'' on a prayer',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5fc2d0b3-02c1-4b2d-b375-9a3eb0e4a227',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '46860b8a-dc5e-4aab-8ce3-61d78124f308',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Don''t stop believing',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0dab2b89-b041-4013-9c2e-4c61d16ba6db',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Shake it off',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '11e55135-56d3-4cdb-9ee9-48c8c3a79b68',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '45048fad-e66f-4f15-b54d-88da4cc5ae27',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I''m walking on sunshine',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1c6d5dd5-7b11-4a9a-8ade-4e2dba99a5a2',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f0ff7ab4-ff71-44d2-935d-caabe5436809',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hey Jude',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '52f98dc9-9d91-447f-a28b-c057630f6c72',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b3e82efa-9d70-43ab-8d31-e66e2be9c705',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I will always love you',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c886e0ab-e246-4175-8ee6-934ec3558f38',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '93915c57-e903-457c-8851-d1c5ed5f26c5',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Livin'' on a prayer',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dc19897f-80d5-4fab-8266-d29c617b2bde',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hallelujah',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cb13a823-2f65-47d6-a732-f1757b153d74',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Shake it off',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '23cf221f-5714-48a8-9388-3bdbcc5f5e3b',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '38548b1a-2776-4903-8588-0f4b566a3289',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f52104c4-882c-4113-8adc-604a59282414',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c9e98826-1db2-4a87-8103-2cf49aff45a1',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '37353d3b-0c13-48c4-ad1b-47927a4d7dd6',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Dancing Queen',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ea2227d2-3430-407a-a3a3-bb5599d1b4ad',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7d55da61-04d0-4b7f-b9bb-23a144bc2add',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Shake it off',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '020442a8-6cee-4e71-ba86-8ae7efe73883',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hey Jude',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b2e8d148-9d0c-4afc-9cb1-087376492ceb',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Dancing Queen',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '04ccc8c9-c76f-467f-94f3-fd95db271dba',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd1a50eae-0546-482e-a188-7576ffd18ab0',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Sweet Caroline',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '563c94ca-aa4e-4aba-8264-66a1c9d5cd3b',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Don''t stop believing',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0779fa43-7d1f-4566-bec8-a9290c518762',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '75180cec-1bee-4be6-9311-99a41af13751',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Hey Jude',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1e6f1668-82a4-4c74-bcff-b87183070ea9',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2ae48623-f318-435a-b93c-35a50f0ff14e',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hey Jude',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '23a3c48e-9f21-47d0-851c-a2a27aa6c648',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '90ae5b5d-b857-43a1-a6b4-b03a2513645f',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '47d512d9-acbd-4428-9952-a4e0cf9509c8',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Livin'' on a prayer',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e182fc5e-b256-4e81-b2e4-3db2092d7278',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0da88217-ff17-4843-b428-0c2f2501c31a',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Livin'' on a prayer',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0eb7cf62-6aab-47ca-b450-4292b3ae28d3',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f244f13b-54fe-4316-8587-3ce146b684e1',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5f1d1cbe-307a-43b3-beff-327fd5dff45c',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Bohemian Rhapsody',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3774d875-d327-4dc2-b1f7-d508afbaa673',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Livin'' on a prayer',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '927be732-7d97-49b1-8a2a-7d29a3aeb66e',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Dancing Queen',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bb953c41-798e-4cd1-860d-ff4c860bb130',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Bohemian Rhapsody',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9bde06c7-9215-4ffd-92c2-d9e16c3fd000',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b37b4540-e5d1-4d1b-86bd-8973d4e24721',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Hey Jude',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'eff063c0-bdb6-47a8-afe4-994233de732a',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bf5c1ede-7119-4835-abd2-d8f50876ebac',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5a1af993-8476-474e-b6a4-524a7b640b1a',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd483b167-2ad0-4bd2-acc8-16d8dfcc9194',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Livin'' on a prayer',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '19c62327-ddd5-40b4-9990-879ae173dd42',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6d92fb2b-3c9a-4992-90a5-b7321c5b8cae',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Dancing Queen',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '443de877-d1d7-40a1-a216-8de2138a2b98',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Sweet Caroline',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '50f50e70-eebd-4f19-b06e-a23dbb1af9e4',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aa30103f-a642-41af-912d-227befd3730f',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2e815a80-f64b-48ba-8585-ee6f0fea5262',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I will always love you',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '760be5c7-1911-4593-bbe3-b28090b90342',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '70417994-7fc9-44d0-8f94-0c7dc0394779',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '87a0cf91-b91c-448c-90ab-3a576771c778',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ac6702ff-fd24-4857-9c6d-e604b7018151',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Sweet Caroline',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fdd774a5-641b-4aaf-b00f-42ef4fb80f1f',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hallelujah',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '77866446-613b-4d0c-ade0-a91376f0d4b3',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I''m walking on sunshine',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3e3235cf-56a9-4932-b893-f77a55155e92',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Dancing Queen',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3a10d32e-cc39-48f2-bf7a-82f8c5185360',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a586d290-e1dd-4b81-a3d1-6115212beee2',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f89f7d4e-d480-49c7-ac63-b95775b11b40',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f70065fa-11e5-41ff-83f0-506c819aa47f',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6d00fb79-63d1-4811-b2c2-9a7d436937f6',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Shake it off',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '298dca31-62b1-4003-afcf-29ac0867e7ac',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'I''m walking on sunshine',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6d6cf899-e17a-4d09-992d-f6d826840d5a',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Shake it off',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e7567b62-cbc1-4a60-b5ec-8b6eb874ff16',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '103c90e2-98b9-49c2-8d2d-9dae784724fd',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Don''t stop believing',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e0a1e668-00d5-498a-a22d-ee4fcdda9b5d',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '004f22e4-115b-4bdd-8a55-be0b4f8c2543',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'acf3d0c4-1685-48d8-a90a-64f19a7024ab',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Bohemian Rhapsody',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e3882543-733e-45be-af8a-2876bf15d3ac',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd8512fab-8882-4daa-9e9c-206d461cb831',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ed6723ec-319b-4fd6-8c3a-ad89dd5e0b05',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Dancing Queen',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3719eaa9-8f6f-4cdd-b588-a2614f353d08',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '64087ef3-cab4-49c9-adf1-d95ec4922ef1',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Shake it off',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '44ee3c74-469f-4658-963c-93b652664a68',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Sweet Caroline',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '623d8608-7e0f-419e-8c85-a67785e3c639',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0fa38b7d-b268-48c4-861b-23e196e2ae95',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '71c2408e-1794-414b-877a-0f81253ddb42',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Sweet Caroline',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3e6b89cd-7ce7-455c-8e72-7c58792d50a2',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '84e01ea5-3b01-4809-ae24-71f34a3e7edf',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Bohemian Rhapsody',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '70e8f06d-ace2-486e-9ac6-4b206d3cfd7b',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Bohemian Rhapsody',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ee3908f2-c211-492c-9a8f-e8a37e91dd45',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Bohemian Rhapsody',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1e505c7e-16a6-4635-a4c8-343bb20876b3',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '884340fb-3ff5-4128-bbaa-352e7a7b83bc',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '292f4209-9ee0-45d5-830c-2c926e810e81',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9d1f3157-4cd7-4509-8cf2-76dc8a66aa48',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Dancing Queen',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '27c0376e-2ce2-41ac-8749-92f3b9b6bb06',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9bfc2c44-e324-4142-b0af-154d2a9ce4e8',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hallelujah',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b564f1ca-df27-497b-a851-025d390360da',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Shake it off',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cca94a1d-7072-4b81-866a-7df3d4744b20',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Hey Jude',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '70f0530f-10df-44d7-af93-27a8a96a829a',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I will always love you',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '77123c1e-9786-4af0-b4c7-7d762a0a2101',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bb50ea80-fda8-4a6f-8864-181cd4730421',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dda7f7cd-545e-406d-98aa-a791cc3ec989',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9522d101-f627-476b-baef-2edad1970319',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Shake it off',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9dacda8b-b9bb-4805-bbcb-493d4360b9ce',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'I will always love you',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '79c14b19-ebc1-4740-bf0a-8eb25bcacdbf',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Dancing Queen',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2066087d-ca04-4019-a12b-252eb460e4d1',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Shake it off',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ec2e4105-b0b9-4352-986f-fdb4f3f8c1b5',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Sweet Caroline',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '070d3945-95d6-4dd7-923a-f1185c7c8d53',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Hey Jude',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9d288b04-008f-4d39-a340-c20c4cf893f9',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'I''m walking on sunshine',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '119df4a5-3f44-47c4-a017-05cb899e34fa',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Dancing Queen',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ef1a638c-8537-4a9f-88c6-b4056d72109f',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0affa90a-8fb6-4af7-a9f9-f7c0d8082725',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I''m walking on sunshine',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '14f0d9e9-126b-461c-a8d5-de1b26bc4b5a',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Don''t stop believing',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c395bfd9-ab3b-4640-9ca1-5dea51b9d58a',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2e495e72-5e57-4a10-9176-d382496e444c',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I''m walking on sunshine',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'adfb74c8-8823-4405-bdd7-f459ee6db699',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'I''m walking on sunshine',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'db4c3bb2-25dc-436c-9033-9608ef43e394',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '884ba0ed-d5c2-4d26-b2b9-55c1e87fd62f',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '95b03ab7-55d7-44c0-90ed-7d90cb168378',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'I''m walking on sunshine',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4a16a390-2efc-49ab-85c1-1e91b4abe622',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9d91b3f8-01d9-49b1-aaca-18dc3eb36d2d',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Shake it off',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8bc131c2-70e2-48fe-876d-bc58a6818a45',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '582d1ec1-50c6-4c01-9df0-775f2e47520f',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cc8f49bb-39c3-4e0c-92ec-6185fc4f28cf',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7b65e140-65d4-4e2f-a7ab-be0fd7f263a1',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Dancing Queen',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c75069af-7636-497f-9f47-098dfbd1afc5',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Shake it off',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '323d04ca-698b-4ad6-9e83-0a561690ea73',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Shake it off',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4987ca03-b424-488f-8c64-c3373857de35',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Shake it off',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '37aee7e5-5287-4762-a98c-325ab1de6658',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Sweet Caroline',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6b72b043-eb32-4fc5-8732-6bf5e304a58b',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b542aecc-860b-42a6-84e1-09cd04a9ddc3',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '93317270-0fc7-4c83-956d-71126b35c28b',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'df587ff4-d8d6-4ec3-a8c0-23d1f53f3451',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '95521c4c-36b6-4860-a166-f08a774a5f2e',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Dancing Queen',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '227b46e6-74f3-4520-afe1-99f3f2e8d4d8',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6784b6d4-c8ef-42b3-a27e-bf8ef5c4db1d',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hallelujah',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '42ab9939-3cfb-42b9-a4b7-ba12ea02f474',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Livin'' on a prayer',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a2592a90-f92c-48b3-b40a-e3b471385f8b',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Don''t stop believing',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '69e6dc13-f748-4737-8737-489a6d14aea2',
        '3c02184c-b1f3-4430-912b-202415653398',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '132b1fdc-9d04-4d13-881a-156252144f57',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Don''t stop believing',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '57e6f3ce-ae6b-4d12-872b-a3099854d2cb',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Livin'' on a prayer',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4639400c-0344-4203-b765-0be403bdb7ad',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I''m walking on sunshine',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'da8656cb-f92b-49ea-ac9c-5a9fa14c4bc7',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Livin'' on a prayer',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2b71a1d3-437c-4d5a-a802-6933494a5750',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Bohemian Rhapsody',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7dafe7c3-6a1d-42be-8621-c4cb67c83719',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Sweet Caroline',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '20f9f174-697c-48f5-8dd1-88bf21ce2240',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Dancing Queen',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9fc64588-1f92-424b-9297-57e01143261f',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8fbf04e2-cb3a-4c69-b2f6-234f18040a8f',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a028f60e-7989-49d2-a990-57f720fc4a23',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd8a5c39c-88f1-4134-a7c1-07effbdfea24',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I''m walking on sunshine',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b8169639-761a-494f-9aa5-0cf137999cf4',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Bohemian Rhapsody',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '19ae3ba3-0f11-4470-94fe-a99dd1a2dda6',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I''m walking on sunshine',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'eb35c470-df24-40be-83e1-90a3f5179b73',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f63ef7d4-80a0-44a4-bfcd-3c4a42a5aa77',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'I will always love you',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '30a7dc91-5ea3-4a4e-8b6c-076b973c4628',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '141c3d1e-4f78-4f22-be20-2c43f6fa770b',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e23f0672-73da-4d10-97e1-048008ddb4b7',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2d70d606-14b3-4df5-a4a6-f5288531c367',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Dancing Queen',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '58270ab3-900e-4b24-b021-7f1f6571c30e',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Dancing Queen',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2cadef05-fa1f-4400-92e0-de2bbe2e65bc',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd15ab34f-ca82-4a95-9e3b-6f65d7ccc299',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '901b03dc-149d-456e-afe0-37d02803d12e',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Bohemian Rhapsody',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bf8b0fa5-047c-46a6-979f-72fcddc37fd6',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '765f0fe5-2185-4ed3-94cb-580f9f7fe123',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Don''t stop believing',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a506853d-d0e2-4cdc-8095-2cb4a0205f9c',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a0479cb8-0cc4-42d4-ad03-b14ba3dffedc',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bfb426b6-4175-47ec-8a43-5d74067b3aa3',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7dfb3b32-908c-4fcd-b4d4-d270182148c2',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dee51833-b4d7-4040-b2db-906ee83df13e',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I''m walking on sunshine',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '87ca4b05-11dd-4ceb-be03-8476e58a63c5',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Livin'' on a prayer',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fc9b8cc4-60d6-4d88-a8fc-d8a62dc8d339',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Sweet Caroline',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '22f84586-4407-448f-99c9-61d430b7d7c7',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c80cf5c9-d2aa-428e-9ba9-38f8dc9b387e',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hey Jude',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ade48442-ec47-4e2d-b7e3-47b38dc7c33c',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ba5ca892-b632-4a4c-a461-0a0f8b83eef8',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I''m walking on sunshine',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4a08fe0a-79d2-4c42-bcc8-f08dae170275',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hey Jude',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7000a57c-a3a5-43e6-9db4-125c931a15fc',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '24f024ac-ede6-4b55-9a7c-f6606924caab',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Shake it off',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5a9a6225-0624-48a7-84af-ba5e0e8fd483',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'I''m walking on sunshine',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2e3df67e-2f24-45cc-8b65-5d928704d06c',
        '3c02184c-b1f3-4430-912b-202415653398',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7a0ec18f-eea5-4c53-90a7-4b807a240eba',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I''m walking on sunshine',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '13c0d622-8e40-4b39-ad3c-afd7156fc985',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Hallelujah',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fdb8490d-fbb0-48dd-85e9-7cb42ddb791b',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2a618e21-10c2-4db9-8141-ca0ffc5728af',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Shake it off',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a7eb7d1b-b733-4cc5-bba4-700cda983e55',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Sweet Caroline',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f18efe99-a2a4-44cc-b0b6-c592702a844a',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Sweet Caroline',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2f81817e-ae1b-46f5-b250-cc330166f2ca',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Sweet Caroline',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e548be3e-374f-4dc1-9722-12629414c1f5',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Sweet Caroline',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cee6da0a-c7f3-4c6c-bcda-e1bf7eb38d25',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '69548c9e-71a0-4dbc-a066-01bce3a42ca6',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Don''t stop believing',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9576f622-d866-4e36-97a0-bddf11ca4e4a',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c54a435b-0790-40f5-bf6f-4fc0f8ff6a5e',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Don''t stop believing',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'af59a67b-0668-4e28-b040-95e88c757ef6',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '01320d5d-33eb-486f-b84a-6d15222773eb',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Sweet Caroline',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '39a19934-aa80-4043-83e5-3550844b6071',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Don''t stop believing',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1f6d1f56-e419-4b51-9348-dfdd5693e717',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Shake it off',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6ad50962-c455-4eeb-8d9c-61df6f98671f',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '945045dc-3114-47e6-b541-10ee0d009b28',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I will always love you',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e04a901e-85d3-43ce-bfa6-dc92bfd555c0',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Dancing Queen',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b3d1f434-9401-4bbb-a3b4-b3d46a76e509',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Shake it off',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ca35f23c-a111-418a-8d80-cf489a5a7211',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fc5def52-3225-41b2-b27d-2f16ac5664ec',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '553598ec-188f-44c3-b5f8-79b63a2f0750',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '665eaf11-627f-4a40-97a3-feef802258da',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hey Jude',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ae664cb8-98cb-450a-9490-712795a6aa3d',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3245d8e2-e51d-4349-8592-49d7b8d6cc48',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'I''m walking on sunshine',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6cc7ef92-5643-4977-828f-8fdd0b9dc355',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Bohemian Rhapsody',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ceb26f0b-ffcf-49f8-b023-e5fae8d7ffa2',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Sweet Caroline',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2d3b3519-11e2-4cd9-b1b5-a55ea09f0190',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Dancing Queen',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '32b2aba8-2be7-4e2e-83b7-54eee2eb8d18',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6e82c175-375a-47a7-bd2e-9f389a8788bf',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4a2091d2-cc85-4d6e-b3b0-004f004caaf9',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Bohemian Rhapsody',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '32b885bf-ab87-432e-aa38-7ad84e498563',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6a735734-e6f0-441d-b049-9d5846f0ad5b',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Dancing Queen',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '35fc946a-3a3a-4bbb-bf3e-72008173013f',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e2c61155-ac05-4b89-a97f-6dd903161b88',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Bohemian Rhapsody',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7b73bfe6-ba73-494f-9843-645906285117',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hey Jude',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '91859983-6885-4a25-9175-3a7b554c8d3d',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2e9dd0f3-7a7a-4e0e-ba4e-b604052af7e7',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Livin'' on a prayer',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '78a03da5-e9ef-43ad-870e-b1cddfa621f4',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6c0a62a6-0d88-4cff-b835-fb8b219fb4f6',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I will always love you',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dc320d3d-469a-44e6-840d-79b8e91f50bb',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Shake it off',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '12d2ca86-51e1-4d00-acc7-347a85dadd63',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Bohemian Rhapsody',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7df7b4df-f29b-4aca-a914-bf14ba86fc5a',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ccae9be2-4ada-4271-a468-6e430ade6a70',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a7c453f9-aec7-4022-affb-80e58ec85884',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Sweet Caroline',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b6fe7fa8-644b-4e17-a26d-223ee91bdaeb',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Bohemian Rhapsody',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9aa5b11b-bcbd-460a-be28-d70d54aaf6e0',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '273b6cf6-3ec0-4463-983f-32ab31ecf633',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Sweet Caroline',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '60eea8f4-e947-4f34-ae79-3a6849c813d3',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Don''t stop believing',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e205085b-5cd1-46d5-b354-492584c81af3',
        '3c02184c-b1f3-4430-912b-202415653398',
        'I will always love you',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ef522bec-d3c1-4167-91f2-99be2783dbdc',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Hey Jude',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6637700a-fecd-4c07-9a24-7005fdb1d6f0',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '48e75fd7-7c0a-4faa-984a-fb0dd7be88c9',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Shake it off',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bdb003db-4230-42ec-bf62-6a2d90db9f03',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Shake it off',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4a097172-de55-4552-95c8-21991f50a80b',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c4f1a85a-859a-49e8-aecc-4e920f085c96',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'caaa0ee9-96c8-43c0-8849-5d9631c11de1',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Livin'' on a prayer',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '32d414f0-f83d-4275-9104-63ca318d9524',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Dancing Queen',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '41e9f036-0f14-4d00-bb3a-6d0f6eb465ee',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hey Jude',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '08b7fb5f-1b5e-49d9-a7ae-96089989437c',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Bohemian Rhapsody',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b81be119-ef5c-4862-80b5-bd4dc8bb07ba',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Don''t stop believing',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '64b641a8-63a3-4d48-bce4-e323cb441781',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Bohemian Rhapsody',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2185c194-5a67-4fef-be82-0d8c1bc87a6e',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Sweet Caroline',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '49320283-35b4-48d0-8962-7e434fe7162e',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '48335e07-ffed-4e84-8a2b-11da07bd8910',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Shake it off',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f9e87d10-c68c-4ffa-8def-e78990320bd8',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'I will always love you',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fa03220d-c99f-4fcc-b547-8cbbc665660c',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7145d676-7767-465a-ac1a-5dc7e6e8b717',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Bohemian Rhapsody',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b21dc491-842c-452f-a1e7-a61813bd604d',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Livin'' on a prayer',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '910aae18-6e0a-4c65-a975-27458c64255a',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a9058324-c624-47f0-87de-0d6f1ea7e6e8',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fca21a8f-e100-45b6-bebb-b084c634a1be',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Shake it off',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '86f6e892-c558-41fb-ad8b-62bc7d8d2775',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '97604e65-6101-4f4e-961f-73e02585b424',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Dancing Queen',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '451b41a0-f322-4fe8-8575-c47365ae7c04',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dfa2af2d-f393-4326-bf11-820b6ec02b2f',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Dancing Queen',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '26477a67-b9d2-46d7-9d09-131d7c632b86',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6b1b555a-3a02-4922-9ad9-bae5a96abc80',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8af45b0b-11ea-40e6-a597-2e494e6699ac',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e3f40bad-187c-4a4a-b885-fc22d08b2ec5',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hey Jude',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6968b44e-7dba-4fa0-8147-3568e9efc7ae',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Bohemian Rhapsody',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '750c0cb8-6c8b-441b-ba69-c24eea13f7ee',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hey Jude',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd2da66c9-92a2-4384-817e-80a007a94420',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hey Jude',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2be959b8-8303-46e5-9cf4-f832c9acad15',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I will always love you',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '153d2800-7f58-4b65-a92b-59f8cb1442d0',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I will always love you',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0acb9b67-a464-400e-93a1-f090c1ea1639',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Sweet Caroline',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b9fc9fb8-e7b2-4da4-bdf1-26c072b0347d',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Don''t stop believing',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2b0ddde1-bb34-4855-853b-11ef5c8e832f',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '40525ee3-b862-4016-87b6-cf1658892cbb',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Sweet Caroline',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '154ae796-6a31-44d0-b318-85a6d2bd251d',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Don''t stop believing',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4a4060d8-9387-4de8-b9a5-1bb8e006c084',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Bohemian Rhapsody',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4ad3ca27-c2d1-4d0b-a604-648d642aecca',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5866b55d-9904-49c8-8141-023123b278c8',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7c91f24f-1812-4160-adb2-7fc1416041cc',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fec76e01-e33b-40aa-97da-282af18943e3',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Dancing Queen',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8d2fca65-9f5b-46a2-97c7-59ded8ce1877',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9c15d941-a652-44f7-be96-d84bb2252a84',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Livin'' on a prayer',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '45aa5be7-4cff-4f46-beea-fb42cfcc89e2',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Don''t stop believing',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4ad30519-2a70-4f22-9d5c-f295746f8175',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Don''t stop believing',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9ac4409c-97c7-4fd7-b7d7-f36e730262be',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Sweet Caroline',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6308ab77-9920-46e6-b637-ad00d89ebb23',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '21a71108-636e-48e3-857d-3f6d995fdc54',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Shake it off',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '549d4f7b-ba4f-42f9-92dc-f4fc7dcc0f38',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Don''t stop believing',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '77ed6804-b01c-41fb-a085-114ec881cf03',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '88243b65-0945-45f5-a946-ac8c26b065f7',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Sweet Caroline',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd6378cd9-1b70-4f98-acb6-1d59f1b9feb2',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c6164765-e627-49a7-86e9-a9f6916a6582',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '00bde2c2-9200-49c4-8177-d7920b8dc374',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Hey Jude',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1ef72bbb-8bc2-49c4-84e2-4c0bd88b9921',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hallelujah',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '91c6e80a-669a-4ce1-8320-2f4f08da8f6f',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I''m walking on sunshine',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6333f8a2-f369-4da1-a1b2-3ce8e57b3942',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Bohemian Rhapsody',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '030a3f80-bb74-4cd9-aa63-0cc445afe310',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Don''t stop believing',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '48c6f82f-2a3b-4cc6-977c-1852d1c03fd7',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Sweet Caroline',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c959ca5b-7ab4-4f2b-ab4f-6af5487c86e6',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '16b247c2-04f9-4fc7-ba54-ba9836d3e2e0',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Sweet Caroline',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7c617114-dc0b-4128-bacf-e69bd3e21e90',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2393380c-bf02-4a38-aecd-f3d7165c05c8',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Don''t stop believing',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2fd17619-1500-4d2b-b98b-5f1bf2cf575d',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I will always love you',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3d39be58-3697-4664-b4ee-8c3cfb8fb98d',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '98c54537-9584-4d52-a422-c0771165292b',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Hey Jude',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f1a28f85-32a6-4d29-b576-6cf5ad3766f0',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '93b6290c-24ab-4df9-8226-7a81642fd379',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '660e7441-0530-4e4b-8f04-27e67ed644cd',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Bohemian Rhapsody',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ce582535-4429-49c2-bbf1-3f38b08ab1d4',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'I will always love you',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '30fac34e-3b36-4de5-a12d-58da07e44179',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hey Jude',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bd3ffe38-9eb6-4ce5-a653-574c39ede069',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '449926bb-a898-41a5-afe8-a15d0aa2a923',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ea0a3af4-98bc-444a-a03a-b13ae0890405',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Sweet Caroline',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2be85269-9243-4a6f-8fab-86a8bc52abe5',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '90c6634c-51e5-4126-9f69-e619b9efe1cf',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hey Jude',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '95bf43e1-5719-4b2d-94bd-3cf87136d305',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '60399d7c-2dd3-4423-9e0b-3deab60145aa',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hallelujah',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '294e0544-0c96-4a1d-8462-86bb5f744176',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I will always love you',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a5072540-623b-4175-b13f-a563f8cbcdf1',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hey Jude',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9a7742dc-c9b8-4f46-aa81-e6b884c986de',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hey Jude',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b3081e1e-c964-42c0-890b-a42ade045b17',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '161db96e-3f63-4dcd-bac3-f8f9b9345a3b',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '24ab3a3e-39ad-4d87-97e6-7b75196f95df',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c63aa28d-f615-426d-8f4c-fc240cfe26ac',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'I will always love you',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'abb580a6-f796-4b28-9c55-bbee51c7b098',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '155c6516-ebff-48c6-b174-ff58690ee7c6',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I''m walking on sunshine',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7982deae-fc2c-4937-a176-e19407f318e4',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Bohemian Rhapsody',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5e18541d-ead3-4a06-aa21-e8cb86ec3795',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bd926d11-126f-465e-8a2f-dc015f571489',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2e49bfe0-9368-4180-95a3-b78c51be8990',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Dancing Queen',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '21285f6c-f7c4-4f2f-a615-7b990337d777',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Sweet Caroline',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0b55f47b-aa80-44aa-9346-b208ccf8cdfd',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Dancing Queen',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '52a73683-2e87-4acc-8f7d-5da6d4c0e9de',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Shake it off',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'daf610ca-a5ca-499a-bf74-60b9fa667cd7',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dd24d523-bef9-47f3-9bb3-1de6f2b688f2',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'I''m walking on sunshine',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '126b29d9-f0d3-44a0-82fe-ce290e1fe2f4',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Sweet Caroline',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4e146f5d-96c2-407c-86ea-b679e59b1c66',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '43d3e0f1-1059-46ea-a4d6-ff52936d5aee',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3b00db40-7690-4cba-b0e6-f953850e16b9',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '67ec7281-890a-4088-81a4-716a85d7a5eb',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f812ec48-cf58-4a26-b14b-d9334c682ded',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Hallelujah',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '91431ca3-c231-4641-8e01-630ac88546cc',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e8485dde-2a10-4bd6-bdbe-0632b70b4983',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I will always love you',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1d06d378-7dac-4019-ba2b-1f0b77427da9',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '860aafad-9bf0-4d2c-8bc8-c34681e96319',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '49e69475-1d06-46da-965f-90fe4dd26ab6',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'da2d774c-1cca-403c-8f6e-d3f2d692e796',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'I''m walking on sunshine',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '51487bfc-b738-4b0c-b710-4d67cb83120a',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '256799f9-0942-40b8-b348-e60b1d9607dc',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Shake it off',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9028ccb4-3032-4a8b-b57c-c95bc5591240',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Don''t stop believing',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2a0e48ca-c4d8-4e8d-8f09-43dd25c86c6d',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b724210c-b954-473b-81cc-2104a83b20e3',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6784aa06-edd3-49fd-b2d2-e113f45630fa',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Shake it off',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f774ad80-58ca-403c-9c88-2d80fda22e09',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Bohemian Rhapsody',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a3891a4d-f2d3-44c7-b1cf-09b0ab718bdd',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '67210e89-a54a-4c03-a6b7-c41faf80f140',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b9ed5d19-5022-42a2-b8c0-f8d9df33029d',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I will always love you',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '18ab722b-dde7-467d-ad7c-2b0bc600afd6',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0517954e-b36c-4683-acc0-85fdceb58c30',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd787d02d-2f78-47ba-b745-6a6f956dae1c',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Dancing Queen',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1fd5e7bf-6d80-479c-8aee-fe5218f6acd6',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bbe7e7a1-54b2-45df-94ba-8016a7161a62',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dd69ddf1-64c7-4f39-9647-4a28bf7dffa1',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Don''t stop believing',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '799c889a-39b2-42a7-9dfe-d071566a12b0',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hey Jude',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0a94153c-0b99-43a5-8daf-1aca4d1b2481',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hey Jude',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'be68ea70-8f6c-4c48-88ac-12acefc9bbd7',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hey Jude',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'beeb5652-5f14-4181-a13a-a0babe17bfea',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hey Jude',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3422a1de-d6b4-4cc2-a4db-808cb1dfca1c',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Shake it off',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a4da6ecb-0572-4636-a377-d56d9b68541e',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Dancing Queen',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '20583ba6-7657-4249-9d0c-2ab6647178fc',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Bohemian Rhapsody',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4b9ea757-53c3-4b33-8135-056d2a564fd0',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hey Jude',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e85552f0-047e-431a-83a0-bb4f6ceb6797',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Livin'' on a prayer',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3f163bd4-6939-4d3c-a9d3-d3c8644ed05c',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Shake it off',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7b444617-799d-4a22-9fa9-5aa9e5e794c3',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Livin'' on a prayer',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fdf8a277-bf6d-4ea6-86c1-d92c115af688',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5177f058-256d-498e-972d-6a12f0a97dde',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6011df13-a063-4af9-ae8d-0bb4cd31693f',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Sweet Caroline',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '21af5567-089a-497e-b4ad-9641230402c7',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7fe336f3-9434-42da-8df7-e61e60c0f03f',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Bohemian Rhapsody',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ff9a521f-18c3-4550-8901-374989885d2e',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I will always love you',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c22208af-8835-46bb-9011-e8b8e2953d10',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cc4c5347-a0fe-4226-b1a5-0875621e815e',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Dancing Queen',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '05f96727-c86a-4ca8-9e9f-4efdf114c860',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e5291476-000d-474a-a939-021aa820d768',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Don''t stop believing',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd13c94b7-9aa3-401b-bf17-c9275ae91315',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Don''t stop believing',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '436da4ed-2c22-45ea-b0c4-518a49c4e924',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Dancing Queen',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7095affb-6ba6-427a-831a-02084015fdd1',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Dancing Queen',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6db23c73-3426-4bb4-9447-337fd7e88581',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Sweet Caroline',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1585c41d-d18e-4703-b480-ae6c665e5861',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bfac6543-d455-4796-bbdb-cf58f9babb52',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fd3e291f-59df-4495-9654-16395da3934b',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6dd0d3cf-51b2-407f-beef-bb56b3ecaa2b',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '12c891ec-0aa0-43e6-bdcc-e3d0e86d3038',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5c410412-bf2b-41b3-82ca-c24124dbbe2d',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Sweet Caroline',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '64fef018-fb6a-4fa4-b7f3-94579276d168',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '71c3e0d3-b40c-488b-9aaa-19b7c47f2c16',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Bohemian Rhapsody',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7146e1e9-b9d5-469f-8de9-e092ccf2158e',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hey Jude',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '186f93da-9172-48fa-a32f-57bb0f1d0a6c',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Dancing Queen',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a1da7359-2bcf-459e-90fb-4d21e5659dc3',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cae633b4-b888-4641-93a6-af53632ad984',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Shake it off',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dcab5d25-3b94-4ba6-bbb2-4106e5ea3705',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'eb8d2d72-083a-4696-bc90-aef4c9ba9af0',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1632058d-f0f7-45df-bad7-2c5c217c9c7a',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2695bf42-c0f4-4975-a422-ef328e237abe',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Shake it off',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '05d3add0-d21e-42f8-9975-7be3b5a47873',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Shake it off',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '073301d8-1665-4843-8b08-91d160265fe1',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '70c43eb3-62ff-4691-9cbc-d0ef9128cb77',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '485d97e7-f293-4620-887b-e0a151a9e574',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hey Jude',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6e043134-21fa-41e6-a3d0-09a10750f934',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0e760fe0-0aac-4dab-bc41-6bf161c8ee87',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7d107177-736e-4653-a6d2-f45214133002',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd10dd199-f29b-4650-996a-0045dc59b3ea',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Dancing Queen',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3ab73df3-ed7d-4b69-b78a-955f3f823c6b',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Bohemian Rhapsody',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '77151f60-4a58-497d-9d73-62059ca38d04',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Livin'' on a prayer',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aecdf6e3-bd50-4de9-a739-986c4e5306b4',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5b3ef635-0d3f-455c-b259-97c7486376d9',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Livin'' on a prayer',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8011c6fc-983e-40f4-b56c-57e302ce90bb',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e31789d1-3bdb-4cdd-988b-351381c0cd56',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e93d67cf-c692-4d0d-b180-2c3fb53c9aa8',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I will always love you',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7356da1d-0fd4-4e97-b21d-fad47c49758d',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Shake it off',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ea1e1a38-89a6-4d8b-880a-165be5939363',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '756b9775-830a-4bc9-a79b-4768c5448da1',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'I''m walking on sunshine',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd90e82d8-9376-4c4c-b61b-ed4c1bcba8dc',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6536a0ab-08c2-4fed-bb41-f335d9d3bbce',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Dancing Queen',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '79d7d1ff-8a80-4637-8d86-c953250ef364',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hey Jude',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1cf911ec-25c1-41a8-a921-965e12a6da9d',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Livin'' on a prayer',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '31128168-f1f0-4df4-a4d0-8e1ce78a3c6a',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a91167e6-4846-4122-a3c4-9fdd0f5eb34e',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '762f582f-28c4-4ace-8853-8d5943815e30',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Bohemian Rhapsody',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cb465f09-2b01-4bb0-9e23-0dc77bcff4b3',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c3d4a88f-9af9-42de-8525-286c513f2947',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Shake it off',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dc4f396a-3614-4b7a-962f-48a7a7913874',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e8b2b4f6-e2ef-4798-b32c-3f9ae43abecc',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '16dd12d4-7ae7-4ab3-b0ba-7f4163755c62',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Hey Jude',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1fa638ee-ff3d-4479-bc2d-b22a91bb39b1',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Shake it off',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ebc63cae-860f-47e3-a268-fb8b9f8605bf',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Sweet Caroline',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '71c97082-f3bf-48a6-9110-1b8804b18198',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Shake it off',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e1cfcccb-38ca-4bad-9fb9-914156419c05',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '58091c8f-745e-424f-b8ad-841d806b56d2',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '458bf3e8-3bb3-4d6a-9aff-b60a45372738',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ddef23c6-4326-41cb-82fa-84c6bce52674',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Bohemian Rhapsody',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cf0135b5-0b11-4008-a6e6-a25329d46aa0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7cee43cd-57a9-43cf-913c-5b7109ce119d',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Sweet Caroline',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'eab8d62e-b563-4469-8892-f5c98c33dcec',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '747aa1c1-9a02-49e5-9ade-3e5988ae168c',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '20745775-44a6-405e-a1e0-0cff3882f885',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '48310582-733d-49a5-ba44-7469714d73b2',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Don''t stop believing',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd3d3b717-dbfa-461a-8e28-a77ba32de48e',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I''m walking on sunshine',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a2e7e444-c975-4d81-afc2-4e48fa492b1f',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Shake it off',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '67e4dd0b-1c55-4955-946e-03ab98eb6651',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Don''t stop believing',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3a95f244-39a8-4cae-be7e-55b975abdb88',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cf79ef29-491f-4416-8578-7950b93584a9',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Don''t stop believing',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5be555f0-7971-4f78-8018-041fc7e8124f',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'I''m walking on sunshine',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0c53d0f8-8789-440e-b704-29142a9cca5e',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3cb01d05-34b6-4828-a3d3-ef0aa283143f',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I''m walking on sunshine',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '651ab6ad-ef76-4261-977a-19eabb37ab31',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Don''t stop believing',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1d4f1ddc-df3a-4adb-8cab-ffb5485527eb',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '79b9f5b3-3487-47ca-b789-ee16429b5597',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Sweet Caroline',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3ebf7beb-7b3d-495a-8790-5dacc7039372',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hey Jude',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ec60a0a1-7418-43c0-af00-3b4793e8bfd1',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd3ec8f8b-5df5-4192-be7b-2a3583114440',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'I''m walking on sunshine',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '54bb9ffa-16a3-4cf2-b91f-df105bf061c4',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Bohemian Rhapsody',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '35bf4c16-8c00-4521-b620-b8f675136ae4',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7eecf10d-a474-4c4f-837a-dd2f3be4004e',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Don''t stop believing',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7bebe1e2-ee20-4764-be23-7bfc129f8047',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Sweet Caroline',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1fa6e6f6-abe6-4e0a-8490-8db6ab5fb551',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I''m walking on sunshine',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fd515f9d-672d-45a0-a956-44fed48bc078',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Don''t stop believing',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '29867831-7ed1-4ed0-9c73-1f2089a264a5',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Shake it off',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '138fce2b-56ed-40e7-ba02-af6dd434503d',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I will always love you',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '747fe833-34e1-4d98-8e89-0869e56cc307',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I will always love you',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3daa3ca9-3bb8-4411-930f-5af8e195d678',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Shake it off',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '68d55705-0a35-4376-96a6-342b75b994b4',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '71360499-d223-477e-a462-ac465a1d8a17',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5499813c-d76f-4814-9aa7-8143e3d0ec56',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I will always love you',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9c3ac85b-6894-426a-bf46-3410a0635592',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cb6c6102-e3d7-43ef-a474-b27993c47e27',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I will always love you',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f35abc1c-30d3-4b65-b72d-988ffb77247d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'abf71245-1f0b-4406-b496-8758ca4adccc',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bffdf78d-793b-4315-815e-5bce417049e3',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hallelujah',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5ab55f2c-367d-42f2-975f-a328bb612770',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Bohemian Rhapsody',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '36673c8b-9f38-4265-be6c-54688a37c33a',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9efac08c-46a0-4c9f-b368-23bebfadbf12',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Dancing Queen',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3dc224e1-8053-48dc-9564-0b817c5783cf',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hey Jude',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '42c8e1fd-d2da-4109-914d-7e67325259a7',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bea38842-72a3-40f5-aca4-bb233d46bbf5',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hey Jude',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e68f324b-9460-4c53-959d-2de36fe1eeb9',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hallelujah',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0d0e876b-aa07-4e4d-9d6b-6954d83da609',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ee76386a-d05f-462a-9bff-1b592497f9e8',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9bf6eddb-8886-4262-b5ba-485421b9374a',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Dancing Queen',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c3f8be31-7fca-4f44-b0b6-70ca7926b466',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Bohemian Rhapsody',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd3995e2e-97ff-410c-a230-97ffaacd47b2',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hallelujah',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '01111873-58f6-4f48-b7d1-7b5a1889b349',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Don''t stop believing',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7e5f5698-c09d-43db-9cfc-1275264dc2b5',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Sweet Caroline',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0e86bf7c-efce-42d9-8675-3ac5c519efaf',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e4988e4f-843b-4171-8546-c1765cd95b2b',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9a8bfce5-c57a-417b-9857-825b20b4339b',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f883cc60-3dc7-4269-842c-cf88c1b4bc69',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Shake it off',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8a9dfa41-e519-493f-b56f-75cdc13971e2',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a3fa1315-8a41-485f-b724-8f4bf610f498',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e5fa854f-cc9f-4f6f-8948-f8dbd6b4ec74',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Dancing Queen',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8fc338f3-8ac4-4a6c-9ec8-ca29ff0984b8',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '28ee83ce-f809-41bc-b600-96e90cf13efd',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f4f6dbcb-63ec-4123-a0c1-befe75269596',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I''m walking on sunshine',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3dc4399b-42cf-41cb-b5df-4bd55189f360',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Sweet Caroline',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ba9a1197-246b-4990-a98b-91537e2dc9a7',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fe38f010-c00e-4d08-91be-c2cac0ec1f54',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I''m walking on sunshine',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '417982ce-7eb9-4950-a38a-81f7c02f5d26',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '99c2b31e-2916-4b58-aa7b-ace3db1d6c37',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9dd5e2b8-cf97-4944-9ae4-24965e4f48bb',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Hey Jude',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '306e9619-c950-4280-9702-818dcfab907e',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Livin'' on a prayer',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7563cd14-cf83-470a-9a46-5be90b1b1209',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Dancing Queen',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8614535a-c673-4ada-b98a-ce3330e179fd',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '35d8b1fc-1f51-4e1d-9d6c-cb17115cec1d',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I will always love you',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8670e1ac-3146-4588-92a8-0ead8f38cfdc',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0e7e83f3-8fe8-4707-b146-7c75381ca2bb',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hey Jude',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ce467531-c2e9-4c79-9003-0f1b451eda0b',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'I''m walking on sunshine',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3b55429a-51a9-4e33-a4c2-cca965ee6742',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I''m walking on sunshine',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e8e2ea52-46e1-482c-9e6e-e91e6e2bbea9',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I''m walking on sunshine',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd5167eac-17a5-447d-ab7d-34a783685fd6',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Don''t stop believing',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0ff153a3-1675-4b9a-9773-558f71de9c10',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Bohemian Rhapsody',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0a8a10c6-084b-4859-8ec7-10d5c970ac1f',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd83a66da-1b2a-4b8d-aa89-4b1510c06ad8',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fb429aff-d6a2-4780-9214-535c7e413551',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I will always love you',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'abbc6555-57f2-4143-bcc8-51528978d4a7',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd15ab876-8835-4a6a-9f7e-a6b28d07f83c',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Don''t stop believing',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '15fc8e36-aa33-4c6e-a926-f99d1a39e050',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0f173a0c-9621-450e-b808-0d39a02b69df',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '18b42ff0-ad61-4d8c-beb1-1305e9adf2e8',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Bohemian Rhapsody',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '161d1f30-8d54-4ad3-95e6-2bbdf09a8940',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Bohemian Rhapsody',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3bcfb8c7-ff72-4c9d-8c18-43292ac6539d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '24efdb6c-6466-492f-a034-f3f5f2480887',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Don''t stop believing',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b0f9e9e2-76b7-495b-9295-7c137f4cc9c0',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c8261e35-d9be-4928-a5e8-2471eb52b66d',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '128797f8-e803-4353-9157-5890c98ecd85',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Livin'' on a prayer',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '64b31102-94bd-42e2-857c-e7ff7dc1903b',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '486cdd17-844a-4320-bb2d-9f5254665406',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Shake it off',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1e134aff-2ef3-4f40-8ec0-f8401438f3d1',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Don''t stop believing',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '533e6ff4-ae74-4757-a0fc-9fddd54c8365',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Sweet Caroline',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f6279e0b-23a8-4654-b6b1-2642cebd0459',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ee9925f3-7fda-464e-911f-7eb7e9558558',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a21543cf-48a9-4dac-88fa-bcae0e4b3874',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Don''t stop believing',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '66b868c3-ab94-45f5-bb94-e7694c6e2097',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '50aa084d-e189-48d4-9d7a-61296d236aba',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '167c1d0d-4f8e-491c-a728-b41bab437075',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Hey Jude',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '27cecf6a-3c42-416a-ba48-0e39b774dae7',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I''m walking on sunshine',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c7522a67-519e-4ae3-9b03-633293109250',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hey Jude',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '49ce909e-317e-45ff-94b1-b6c6e7056f24',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Bohemian Rhapsody',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '09572e77-d9af-44c9-84c8-e9bdee1fc13d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3fa1d5a7-7373-4cdb-9ff1-39eb5602d5f2',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Don''t stop believing',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '83be4020-062a-4d15-a155-14d22bcabeef',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Bohemian Rhapsody',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6abe6a3e-90da-4e30-9f37-b8436fd585ba',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Dancing Queen',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5a98c7e4-4042-4e23-bd55-dfe58053404c',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2e0ab2f7-2674-41b7-a5f0-e0657a3b9f19',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Shake it off',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b65ddb00-ac22-4384-b661-445c4ae5951a',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8fac5dd3-5bc5-431e-8f89-6e6431089fe2',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e8985469-d7e7-4be5-8fb4-bb4a4d12af38',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dbc96825-eb58-493d-8deb-f6acca378276',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I''m walking on sunshine',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '21986514-5d7d-4fe0-ae92-934f4635eb25',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ac01150f-e3b5-43d0-93a8-99b9173fdbda',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Shake it off',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'baac65c8-3d8b-49f2-947b-ff0a3f1a7200',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I will always love you',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '15c76e2d-281f-40da-986c-e18f23bfae4f',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I''m walking on sunshine',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '25d604dc-6360-4eac-9a7c-db46030a2641',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '28a5b6b6-a1bf-4ea4-bc94-4bd56344c476',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f0fda77f-e3b9-4e0e-a344-7b1568f94e09',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aff7e5d8-1e43-4d59-98c5-7dd6bc14dee0',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hey Jude',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '72c7b2ed-6b6c-4503-9635-1d69eab7236f',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aa06c6ad-f3da-4893-b0c4-0b0ce021389b',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aceccd65-94f4-478f-ad7d-73a7c1b200fc',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd14c367d-d4c2-4570-a22f-e9bf059657a3',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Hey Jude',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ef5931fc-4615-4ba2-b34c-76091a37f0ea',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Don''t stop believing',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'eb9faf37-e0d7-4fa4-9c9f-84c6f04d3c76',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Shake it off',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7b4b1a9a-b3c6-47b9-aa79-6d387209ac0c',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Don''t stop believing',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8523413a-2f99-44fe-bd1b-c37f8693d129',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '33af2b0e-6e3b-43e9-8312-b9bfd7cd0813',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Livin'' on a prayer',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '89ae4aef-d933-4008-87ea-d1c3b359ce14',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '855ddaf0-8fa4-43b3-a796-4b88289ddcfc',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hey Jude',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '06e3e94f-f9f6-4575-83e4-c7c191c63c50',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '940bab97-1a4b-4bc4-8fe5-64039bd2d727',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Hey Jude',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '35d9c006-a980-4844-bbfa-514fc22666f8',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Bohemian Rhapsody',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd9c1bf6b-3e85-414b-9ffe-8d7085165621',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I''m walking on sunshine',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b1cc0a47-ce0a-4f88-bbd9-fca751dffd94',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9e929766-73ab-45af-986b-f873f06b9f7c',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Dancing Queen',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e1c03ab4-3741-4d80-90b7-45529014f6c1',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'af8d53bb-3756-4250-a4c2-038745b98c34',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7279216d-8d26-4422-8b2c-efe853e80b7b',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hey Jude',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'da667a0b-ae52-47aa-b897-ece0f975614d',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1cb1b4fa-3599-48e2-ad73-35084481407f',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Dancing Queen',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '476f4516-6595-45ca-b44a-5f4dced4718a',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I''m walking on sunshine',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a2e221c1-89b9-49ee-abff-fc61fa522c4c',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6d0c2c0d-a3a6-4899-8109-901461972c92',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Hey Jude',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '343b9bde-ee41-4ad0-888d-45c7550f1a45',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3b8179f1-4ef6-4c60-9169-dca93586622b',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '57a4985f-da43-4067-ba78-1dd396c878a1',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Livin'' on a prayer',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1966de12-39aa-4288-9eb5-640dcaf0bbd7',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a9241170-8c9a-4950-b3a4-f3d2b6f075a1',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7915c423-671d-4e7a-95f0-501cffe42ddd',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Hey Jude',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7d94aba3-de48-4db6-a4da-a3db2fd8978f',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '48b2741b-efc3-46ba-b19e-354e53157fa9',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Dancing Queen',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b23d61b0-3037-49b7-95cb-fad809e6de6a',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6d1dcbbc-ec2e-47da-9346-721d1bc8f53d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Sweet Caroline',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ce6f4e61-22f5-4c85-9b35-19b318835373',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Bohemian Rhapsody',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '314e44f2-c142-4291-bfb4-8a1805a308d2',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5b95f315-ad3e-435c-853e-0bc2c033f900',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hey Jude',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0a13a012-81ce-4980-8e2d-978aef518acf',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Sweet Caroline',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b5011ff2-1742-457d-ac25-d8a8a7de1baa',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Dancing Queen',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '91471417-db97-49fc-9072-fc4e14a5da20',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I''m walking on sunshine',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '491e52f1-8658-43ba-8112-95fd9cf06275',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Dancing Queen',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1f2685f8-5cbb-496e-9a95-4b19668a6660',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I''m walking on sunshine',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '821b59a1-2994-4980-9ad5-f5a6e178631e',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Don''t stop believing',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ad16550b-84e0-47c7-a0bf-9886593ffe60',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '06eacc48-dce0-414b-99b6-f842722b1d88',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Dancing Queen',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c596326f-0ad0-490d-9886-0900443d46b9',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Livin'' on a prayer',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9f60ff4f-5997-460b-898d-09b628a6d175',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I will always love you',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '89ce5cd9-ef19-4aa5-9626-ad2e07c55beb',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8fb86283-1187-4c9b-9a6b-2ed30a54b376',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Hallelujah',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '771b7c90-962f-42e6-996c-6e3ef66ef48f',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3911447c-c1bc-46f1-87ed-b58387010c6e',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Sweet Caroline',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a53fc7e9-56ac-4fa6-8189-0e4ed52236da',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '47763bb5-9b4e-4339-a51d-203ec03523d9',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3ee2c34f-8700-44d9-b04e-80c1886639e8',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0b9e860c-2be6-4ffa-b889-21fe41e88c70',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '62ef6931-f5c4-4591-96da-b259a7be7e81',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b4834c34-d9ec-45b6-b711-7b88f6ba175c',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3f0edf24-350b-476a-9a98-da4e0ad0f652',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Sweet Caroline',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6b47357a-2db5-4063-baea-a5e4715ef8ff',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Don''t stop believing',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f9fb20cb-e09a-4457-9c31-4fcb243d7aa4',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Don''t stop believing',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f47df7de-6ab3-4851-84b7-53fba2982d76',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Shake it off',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '62c2036d-68b3-4df3-bd04-ddf78725cc8d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I will always love you',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bb59072d-10d3-4349-b5ae-9b59b3084c66',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hallelujah',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '11b31ac6-a74d-4a0e-ab80-9cccd26e7353',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Shake it off',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b803049a-cf7a-4229-833a-0638ee9899af',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '92927111-a34f-403d-9f2d-deabf975aa95',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Livin'' on a prayer',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '476718a5-7d03-4507-ba1f-2024815c03ff',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8d457012-571a-4d42-8d97-fcba76b2ef22',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bd36eca4-e7ee-4991-af14-a1cdb47d7750',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3d9ab3be-b615-4439-8e71-51964ea93072',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Don''t stop believing',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '89cf655d-4810-4a83-88da-3966f99e97a2',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Sweet Caroline',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '994e8c93-a0e6-49c3-81ea-108ff7efff90',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'I will always love you',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '80f9d6a3-df6d-4576-bc9e-5c97295f2386',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ad352547-818c-4c86-a4d2-f3ecadcf50ba',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Don''t stop believing',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3a63ab97-42b1-46a2-831d-9d9e5ad77e4a',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ef9d2679-0473-4973-ba7a-456323274b98',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '92b001f8-9d47-4161-930f-aea7da532db9',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Hallelujah',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ea4e358b-ccef-4441-9f94-ac4db8fe81ea',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Don''t stop believing',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd08fcfa5-3a87-4de1-8715-b87c8f1b3a4f',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9fd61f7a-4d2e-49ed-a710-c18ea7f8826f',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '67e73fcd-0714-42c1-a0dc-96bb71c87f5d',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Don''t stop believing',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b078011a-6731-4e45-ad4c-181d8fc13e59',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Shake it off',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ab366e96-9a2b-46d5-afa5-e4e8f3f6f16b',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '283abc6f-119e-4ee5-a2f0-a95b9543276a',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I will always love you',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '39c83dd0-8073-479f-9f60-63e7170754fb',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Sweet Caroline',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0ea1665d-cb99-4028-bea6-dda443cd15d8',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Livin'' on a prayer',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2c83dc57-1210-4664-a2bb-3dc70ba24f5d',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Bohemian Rhapsody',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '01957c46-9e1f-4fb7-9549-aa5cc6819fc6',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '83ded7e0-d808-4e34-b26a-136b960abb74',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5d962a81-fefa-4fa6-9de0-3b68420097e1',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0b375994-7e97-451b-922e-081c5aab253d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7c5f3afa-3074-4b09-b7f5-f9e93ba74ff1',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6f5b4e1d-3b8b-4d5f-8eab-03c68501a62b',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e49eb39b-8f04-4eea-b3fb-209019c1c552',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Livin'' on a prayer',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '36287a07-563f-4ca7-b3eb-0f5ee5f07818',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Don''t stop believing',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '383b9668-64ce-40d5-a57c-3c08a47b2650',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Shake it off',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ed63ec42-cee4-4c61-a5c9-7532a9986e12',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0e1cd9eb-24bc-4778-8ad0-e5d7a4e3a47b',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2e256daf-1257-481b-976f-3d0eb6123a13',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7a80000a-e84c-40b4-b185-0bb122a39a15',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hallelujah',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cfcb6d76-44d2-4414-93c0-49f485942094',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I will always love you',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '276bf05d-e9fc-4f57-b8bb-e4e8bd67bbca',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6f574026-0b7e-467d-a897-c6f9123cfeb7',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b89e6289-f825-4efa-97c8-b3dcefacf5c7',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Livin'' on a prayer',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a763c423-2af8-4dd8-9387-4b3bfa8db5a2',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Don''t stop believing',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a2511b4d-011f-4e1d-9133-771c3b850cfa',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c6dad2c7-f18c-47a5-b6e0-92da748a3787',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'I will always love you',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0d31ff0a-5c19-4991-94f8-04706234ccc5',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0deecf62-7f79-48a1-812f-9e9fdfa927fb',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hey Jude',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'be0a31bb-c0e5-46d7-84c4-f021d69d118d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Don''t stop believing',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'adda73d0-5999-4b64-8dbc-0fbff71982bf',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Dancing Queen',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '82db8912-0562-4b2d-b8bf-2acfb1391351',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Dancing Queen',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e192f223-7dbc-4b7a-9725-c8ed8db8577e',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '095bcc5e-2814-47c1-8946-64868438105b',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Dancing Queen',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a580c7b1-3bc3-4c88-b8a0-c4ed0889fa20',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Sweet Caroline',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5e75defa-1dcd-4e82-b088-a637e6d7b517',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Shake it off',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7894d584-710e-4e9b-a3bb-4883adc4ab7d',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Shake it off',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a703fe2d-3db6-421a-bc10-efcb906d8863',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4579bc42-9b90-419c-830c-fed808cece62',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3294dbfb-bb40-4a5a-b457-8213619ff89e',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'efc0ca65-3287-4b20-90d3-12f785b0d311',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fa243b56-7be7-42a6-b86d-b4ed925e6079',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Bohemian Rhapsody',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '88cf1064-cb0c-424b-8939-f33237eb5af7',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '31a682a4-cdc4-408d-b32f-28928e2d0d43',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Bohemian Rhapsody',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aa0a3c59-99e3-429d-837b-d75a519a9263',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'I will always love you',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5c574d75-e2ac-47f5-bb34-d9eb81f89d70',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'I will always love you',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8b24d827-005e-4799-b287-abb1f3316702',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Dancing Queen',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '500c444a-6bb0-42da-aa9b-1a4d6dbe49b9',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '83a4a459-41a2-4210-ab2b-8ea7b18fe440',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '86de29ac-8301-4a0d-be4c-875a5526c104',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Sweet Caroline',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f1009070-15ae-44d8-81d6-f0f30377416b',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Shake it off',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'db8323e0-6399-4da3-a127-9014ced8fcaf',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'db78ab98-4e20-4ac0-a459-b53250d54f7a',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Don''t stop believing',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9ee489d7-7795-48ed-8eac-10b9fdb89305',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Dancing Queen',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '96e8f716-e72c-4df4-b6c9-b6ef2dd57795',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Shake it off',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '688cd23f-3c72-41f7-a1bb-ff1423816445',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Shake it off',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd382ca84-9bbd-4b55-ae0f-71d13a6e79e0',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Bohemian Rhapsody',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f0e5e0a8-e24c-4579-8726-154b4601ce31',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Dancing Queen',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9c4bc4c9-8f41-42d9-8e48-5a12222c6e23',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'I''m walking on sunshine',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b71a9da9-e2df-4b7d-9bac-028c3d3e20f0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd9128d04-605e-4977-82fa-54e672638991',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c8b0fdea-87aa-4432-b242-3898230237a3',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Shake it off',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fe068a65-daa2-4e5b-93a5-740a57ca914f',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I''m walking on sunshine',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e3fd5f84-f6c7-4aab-b52a-39b2137fd14e',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Livin'' on a prayer',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '917483ae-f704-4188-9d66-db0773347a71',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '219622df-1348-4f9e-8e6d-8bf105f9c24f',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Hey Jude',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0f2b1d16-c246-47b2-b4ec-d3cce3c0e14d',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5f687de5-4014-499f-af55-f7c5eed28b7b',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3c7396da-e4ae-405b-9451-e3de3e7d5eea',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '415eecb0-d041-499e-8cd6-b53b52b08a52',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '609ec503-2430-482d-b1be-d0ae2cbae877',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd8fbb8d3-dce4-4851-81f2-24ad8716b421',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6bfb2aa9-6b2f-4258-8200-3510c9469eff',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Livin'' on a prayer',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2b1e1ddf-02c8-457c-871c-f54aea183086',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Dancing Queen',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd34a8aa0-5516-4f13-a2c9-1a5d3bd045d5',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Livin'' on a prayer',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0aabbcef-d7e1-45bb-ba4a-0d89b5f11696',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '030dadfb-beb8-4100-bf38-36fef6d1c93f',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'I will always love you',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dc57676f-e985-42c5-bb8f-fea6504fb206',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Sweet Caroline',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'abe709b3-d768-4cd5-ae98-43a8e5b60fe4',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Livin'' on a prayer',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4e52a257-9004-482d-93a0-fcd2a4182e71',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Dancing Queen',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4e166660-3173-4b79-a573-3edd7170a84a',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Livin'' on a prayer',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '58e41d2e-7fb7-4b0d-8851-4586907854e1',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Bohemian Rhapsody',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a7be9c34-f9c2-48be-9358-39cf1b153443',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hey Jude',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '96e32caa-e74e-4823-8b8f-28f0598d14db',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Bohemian Rhapsody',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd8e30d60-ea6c-429a-b96c-a192776b2a41',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'I will always love you',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9886c2cf-553b-48d9-9c18-33ea044f9976',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Livin'' on a prayer',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2f23ad53-cf97-49ad-a91e-c90f28f14673',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7c9b3877-a412-4a86-8577-b7c1eca79af7',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Don''t stop believing',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '774c6888-4604-4891-84ad-4ddd1831465e',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hey Jude',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6c868979-2efc-437a-9e0a-0fea218a4985',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Dancing Queen',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9a13683b-f1de-40ca-9942-5d8b188524ad',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Bohemian Rhapsody',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '07a21699-f496-4cc7-b459-e837e1bb0199',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5d5d5070-82f1-467f-ba68-3004fea11f6b',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hey Jude',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '461d54ab-b108-4b62-a3ef-71354935aa5a',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'I will always love you',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '11fd3906-eeed-4d44-bf6e-674f25a5d9d0',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Sweet Caroline',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c8704307-0b2b-4ce4-9f55-6461aafe0062',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Bohemian Rhapsody',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '941897a8-d861-4219-8346-cf1bb0a6efe8',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Dancing Queen',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f325f990-3560-42d9-885b-dd532684c1ab',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I will always love you',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'da6b48b0-88e8-40f9-a83e-010bd3869dce',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I will always love you',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8ce1153a-73cb-45fe-acf9-faac2f66daf9',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5830bc70-7fde-44ab-b647-0a1eec60be9d',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '390bba26-e5fe-416f-a855-c9136ed5ebd2',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I will always love you',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1cb1c7cc-65f6-47a7-a461-62d8c3afddd0',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Bohemian Rhapsody',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '116cb4fb-2938-403b-a71d-cf561f83eb98',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Bohemian Rhapsody',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '06e3f108-57f8-4e42-8a6d-53025eeac110',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Dancing Queen',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '28b343b9-f901-48ad-807d-99aab0889489',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Bohemian Rhapsody',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd2951d27-2d6c-4900-be5d-1ef3b6104470',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Bohemian Rhapsody',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '65e0d0a8-0bb3-4024-9d9b-e3d259ab7d51',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Dancing Queen',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3b96ed06-8c89-406e-ab5d-377e62e907c2',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'I''m walking on sunshine',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dd0844b6-8511-4f8e-ad33-80974fab72ff',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hallelujah',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '379c6e0a-2e9d-4ba7-a7c2-caa50131422a',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Don''t stop believing',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1fca1470-01b6-4f6c-9ec3-ab1604694195',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Sweet Caroline',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '352216dc-f38e-4f1e-837b-2a00cadf90da',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Livin'' on a prayer',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd2d0bdeb-0077-4bb6-95e1-20321e0b908e',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Shake it off',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '045bb93a-ff06-457e-a55e-693b74d8b2b8',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '18bc1966-7a90-4c53-ab5b-bb42b1168e66',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Bohemian Rhapsody',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5ab84359-d97b-4286-b45c-e332b4e23a25',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Livin'' on a prayer',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fd596a72-b5d2-4a6c-adaa-ce493e7161c5',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Dancing Queen',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd04adc06-62ee-4334-94c6-0c749f858385',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Bohemian Rhapsody',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f8d6c453-2827-4eb4-8a48-a0f721dedb21',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Sweet Caroline',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd7820086-f7d3-4339-9ad5-5bc953bc0316',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Dancing Queen',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'aefb05db-89f4-4981-bbdd-ba2f93761e67',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hallelujah',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '30a03b9b-b831-44c6-940d-4219593838d4',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Livin'' on a prayer',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '39c9d050-81c2-4ff9-aa12-c575c9f1e320',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c5adb0d0-bd7e-4217-8481-7b7576757634',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Sweet Caroline',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a9e46c2d-8b46-49bc-a401-8e420c90b130',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Don''t stop believing',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5bf46220-19a1-44a5-95fd-73e3b7163998',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Don''t stop believing',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3974c0dd-92fd-40d3-9447-2ee8e3cf68f5',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6477477d-25e7-4c89-b98f-607f9b7879a9',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f20e42fc-8a66-48bd-881c-fbea5ac12602',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I''m walking on sunshine',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '31eb4a37-0b14-419f-9635-e49544f8447b',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f4441081-418e-4828-81d2-bf769e6fd737',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '01129ded-9fd8-42f3-9988-2894e185e23c',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Bohemian Rhapsody',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f34343e4-fa82-40f5-82ad-0914e85122d8',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Hey Jude',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5f56234e-3f4a-4c3a-bb43-e76a1c8ebedd',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'bcb138ff-5246-47d1-a41a-8951af91e8f8',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Sweet Caroline',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c60d630d-4976-43f5-928e-384e0eb538db',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '58151f30-916b-4fd4-9ea5-10f86661a39a',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Hallelujah',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '77c49172-2afe-4cf6-a091-5724a0f67429',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Bohemian Rhapsody',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0654b911-4f99-44e9-b6c4-f783f5b98390',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'af3b621a-a5db-4f6f-ac9b-a8d097d18bd1',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Shake it off',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f7e568ea-73ee-4c8a-9e51-a03b4035e3a2',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Dancing Queen',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '6e730214-ef95-48a6-9e1a-ac74fd381905',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Livin'' on a prayer',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7735d5b9-afcc-444d-a428-02794ec55fe8',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '51c40985-3fd6-42fe-8429-38000502d110',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '96e14ca4-cb43-4be5-aee0-c693834e0afd',
        '3c02184c-b1f3-4430-912b-202415653398',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '172d2905-a65b-43dd-ae27-7067b06f45bc',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'Hallelujah',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c2d4e2e8-c408-4dc6-9fac-cff3e69ce9c6',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I will always love you',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '13eab5c6-20f7-47d1-912d-216d5e89bec0',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'I will always love you',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '371f0a06-e8ca-4edc-8bff-1d7d3f4bb193',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Dancing Queen',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8967ffbc-85c0-4dcc-b283-0d506880ee9a',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ba7a2ed3-d323-4422-bc64-1aa42ab05f51',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Dancing Queen',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dd95156d-2c92-4d95-866c-b0117562352e',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I will always love you',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2a14b1a8-f0ec-4406-9149-ffb6f04037d2',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Shake it off',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '042495e7-6ac0-4b7d-bc2b-b18675d6d07a',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Hey Jude',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '95f30215-4914-47cb-8280-e91cac24740d',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c8b079f7-23cb-4eca-b4e9-024dd0446fe0',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Shake it off',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2372a632-012d-43c5-852e-a5b12feb3cb8',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Bohemian Rhapsody',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '568a8e1e-36ff-4b35-ad4e-77fce0c6d852',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ac0a59c0-1b2a-4304-8a38-a7242be1332b',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I''m walking on sunshine',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c4db5612-dd31-4e93-8dda-848684c36576',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Don''t stop believing',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7a9d51b9-902a-4a02-b40f-93d4ccf235d3',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hey Jude',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b54f3dfd-04c5-4514-bc7a-68c9e9b806ad',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd8ea5ec9-3ccf-400c-b165-92b8f63e8112',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Shake it off',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '09d2748b-be7d-4d48-a1ec-9b099fa15567',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Livin'' on a prayer',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'dcb25478-d896-48f3-8d39-aa1db70e793d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Dancing Queen',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '85b7561a-b220-4e1e-9fe9-a34967024268',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Don''t stop believing',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5f278015-4b04-4e21-b7fd-2d77bb974352',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Bohemian Rhapsody',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '51288638-d385-42c1-aca7-837503e2bcb6',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I will always love you',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd43c59b1-1384-45a9-90d0-fafe192f7d6c',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Shake it off',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '5136a0c4-b761-4858-833b-1b635b9762ed',
        'ede635b8-afea-4964-985e-442928a9c104',
        'I will always love you',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'e260db4d-3bd9-4715-b5ce-964adfe5e9d9',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I''m walking on sunshine',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0aa471c0-ffd7-4b18-b267-295e3f7cbefd',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Shake it off',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '581bf812-9938-4a54-86d5-3a7e95dcc8bf',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        'Sweet Caroline',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2ec79962-d934-4f5e-b049-b2fddec3ee8d',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'I''m walking on sunshine',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2f223919-0079-49a3-8bec-020799acd7b7',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        0,
        5
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd8db93f1-8928-419d-96bd-34352e0c5e9f',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        'Dancing Queen',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '159b44e9-0cbc-4389-bbcd-2d22e7ef1d1f',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hallelujah',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2e18b27b-7392-42a1-9ac1-f71b887d7379',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Dancing Queen',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cb74dac8-5f8b-4fcd-91e4-d0fc7834ed65',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hey Jude',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7ebfbad2-a8c0-46f2-adf2-5a074dc85a2c',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '32b83c7f-0f9c-4640-b88a-5a61d56cb11e',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Hallelujah',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8359b7e5-ee07-4a11-b73d-dae0e76b29cb',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Don''t stop believing',
        5,
        10
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd8edf719-92ae-4644-bc48-8c5c4d5a726c',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Don''t stop believing',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0f04004d-38a1-4575-92b7-4aeaf5d84a6a',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Shake it off',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '08bd30b2-2dfc-498a-acd1-7b01b6b4355b',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Hallelujah',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ad33c5b7-c112-467b-b1ad-1f523c142895',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'I will always love you',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ade76680-7607-4bab-8659-8a7b2e05c0ea',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Sweet Caroline',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4c304741-8e63-4a15-9b02-327856b990f7',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Dancing Queen',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '09a508af-d5ab-4e0f-919a-0cce10d76886',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        'Sweet Caroline',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '640e7a9e-2598-498b-95c9-02e1a0c4cf27',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'I will always love you',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4c3cdc34-4c26-464c-9454-39cc526a35b8',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Hallelujah',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b265c77e-2652-4390-bcbb-b071bf3c2bf8',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Livin'' on a prayer',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9f484f62-fd88-4bb6-876d-4c1674a89087',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4bcce12f-35be-46ab-8ed6-0f307e23b8f7',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'I will always love you',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '13c2352d-0520-4b09-ad8d-20463848fcb9',
        '3c02184c-b1f3-4430-912b-202415653398',
        'Hey Jude',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '22fd8f19-3532-4b5a-977a-9c8190f81ea9',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        'Dancing Queen',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9f30f9ad-3b7d-4d91-aaf1-57737edb1096',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Hey Jude',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '62c802d4-b23e-4cc6-9b2b-02cb304b4afc',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Livin'' on a prayer',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '895fdfd6-238c-4a79-a8da-a9b4047f1c59',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Sweet Caroline',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'f73e1f21-0b97-4708-8158-d8afcbaced8a',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Livin'' on a prayer',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '7c7bc22a-44e9-41d1-b60a-749a711b1ec6',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '35c3f0f5-912e-4e5c-bc2b-a0a82cdef83d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'I''m walking on sunshine',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4a0dc6fa-ced0-4b85-9be5-2528deb00155',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Don''t stop believing',
        50,
        55
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'fc036aa7-898b-499a-a5a9-0543b416d87c',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hey Jude',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'eb6616a4-a6cb-4551-a820-6a50601c536c',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        'Shake it off',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '665029ac-aaec-4624-85cc-be43b8fc2e41',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Hallelujah',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '78550828-7ea9-4edc-bbc0-877782983995',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Don''t stop believing',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b03082ee-b75c-43c2-9aa5-0faaf26ee089',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        'I will always love you',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ec36347b-5098-438f-89f0-e4191eebd0fd',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Hey Jude',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd4dbd28f-7154-444a-aaad-bfa624bd5d76',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Hallelujah',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'b8cff51d-1836-4cc0-83a2-f7735fc55091',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '432dc017-9b7b-494f-a710-cd5ab3390a9d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'I will always love you',
        30,
        35
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '4fe43543-4713-4c8c-b875-bac5c3875463',
        'ede635b8-afea-4964-985e-442928a9c104',
        'Shake it off',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '2acda13f-ca90-4cff-982b-79433c8054bd',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'I will always love you',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'ecefb0dd-e8c5-4c72-9d09-13e425f791b9',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'I''m walking on sunshine',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '8a6c64ee-00d2-450d-ab78-c7bc93195cbb',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        'Don''t stop believing',
        70,
        75
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '470e715a-6498-492c-a80f-97b19e8789ec',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        'Hey Jude',
        25,
        30
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '98efc7b1-437d-4025-ac98-bcd7781900fd',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        'Hey Jude',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3d6b4cdd-80a7-4320-8689-5336b6ff7760',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'Sweet Caroline',
        55,
        60
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'd1838729-9f1d-4f13-9f08-640bf0be568f',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Hallelujah',
        10,
        15
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '9921e8cf-259e-451f-be6e-b1a8598c4525',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        'Don''t stop believing',
        45,
        50
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c1629813-d234-4e8e-85d7-cf103231347a',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        'Sweet Caroline',
        75,
        80
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'c675477c-4eba-48a6-8222-c687d285f4ac',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Bohemian Rhapsody',
        35,
        40
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '641b68ab-47dd-4273-a0ed-ec863bb778b4',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        'I will always love you',
        65,
        70
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'a1c8c4de-d0ac-4fb4-b7ae-66862da1ed0d',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        'Dancing Queen',
        40,
        45
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '1c3b11d7-be4c-4f1c-8692-10d3046a2fa9',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        'Shake it off',
        15,
        20
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '3ff2f122-4405-4429-80bc-01d23aae76da',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        'Livin'' on a prayer',
        20,
        25
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        '0976ed6c-39f2-4e80-940c-8d79c8f37f64',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        'Livin'' on a prayer',
        60,
        65
    );

insert into
    Lyrics (
        id_lyrics,
        id_music,
        lyrics,
        start_time,
        end_time
    )
values
    (
        'cf40cac4-8b07-465c-b462-f7fa7943bb00',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        'Shake it off',
        20,
        25
    );

-- Add Follow
insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e59d8bef-407b-4a65-ab11-458a6f719c39',
        'u006',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        383
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c6fdd137-f861-4da6-9142-4178ea858f89',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '3c02184c-b1f3-4430-912b-202415653398',
        420
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a92b17f6-fffd-42e2-b60a-1cd21814d25c',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'ede635b8-afea-4964-985e-442928a9c104',
        158
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a39c28a4-dbdc-4d61-aeac-9741aec738fa',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        326
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6810b306-3bec-4666-a6fb-ef14a523aa5f',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        354
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c8140989-c2ee-4401-bb40-c564c789b4ee',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'ede635b8-afea-4964-985e-442928a9c104',
        212
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c65c438e-1989-4cbf-b6ee-567e229c2ad8',
        'u006',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        143
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ba1144fa-6802-4d6d-b3b1-3e156707c3d6',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        431
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2bdadd10-58ee-472d-acea-49611765fa1f',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        114
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bfd6d239-5a67-4ef9-b93b-1a51bd860df9',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        215
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f43c3e04-fe1a-41b1-85db-a4dafcb30358',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        355
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '29c9e7bd-de73-4031-9097-ad3fef73a02e',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        467
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aca89a28-b429-4eb8-88c5-82bbe97c685b',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        220
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ff158d2a-59e2-4996-94fc-ff4496d8580c',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'ede635b8-afea-4964-985e-442928a9c104',
        105
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '96075adb-98d6-4225-9f1c-b195e7ce6c9a',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        475
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7d923d9a-58ac-4929-8ad7-016192c725f6',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        66
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fe733927-0dd0-46e6-aee8-28de2b2eb2d2',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        98
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '34bf2683-b06e-4d73-9dfa-81818adc133c',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        533
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ff9b0a52-5f0a-482b-aaeb-9c51540f9744',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        31
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2889d5a9-2b2e-4bcc-a62c-e990a7a623f3',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        422
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1c834f44-396c-4812-809e-e3de9a8fd4b5',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        114
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b07dd7d7-6d8a-46e1-b66b-e4a8ae29a230',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        369
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '685ad32a-53a7-4f00-99bb-462928583f89',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        274
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3f158c94-78a8-4df0-a96d-703df4501910',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        534
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '824961a6-4165-4fcd-a795-153cbaecea24',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        117
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6635901a-49e9-44c4-bff1-c15aa5815e89',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '3c02184c-b1f3-4430-912b-202415653398',
        108
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bf46821b-bc34-42fa-86a0-0de94a63d7ca',
        'u007',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        183
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '24469a33-0430-4535-8231-b1456f2441f3',
        'u005',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        452
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f3def852-6ed0-45f9-821b-34a760f5fad5',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        231
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ff9d7391-d010-4375-8388-da3f46bb3b74',
        '42345758-0d91-412d-922a-942b0700ddaf',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        74
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8e289a85-e341-4fe1-9fef-89b59a6b2100',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        440
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a9440947-b9b6-4e32-9d5b-63f2848c580f',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        598
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5d6088e1-2362-4882-96fe-0a42598c6ed0',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '3c02184c-b1f3-4430-912b-202415653398',
        153
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a68289dc-dcd8-48ed-be11-399d1cbfd062',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        84
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9bc45c55-bbdc-4b05-8f9c-114d9aaacf58',
        'a1943068-54de-433b-9281-cc8f239039df',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        362
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '49c001f1-6dab-4b8d-aa0c-1dfa8858db03',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        94
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6f0c43b4-6090-4da9-9635-d955f4dcb280',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        407
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '40e24aa0-1c84-4e5c-b05e-7e6610f3a1e5',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        444
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '227715bc-0425-4008-b5e4-d3820f414e0e',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        65
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1d17836b-aae5-4c0d-9ffc-fbab6a1298d5',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        570
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '277370be-5eca-4c43-9a1b-2cb11bbd29e3',
        'u002',
        '3c02184c-b1f3-4430-912b-202415653398',
        520
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd4e2177e-bfd8-4b3f-a26f-11e2b86cfc26',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        564
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a52ab6eb-fd88-4cf2-966d-92479b2d10e4',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        92
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '41a91eaf-62bc-46c9-8308-0c167eef05da',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        594
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '07de52cc-d14b-4b2e-8948-334c6bbc17de',
        'u004',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        40
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '26935ac1-89f0-4f90-ab2d-eea9837e363b',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        592
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '14b47cb4-c774-4c7c-b491-4678d96d01b0',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        223
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '94a33dbe-95fb-4e4b-8773-0ee32638583c',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        558
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '65a20378-8f7c-4d77-a11d-3ce3b093c199',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        418
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4a33e483-1ec4-440e-91b2-96faf1311416',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        533
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7be102ab-3b33-46c3-a057-93f791238db1',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        219
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '73849e6b-daf7-474c-8320-fc6664958534',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        122
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dfddd731-ab71-4c52-8458-e9b28e5ec5be',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        126
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f5c98720-cc0c-42a1-967a-a4048b6c9e3d',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        365
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '29a7d309-d6cc-4850-99ff-a1354b6101f2',
        'a1943068-54de-433b-9281-cc8f239039df',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        543
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9fc3d7d8-c23a-4a0d-8d2a-e01a1256265d',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        42
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dd33e17a-3d09-4162-b63b-bd965a0a0b53',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        513
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '552b18bc-c253-4a6c-92a9-0c4cf081aa9f',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        79
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b23049f0-e10d-4fbc-b9be-bec54cd8ba8b',
        '060adf54-6678-479d-a85c-2ffa48344583',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        175
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1ac8d608-0049-4ccb-abd8-2216a7005fdd',
        'u001',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        559
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5d8622d0-db36-463b-825e-623d5b33a2d5',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        432
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '90c747e3-019a-4f11-852a-8e835a621917',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        10
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1d6043be-5777-4a77-a2ec-001993ab8943',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        208
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a5370e59-2c7e-4951-8714-70534aa79f82',
        'u005',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        207
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c89016ca-4116-44bd-bf5e-5ec3935e5366',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        479
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0c463a42-393d-438f-8cf9-2087166781b4',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        484
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '54ac8a7c-3288-4f51-8b0a-9f686f46237f',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        360
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5ed8f71a-f271-4b21-83aa-68a14dab796e',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        120
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '602ad386-4465-4045-8d4b-b8ec62317b8a',
        '42345758-0d91-412d-922a-942b0700ddaf',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        500
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '76dd79b6-b4bc-4c75-822d-eb6c123e98a1',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        448
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2f671390-5063-440c-8380-9c35bdcc6c07',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        134
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dda2f9ef-f304-4ffe-942f-f9c678b4df43',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        547
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'efc378d3-4d23-46a3-8753-46dfc05a36d2',
        'u002',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        592
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '92865535-b376-4ed0-9ce0-d09fe0e714f3',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        487
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9cf249d2-020b-47fe-aafd-239e418ee1dd',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        469
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5b769efe-8277-4976-ae0b-4742e850a554',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        272
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2386a559-9d0d-4a35-aac7-6d634dd8bbee',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        438
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b8d1d023-04b0-41e7-931d-231d587a625b',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        78
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '506a9591-4dce-4ef9-b395-6e3dea5aea2e',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        '3c02184c-b1f3-4430-912b-202415653398',
        213
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '464c4238-377f-4e9b-8dd7-b2e140db2cb5',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        547
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5d684bab-b778-4c63-9b2c-013059d1da52',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        168
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c561afc3-2c8b-498f-ba4f-8b7ae560c44d',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        505
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e400a187-c109-4576-929e-abf5d17dec80',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        158
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e1f3d9f6-ac51-42ca-9369-2a35d90015a4',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        125
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8f6fb6ef-fdac-429b-bf45-6faf4b75c194',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'ede635b8-afea-4964-985e-442928a9c104',
        528
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6f4d8e50-558b-44d4-9400-4be4c2e46108',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        451
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e2084a43-a8b7-48bf-91e1-416374873657',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        329
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e29cc20c-bc80-4389-bcf8-40449efaf293',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        252
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e61d7c63-15e4-49a5-ac39-2ca30a5e115f',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        26
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '266c6634-92a3-4e94-bc25-822fdf25e4b8',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        171
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bcf78923-6fd1-48d7-9c40-1871899d6433',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        215
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '894bb4ec-2bdf-4396-86b5-42271a02d710',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        259
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e1d68098-b508-42cc-8577-e77df259f6fa',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        90
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '19dddff5-372a-40f7-a522-ffc7a456e3d6',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        52
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1801e19d-bdd9-4dbf-8000-0829a067b940',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        109
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2b2510bd-4d71-4dae-a731-dc16b94a10d8',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        461
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b93836b5-581f-4db0-8bb1-3ea9bee96404',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        448
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '254350b2-78ef-4046-9b8b-eda890a2ebcd',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        225
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '59d9e36f-9345-41c9-8c2f-ef238037d3fa',
        'u007',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        596
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6db10c6a-0054-4aab-92a5-c37f55cef7e2',
        '5beae775-0838-4778-8853-7f41275c0e37',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        263
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '37313a54-094c-49e3-baf1-2be833addeea',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        182
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f2b1b998-33d2-4a75-8862-7986d5ff9ba1',
        'u006',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        371
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'baba32c4-8ccd-4cc6-a842-e20bd524c863',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        219
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a9a7730b-0676-4217-bc62-6ec39ddc1b96',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        366
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a017da57-8cac-43b0-a16e-4b578116b02d',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        527
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f083a0fc-e077-4ad1-8fe8-af66f118a8eb',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        48
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '42c067c8-14bd-497a-9d31-b0ebebf21b6b',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        351
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '274e711c-83e0-402f-840b-b42686e88bda',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'ede635b8-afea-4964-985e-442928a9c104',
        236
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '54f175ea-f159-4fc4-a016-25f41ee01b57',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        26
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '52a8a016-8109-43e5-a2d9-1d6bb40f1fd5',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        324
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f293641b-1ddd-4009-b563-1f759504e88e',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        148
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b1b96926-9810-4634-bdbc-bb916ac9c4a5',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        439
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '894c2250-dc75-4f38-9c01-6e9771014a3d',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        541
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '29be677e-4980-463e-95b7-0fff4bbb7391',
        'a1943068-54de-433b-9281-cc8f239039df',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        162
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '91b0cf86-cf05-472b-9aec-d9576fc8a73a',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        128
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '59a34e43-00c5-4f60-9fdd-7a96fef03bee',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        25
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd1c3f798-c849-46b1-9384-1ef19e788c77',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        198
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e4f23953-efa9-4f11-acea-0bb4b0cf0e64',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        572
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b30dd939-6261-4299-9bc0-756fb6e76537',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        469
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a0fc69b8-fb7e-4904-97e8-a1a84fa784f8',
        'u003',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        388
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f1d01de0-0378-4f4e-8894-144c5ce4c0f8',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        430
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5b9bc15a-8cc5-44cc-a576-470c1615e3cb',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        496
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '474d4a52-cdfa-49e7-b610-ddd141450424',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        430
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5af1b107-38b2-4d04-a06b-c1ede027041e',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        413
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '454962cb-5552-437a-b59b-e9fdfcad1cfb',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        463
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '22ba62f3-a65e-46e9-98aa-f8d8c224026a',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        71
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e5ac6f9c-1914-418b-91b8-3e7184568aec',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        537
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '267dc261-bdd4-4e3b-9d10-332a05fa04c9',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        431
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7b93a598-df28-4e22-bc84-d66ff3bcb282',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        433
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd983ea41-6291-4a9e-98ea-b0bbf635b277',
        'a1943068-54de-433b-9281-cc8f239039df',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        568
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd8551908-c970-4bb1-b21b-1785c17729c3',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        478
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ad0f7686-0ab8-4de8-8f87-fcce9dbb2af7',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        77
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'eff5852a-574d-4b54-babc-621ab56b4d45',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        170
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ee71b4c4-bfbe-4427-adbd-dfa1df1483e4',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        490
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '819446b9-61c2-4d91-bef3-efa6e623d7ab',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        575
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9c9a44f0-6f42-429c-9085-405610e78079',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        531
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'af655f3a-1cbe-4b3c-955f-785cec1691f6',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        'ede635b8-afea-4964-985e-442928a9c104',
        378
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5d79b5b6-54e3-46b0-a431-00de619af644',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'ede635b8-afea-4964-985e-442928a9c104',
        482
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4ff4e094-3c42-45fb-a2f0-bf72cdb99ae1',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        38
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '850feb3f-3b43-4d42-9e6d-43b331377092',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        568
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2df9e7bd-471c-43a6-a99e-06b9a0e7bb28',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        487
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ebc3a213-a4f5-4a1b-b5e0-84489fa4b2d1',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        308
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c6e14712-0cb9-4be6-9538-ca82d7fd7fff',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        330
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7b315e24-6e80-456f-a38f-7a68c1350ef9',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        280
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7be66c2a-433d-4c8b-aeed-6927c045cd56',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        290
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6554221d-9c99-4d68-85b1-f9168d3647d3',
        'u004',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        481
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b4bac2cb-53a6-4e7d-8a05-b69117fa1441',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        107
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '827ef518-0c73-4229-ad4f-76b08c7823a7',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        200
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c7c65e2d-d4d2-43ce-bab3-2176bbfb07e9',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        515
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ba6eb565-f66b-4431-9476-80521053dbaf',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'ede635b8-afea-4964-985e-442928a9c104',
        239
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a24bf66e-3729-44d9-8ff2-1d1740321031',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        599
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '31ec6bc8-7e3c-4234-bc49-bb2ca9b61b7f',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        100
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '374ef752-1c14-469e-8b79-01c851ea4693',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        66
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4adf89ba-7fa1-4490-b3b0-b41e00de1dcc',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        56
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '02388e96-01b5-4501-82b5-4a46e6c68ee8',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        531
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4e87f19f-dc36-4352-b3b6-5839a02fa417',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        333
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4d7f0925-aa31-475a-8c80-23be28edf996',
        'u001',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        477
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ada0f40a-5013-4f3f-9b70-79b9cbf16b39',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        199
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ac48de57-8834-47a4-9d24-f05d01688e2c',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        89
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0d99a30f-f86c-4f5e-962b-cb5fd1bdc927',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        121
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c9889812-9982-4459-a46e-5ff407f0cbd8',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '3c02184c-b1f3-4430-912b-202415653398',
        528
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '822baee1-aefd-45cd-aac8-9b36292b7dc8',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '3c02184c-b1f3-4430-912b-202415653398',
        289
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8ed68e15-ff1b-40a7-ba6f-7295e6251a63',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        481
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c72d8313-f198-4f71-bf99-84135ebaedde',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        81
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c9c970ff-afc0-49d9-b523-53bb0322f6a4',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        430
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a301946a-3f52-434d-ab33-89506243967f',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        413
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '310ffa75-b1c8-4889-82d7-a2d7c9b6eca7',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        133
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7e938401-8281-49ee-a339-672aae2d1d5e',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        307
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7b4bce96-0fdd-4f5f-8c23-6c126ddc4f8e',
        'u001',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        450
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '396d1da3-2ad3-4e67-b5ec-de4a0535d9f3',
        'f5f5946b-2834-447e-937e-1587df58d305',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        459
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '199bf694-28d3-4628-b22e-64ab4ce22503',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        350
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1d0abfc6-c4d5-4c4c-8f61-7bca41558af4',
        'u005',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        354
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'da8b6963-c5da-4164-bbee-cc326fc69285',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        478
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'beb397ea-01ad-493e-a271-06db8cc4fd49',
        'a1943068-54de-433b-9281-cc8f239039df',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        314
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ba6c7bfc-36ac-4061-ba93-e2966c849027',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        544
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '52add6ca-3be6-452b-a014-5735aff6c163',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        38
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2cfbf460-fff6-401f-a9b4-d64efc1cfeb2',
        'u001',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        240
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e144104a-c88c-44f1-8e15-f6f3e870b2aa',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        301
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ee1b4978-9262-4a9b-bbbf-7f855c669514',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        345
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e509389c-c275-4553-a24e-66929a6f41dc',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        101
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ac97df6b-ee27-4214-8eed-fec246e08f56',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        437
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '56f4e962-1c40-4d69-b6e0-260b09d31194',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        59
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bc36d345-2d78-4de3-9971-b4a2eeb2d554',
        'u003',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        276
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3bbbc777-b394-48ee-8fa8-c5a95b72a2c3',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        78
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f973d511-3d9f-420c-937f-d2d08e38101f',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        130
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4684cd25-6442-462b-af74-abe2bbc923f1',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        556
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8eb4b6a5-6db6-4448-babd-864bbf9cfab2',
        'u004',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        578
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '16af0bd2-19b1-4454-832a-cf7afee907c4',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        70
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5b7dda78-4e18-4f38-b275-1cd38acdbdff',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        58
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0322c279-ae0d-4d79-960b-c3ab1c3defc0',
        'u001',
        '3c02184c-b1f3-4430-912b-202415653398',
        459
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'af4a2dd0-477d-4441-a546-4c2f0894ec94',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        432
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aab70227-6151-4835-b07a-95b17539d108',
        '5beae775-0838-4778-8853-7f41275c0e37',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        53
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3251db13-0e31-4a3b-a42d-8a148299a9d0',
        'u005',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        208
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f7af0cda-716e-4838-b92f-cd0be6e81ed9',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4dfd6c1b-4705-43f4-96ed-7c2f5c8fe4aa',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        348
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4c251761-fe4b-4872-9282-014ba06240fd',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        323
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c2ada34a-9079-4851-9b8f-5be46ff64650',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        571
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7194a52a-8c1d-4d04-82d3-8e6be925aff1',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        217
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a55e965e-7f24-4acc-8876-47a4d560ccbc',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '3c02184c-b1f3-4430-912b-202415653398',
        502
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4fde8b3c-d763-4347-ae9a-87885453ecf1',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        532
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '90e86e5e-5a4b-444c-9db7-5f1b7fffd40a',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        346
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd16a84b3-ebbe-44df-a4e5-53815b49884e',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        89
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c9512ac4-c619-45a9-a354-75ad281e9f00',
        'u006',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        481
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f28cae2f-c87b-4492-af4a-4cd1d9b02f4a',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        166
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '21ab6e3e-5e68-4482-96d0-b44695b10185',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        175
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2cdc5a53-af79-455c-9dce-1a5ac4a767a9',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        434
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4c707d38-0d42-4a23-801e-0cb956924a17',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        595
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd6007740-e898-4242-ad1a-3393a959a086',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        296
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '758968af-f792-4e06-9c16-a9249556d17f',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        554
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a6ec78cb-c118-4b1f-af42-a4995153defd',
        'u007',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        420
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2013166a-93ad-4031-afd7-b99c45189a8a',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        399
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b9c75e96-4792-4e1b-ae38-ccb92a0e6b6f',
        'u001',
        '3c02184c-b1f3-4430-912b-202415653398',
        441
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1f69c643-6896-4287-81b6-fa7d8cfeaa41',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        566
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '330a51e1-b5c7-4913-a5ed-01dd15c4e469',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        64
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '14c6efaa-e533-4f9b-b64e-199ec11831f1',
        'u003',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        412
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b948c4bb-fc5e-468d-b0e1-a493d4d80317',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        529
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '00eabe8d-39e4-4f0d-bd5d-ae20aa062dcb',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        43
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '79b3c0a1-e829-499e-a913-4df422dcfcec',
        'u003',
        '3c02184c-b1f3-4430-912b-202415653398',
        515
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c8bb1235-3741-4df0-a63d-f60b39fbb899',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        30
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a81fee32-808b-466c-9461-7b3aaddd9cf3',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        79
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b010def8-27ee-40ef-b582-4e2335d061da',
        '42345758-0d91-412d-922a-942b0700ddaf',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        441
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c14a8f80-66f3-491b-9a0d-eff6631ed31e',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        7
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2c1dbee6-423e-4609-9c73-63c29ef7ad8a',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        431
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2a84636d-826f-49e6-ae3b-3cb92b873ac0',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        342
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f088aa69-f7cc-4109-a518-cc057bfa1215',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        449
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8c3bfb4d-4f46-4c46-b23c-1994c1b814d1',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        276
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c316a1ee-1e09-4c1e-9b42-96ba3771fe35',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        251
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0bdca9fa-7347-4df8-9cc8-8500410c23b0',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        510
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b8e4ef26-42af-429f-be51-3382a8ec4630',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        568
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '28b08f7d-9ccb-4ef5-84b0-48fe17af4cdd',
        '060adf54-6678-479d-a85c-2ffa48344583',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        258
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '74fad7da-02ad-483e-8d4f-34def69a3a43',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        538
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fda7bca9-4aeb-4c3f-b293-bb9f640a2f0f',
        'f5f5946b-2834-447e-937e-1587df58d305',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        403
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cd5f5ce7-08dc-407f-b827-13aa6e607e51',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        361
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '54b1db3f-6b8a-47e3-b655-13b7f2d4f7ff',
        'u006',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        515
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7254f568-50da-4fb9-8e52-7a3f18967cc9',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        237
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8573cb18-5cff-4b4d-8203-6aac6e8bc0c1',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        50
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0be892c3-554f-495f-999c-9744f0616291',
        'u005',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        312
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '888f1157-56de-4c5f-9f21-1d9eae641ac4',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        592
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f9df3efa-e401-440b-bc67-a33ab91cd8d4',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        290
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8a20b523-2238-45ad-b8cd-c345d1d59c3b',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        412
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '88842373-08d4-4da3-b952-b930fc798b0c',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'ede635b8-afea-4964-985e-442928a9c104',
        192
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3372b460-e28a-47bb-aa95-7f7cbf91c704',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        248
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '455b9530-acf3-4c15-90d4-2ee06f985686',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        421
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1a89eed8-583f-4a96-a14c-d4d2eb3eced8',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        19
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '705d5d02-f5ce-4ee7-ac7d-99c03d74f291',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        436
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '881a6bb8-9fd0-4854-b4b8-b649c9eff230',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dc79701d-9204-4979-9174-e25123961819',
        'u001',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        355
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b88f342f-6c2a-472d-bc04-c5683cebc380',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        178
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aa2a5292-2761-488d-88aa-d6ab3c143bb2',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        24
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e9a936ce-d2a5-4636-a04e-73be1a46ec7e',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        547
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f9fb1e72-243f-48b6-bfd3-2645a324d5de',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        163
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b8adb3d6-ab97-4fd8-bb10-b629ac4a4280',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        303
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c77b670a-6beb-4285-a481-802cea09b609',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        78
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd5783441-f091-4afe-b359-41c500c8bc24',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        171
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c4551814-679e-40bc-9cea-72077ccd1aa5',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        372
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd3274320-4f85-4614-9470-44b896add192',
        'u002',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        101
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9afd348a-61d5-41ec-8174-18158ef014f0',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        522
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1effc248-b26b-447b-8eb7-0a90dea5201e',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        339
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dffbe8fc-8974-4d2f-af41-eaeb52bb8c9d',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        395
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f6913256-36f6-4553-95f6-372e14424424',
        'u002',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        21
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fe2880d8-f411-4c6e-90e5-75f4406a71d5',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        319
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2a9aa033-e87b-4570-a52e-96eed9b4c264',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        154
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f2736311-a55a-4708-a4cc-f3715f9b7d5c',
        'a1943068-54de-433b-9281-cc8f239039df',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        21
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '57fdaeff-e4ae-4383-a80e-db22d9184038',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        332
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9d46ff10-475c-418f-b82a-f0c6bbbb97d5',
        'u004',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        128
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c710ba2a-f4d2-4cd6-9008-339574c1598b',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        258
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '65e0de87-8664-41b2-b044-f66d6ea88a55',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        239
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4c481ec3-3d1f-48d7-87d1-11ac3cc87270',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        467
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '167c5d9e-77fd-4bd3-8145-a22d4de917bc',
        '42345758-0d91-412d-922a-942b0700ddaf',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        396
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b7124bb7-b884-49ea-88c4-75fa8364b44b',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        376
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd8151891-f065-4803-aa3d-a76a83313ff9',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        155
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd0befa54-8c0d-41c4-824f-e9a1b6cd3020',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        485
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8b5e747e-0723-4580-bddf-cbce7fd7ed97',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        '3c02184c-b1f3-4430-912b-202415653398',
        36
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b3e6011a-eef7-4a72-a3a9-513d831cb25f',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        196
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '29eb432a-039c-4eef-a355-1cf78f86ffca',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        57
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c8e8e7ef-e58e-4923-b889-ddf71d3288c2',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        167
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '488b0459-59e4-49d3-8325-503912a88353',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        177
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cb0a53bb-fa1e-49b9-8df5-0969d42f1dd3',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        388
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cbefeb76-1d90-4400-93b5-733882d4fca1',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        385
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '57963f5c-9d2a-44df-8e18-5add27b1866c',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        114
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aec9c899-5783-4d80-b966-cb296d19104d',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '3c02184c-b1f3-4430-912b-202415653398',
        498
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '52926f82-59f9-442d-8e65-ef941662a48f',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        162
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1be91a00-2595-4cbe-86d8-e35f2d10fd34',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        390
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'eebf8ada-e1d6-4dcf-beb9-13ef2908160e',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        133
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd39283a9-afb0-4134-b2df-aa3c2593e216',
        'u004',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        172
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '18ae8043-66ec-4ed8-9685-2c177912416a',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        597
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2c7cfe13-0a85-47b3-a006-ab633e9065c4',
        'u005',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        348
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '72cafa3c-0515-4665-ac00-f80682a70123',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        451
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0d0bbdeb-e438-475d-a8b0-47eacea8c1db',
        '42345758-0d91-412d-922a-942b0700ddaf',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        1
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2868b430-9218-4921-96c8-a1d0e8b55755',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        164
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '69c04c73-9e07-49df-9753-24b24dcb2be5',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        215
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2f908233-b4a8-4ae5-bc89-9946c320a1f1',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        11
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f79359a3-ffb3-4181-a121-8a5435e9371a',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        289
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3b84cc68-f57f-471e-ba8c-5e537bab7d23',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        141
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '43704770-35f0-40bd-af30-38d32a56a7d1',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        '3c02184c-b1f3-4430-912b-202415653398',
        205
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8473cd5f-03e4-4479-8bef-f716e54723e4',
        '5beae775-0838-4778-8853-7f41275c0e37',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        331
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd0db06f3-26e0-4180-ab9a-70bd05570952',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        526
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '78e1cc48-5af8-44a8-8188-7d76d558ddd3',
        'u006',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        192
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3241ebc3-3443-4825-94ba-100eb79dcbb6',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        '3c02184c-b1f3-4430-912b-202415653398',
        510
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e63b1ea4-f785-425f-8935-bd8f15a9d8a1',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        241
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '351da58a-8448-4c7c-bcde-e98d94bec9a0',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        211
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b4c1cad7-81fa-46b9-aa51-fefb8383a562',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        286
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '95c9bcdb-b499-4bf4-abca-dff0b12cbd18',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        236
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5a5505cf-39e0-403a-b997-fa7cda053bf2',
        'u003',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        406
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5b2196a9-dfb1-48c1-8f80-c8ae73fbc0d5',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        43
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a44760e0-c61d-4215-8366-781f1109f969',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        373
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '546ff56d-8431-419e-93fa-9f66dd42584e',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        365
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0f2fccf5-6c8c-45fc-8de7-f33fd9c026b3',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        351
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'abf8c278-51d3-43cd-b779-606dc8f912eb',
        '060adf54-6678-479d-a85c-2ffa48344583',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        400
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6673f053-3644-4fd2-8ddc-4283df6c8d93',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        550
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'af93ad73-9695-42d2-abdf-8557054b69d3',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        5
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3a2eb93b-8edc-4385-8e7b-9e348ba6a92f',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '3c02184c-b1f3-4430-912b-202415653398',
        453
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8218f992-8e12-4463-9bf9-a48453339c7c',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        56
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9b891570-4cd8-49b2-9500-0dc7c9096ec8',
        'a1943068-54de-433b-9281-cc8f239039df',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        562
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '45417239-9ad9-4e80-a7f7-6883c27ada9e',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        187
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '70c6e7f0-caf2-4abf-97bf-15efb1199729',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        442
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6195bb9f-1ed3-4dfe-b495-c499bbd7147a',
        'u002',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        255
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd958d7f8-ea45-49a9-b63b-0fb5088dcf9f',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        322
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd461697c-274d-42e8-b740-83498ea0f39b',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        566
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '638282e0-73a9-4007-b2d5-087df9167b71',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        411
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '702ab748-2ad6-441d-b1ba-370be6ef4e46',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        106
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b8a176d7-7c20-44ed-bb2b-79427a4e4b9f',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        498
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '78e0e479-873c-4452-8404-0dfe094a5d7f',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        594
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2639773e-8d62-4a92-b620-760fd5b9ca57',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        4
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e61c34f5-48f2-4e0b-bf86-85ea2bb4249d',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        543
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a328cd3a-9b96-461f-93a1-2a7757caa981',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        156
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bd4b6157-535c-41e9-a5e4-0d89b2cb4ca8',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        115
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '822b2cb0-5e0d-4d65-ac5d-6bce44bece23',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        313
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '55f0857a-b808-4b56-bbaf-431dc74fa8cd',
        'a1943068-54de-433b-9281-cc8f239039df',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        4
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd0681232-a343-46a4-8ba9-b6d3c94e26a6',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        524
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3b06ca4b-4add-4f34-806b-d2c5e14c145c',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        302
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '92dda031-9860-44f6-9478-2ba06eb34f18',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        379
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2faad6fd-6375-4a98-9f0b-247a2380618b',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        407
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4ed4e629-118f-47a2-b140-af09be0d7645',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        488
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '128e68b8-66d8-4af8-8323-a144eb514f2f',
        'u003',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        89
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f1224e84-a60d-4420-b22d-f30ce3eb3830',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        482
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a92493a6-ea13-445e-af58-b66cdba51e36',
        'u006',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        553
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ab9580bd-b2f3-44bf-b827-efc301750b81',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        486
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b532dda7-360c-429b-a44d-b1e47443c489',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        551
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4228ce4a-f024-4297-98a8-42a9c1f231a4',
        'u005',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        549
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1002da76-4657-49a4-9c87-c65363d8f9a8',
        'u005',
        'ede635b8-afea-4964-985e-442928a9c104',
        7
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e9170393-be35-49f7-9a1b-b8a914d9591a',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        35
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd7abc9a0-8586-464e-a0f4-89c7f9300ffd',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        333
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '670040fb-3195-466f-aab1-2ad447a9165b',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        283
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '62a6a713-0c2e-459a-90a4-7b5de1674fb9',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '3c02184c-b1f3-4430-912b-202415653398',
        188
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '59dd7255-6b33-4d38-860d-8fcb17ada05a',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        500
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c5aead8c-28f4-48c1-9414-d50a8e2af48e',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        513
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fc9a9d2d-0e2d-4bc6-9d49-0341b2354dd1',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'ede635b8-afea-4964-985e-442928a9c104',
        390
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '464c55d8-1e1d-4798-b117-afabb65ab773',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        170
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '52d7446f-ed5d-411d-9a06-8037f34f42a8',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        74
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '30f8c042-f727-4706-bf48-6cdf3b776984',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        499
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9a19fbe1-7e7f-4f02-8f67-ab229028e271',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        205
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '63e4431e-b402-4d8d-86ea-18235ba172b1',
        'u005',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        597
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c75b7085-0fb1-4514-bdc1-02922d407a4a',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        560
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8ba80044-9627-4c58-9dba-944d18725ec1',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        398
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8c4060c1-9a68-4fbc-bf1d-cb69f4ef726d',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '3c02184c-b1f3-4430-912b-202415653398',
        505
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3fe2bee7-1d14-4482-b7f2-fe38a2a8f2c2',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        3
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '19cca09e-84fa-4136-bc0e-ce0bf7d6ec64',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        455
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd8ab683e-4534-4540-bb44-88b908838f22',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        195
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '67c55e0a-d445-4c0f-9595-4aba9889adb3',
        'u002',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        361
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3f69a46e-f4a1-4afe-9e4d-ede61df97706',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        '3c02184c-b1f3-4430-912b-202415653398',
        138
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f648c5e9-7b86-4bbe-aa5c-9359d70be9ce',
        'u007',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        599
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd3c4eb5b-2cf7-4f27-a802-536d635b26f5',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        49
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '43f174d7-1b48-46a8-9882-035ba1f1f548',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        27
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b9547d65-ca2b-473f-a2ae-6395089f0c72',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        582
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '24151681-31d5-45e7-8776-82499e3a0743',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        297
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8c1c0d2d-1701-45f2-80d1-03417042d39e',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        37
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '30df6649-f151-414b-9d26-ab7afaef4285',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        538
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6a6114b6-ea41-4c91-95fe-5cf072fb970f',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'ede635b8-afea-4964-985e-442928a9c104',
        218
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '089b50cd-47a1-4007-a7ae-effd2f0e1b3e',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        422
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '796b2f79-4ba9-42e0-bf6e-dfd1f2e52f4f',
        'u001',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        528
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0c46a8e0-3d9f-48c3-b6ca-a173a43ec3fb',
        'u004',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        503
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '41a60445-6da2-4aef-9c38-c445c2f13e9c',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        546
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd6714801-7a15-4902-a50f-2584dde2e893',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        447
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cac15427-8521-4d03-a135-bdfea03ac57b',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        163
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd1abb682-7cc5-4cf8-b4ab-c34aa2a10db1',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        69
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3ffecf4c-35fa-4c5d-862c-f3e3bd8ec4ec',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        105
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '899bf264-6d44-479d-addc-10c357061efd',
        '5beae775-0838-4778-8853-7f41275c0e37',
        'ede635b8-afea-4964-985e-442928a9c104',
        141
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '15632ad6-d679-4429-b0dc-3e60883a50a2',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        532
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '480a4bd5-5d7d-4f57-93ee-d1aa25da980f',
        'u005',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        62
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '10ea4fd1-4dd8-4b31-adea-0bbb6ef36b1f',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        435
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1c983403-e07c-45f2-b299-715578866441',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        403
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ce8bd44d-f5ec-4339-bcd6-17b39b025178',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        517
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9227fcb9-9954-4475-99bb-c3be0d5d41a0',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        382
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6abf5d7b-843b-4570-8884-10c3406fba73',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        218
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '73e610bf-03c4-41bc-92b1-2df1f2c81777',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        86
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ce2391b5-e1e4-43ed-a3eb-37d4f436a7d7',
        'u002',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        520
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b879a13f-7097-43b1-b5f4-aa0fa5c22b48',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        207
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e4e71db8-b282-423e-abe5-19278f18860d',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        130
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5163f98a-59ea-4f29-9a52-f33d376ff9e1',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        566
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c594bbed-c343-4cc5-8437-f656d5012520',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        517
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '42771ce7-f5cd-4a3f-950c-806d7b6fe990',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        473
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7b22fa3c-6884-4f2e-b6f2-e22122508f09',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        39
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ac760d8b-d8ec-4b74-a099-2becb0e4a321',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        416
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '099bf57d-13a0-4a44-99b5-d4c87839827f',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        459
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2f00368c-62a3-4eb8-a359-9b15dc603d66',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        175
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b2c2b7dc-372c-4d90-83ba-d193ef653f23',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        254
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '96bad436-751e-41e6-b21d-5e34c9736db5',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        532
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '68642b0a-242d-4648-8d17-6ba889b9f95c',
        'a1943068-54de-433b-9281-cc8f239039df',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        177
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '80240fff-95c1-47bf-92d2-2158caa291d1',
        '42345758-0d91-412d-922a-942b0700ddaf',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        317
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '29839f3f-0955-48c1-9a2d-fc71d7beb1bd',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        304
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c48d36bd-9549-4938-9fb5-90e95b95c2df',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        511
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2e8fe8ab-a5e6-4186-b00e-c8e33ac285fd',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        92
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9c3179f3-3a1d-40f5-897b-7e2f76c9d42e',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        333
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0262cf84-70ba-45cd-b3d1-97f058daa473',
        'u002',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        85
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3f65a90c-0304-4e85-8d08-9e0dcaf572f8',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        181
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6f39c3e0-6e71-4b72-a1cb-16306f99140c',
        'u001',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        187
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'deff0178-cee6-455e-baf4-4ec3f741ae5b',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '3c02184c-b1f3-4430-912b-202415653398',
        315
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5a90b694-0161-48c6-81b1-60e9bdb9ba0c',
        'a1943068-54de-433b-9281-cc8f239039df',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        235
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4e119a15-0cc7-49cc-856a-bbb585eae80e',
        'u003',
        '3c02184c-b1f3-4430-912b-202415653398',
        557
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1b4a80bf-44a3-4a71-ae81-2b83d30c2e4e',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        481
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9eb0de10-ca9a-4e4c-973e-3d9fdb198fce',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        443
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0038b377-79bc-4d67-8891-160210b47625',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'ede635b8-afea-4964-985e-442928a9c104',
        254
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f9e1d4fc-b350-4d59-b68a-54650b0316be',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        419
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8935495a-99c9-480f-bdc9-ed85b2c9981a',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        568
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f8a42be4-3e74-4dee-b0a3-a4a7db5acac4',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        280
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '55040817-b839-4d34-a6b6-5e7c387e2be1',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        201
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ef431b5c-937a-4d0a-a374-38e53ab8a6a0',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        297
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '65c10fcb-eccf-4ad7-954b-be071a5b56ce',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        454
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '04c88239-caab-4839-807f-10b46edebc62',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        550
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '806246fa-87e6-4578-9ba4-353ce61848fc',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        233
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '39633a0b-cbe8-4a14-83d3-4c4adecbee3a',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        134
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '74bcbf4e-a88d-4a0f-9065-12ac0550542d',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        504
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e28c63a6-9319-45e2-a1ee-d3446b9d1f39',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        242
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '20181c2f-c25e-4d2b-8bb1-2a1d23166f5d',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        455
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '32d3ccde-126a-49e9-b5f6-d05e0df86d2c',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        501
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4fcafd3c-6eed-434b-a715-e024e3786c0e',
        'u003',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        143
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0a7a5201-8c62-4013-81cb-9623e66cc079',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        2
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd4ace34a-1ffd-48d5-8c2c-a613d8e66fd8',
        '42345758-0d91-412d-922a-942b0700ddaf',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        277
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '67af0bb2-e9d4-48c2-9982-72f076307c50',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        105
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fa0503b6-9426-4c58-9a3d-ece1e26d89ce',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        105
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6f53a292-c3df-4aed-a838-130d466235d9',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        31
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '51f58e28-301e-4605-8fa8-24952c647795',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        127
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fea091e6-5375-482c-9ed9-da72d48ab9a4',
        'u007',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        263
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dfee6c19-aa07-45b4-bb69-0fc684d39f96',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        240
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c8dc302c-02af-44eb-8d1d-e01511fa65f1',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        196
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '33164508-439e-4baf-9af8-2f49c05a685e',
        '42345758-0d91-412d-922a-942b0700ddaf',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        367
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1e11528e-aa99-43f3-9b2a-ffea75b389ec',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        277
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a0ff920d-31c6-45b7-b991-ce67881196b9',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        '3c02184c-b1f3-4430-912b-202415653398',
        492
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '49d6c24c-79d4-4000-ae39-0473e956a12e',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        592
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '91354acb-9844-4367-8693-ec4af73bb792',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        440
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'eb10592d-a2d8-4580-8935-affff96cf909',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        582
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c491ea8c-2045-4972-a639-3008179fbbd5',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        319
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e663c042-7baf-4a0c-a903-f3abb9fb3604',
        'u005',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        176
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a95092a0-8ac9-4883-9729-ddaea27de169',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        17
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '294c4f09-ef2d-4d39-b804-bfb9119dcca9',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        533
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c8525c8f-f233-43ee-917a-69899463e6e7',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        18
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b0c0cf07-1602-42c7-a022-0afb2b5e69c7',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        189
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f4dfb106-f93d-4035-9b08-c4f648442b07',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        426
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9d21f13c-df78-4c65-a6fc-62a30ae02566',
        'u003',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        516
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '815fabbe-8dc4-4eec-b3d2-cdbe34946310',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        75
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0c830f8e-a1d5-47a0-ab49-9f7cf8e54246',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        427
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '65141c97-4b98-4b39-8ab1-03a15eb02ae3',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '3c02184c-b1f3-4430-912b-202415653398',
        111
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ebae8ee9-9d79-44bd-81cc-b5288f0e7209',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        0
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2dde230f-a908-4724-920f-92bdfaee3aea',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        548
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '42dc334b-baac-4f3d-9384-43e12571aa32',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        61
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5607ce77-7816-480a-9161-18bb04c8ce6f',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        400
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e6bb2235-4e23-4656-99df-ed3b27dea85a',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        57
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cd6c283f-884a-40c1-8553-6fe5afe323c7',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        221
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c87b63ce-f37d-4486-a201-3bb873665430',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        6
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5de3f838-e097-4471-826d-9b7e13871298',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        258
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2e6fbb45-7b3c-4ccd-b627-b8fae5ac4b75',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        156
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '57eb7e73-ea80-4982-8671-fe5bf6cb1c03',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        423
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '18e20d95-69cb-4fd9-a5ea-2bd5702b3f0f',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        119
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5b003497-6a43-45a0-8559-348b6b7b0f04',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        454
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0db5cacb-666d-40ce-b0ac-a076b446da60',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        316
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '997c224e-19e0-4fd5-9f45-f89fc647537c',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        138
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '92108f47-79d2-45d4-afe1-f9545e791117',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        518
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bc48e650-e4b2-4489-bc07-f2d0271c5b1a',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        547
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '26c0eb6e-8d2a-4d6d-b47f-3a981604ca42',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        117
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '932c7613-8bef-4b18-836f-3d77d2a3585f',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        233
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1cb7192e-a24a-42b9-b6c4-15f68d61fd13',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'ede635b8-afea-4964-985e-442928a9c104',
        550
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cb521842-2c16-4f82-b3a1-40c669d1f3f9',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        193
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aed3adf0-77b8-4fb8-880a-d83d2d751999',
        'u002',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        497
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '531db8a8-7437-464c-8e6c-8401c110ec47',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        265
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3f6c7da5-be4e-471e-8c65-b0726b10c4f6',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        266
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1d0d69e9-9f77-4a40-8110-14ee63660936',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '697b66f0-608f-4ddd-86a8-df3dd4f7fb2e',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        103
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2c9ce5d9-201f-4c3b-a884-a1efa277990f',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        474
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '170d78fb-7bc4-481d-9b08-54554818abd0',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        188
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2936d32d-cd3c-49cc-9eb2-b0b7da0c9c91',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        163
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '17f20dbf-580d-4503-a585-11e66a5b4caf',
        'u001',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        250
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7a96fd27-98bd-46b6-88e3-2c2053b306d9',
        'u003',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        309
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4c2d1500-f1a6-431e-a511-dc4eb98d877d',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        161
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e961dda0-f5ee-4648-ba77-9af7da9f2dc6',
        'u007',
        'ede635b8-afea-4964-985e-442928a9c104',
        72
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5734ceee-2459-4bf9-aacf-d1fea21c3f30',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        194
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7f61c9dd-b834-4f12-8836-55b1f72667c6',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        61
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd9d9bb7d-ebe7-4b58-8156-94db518f8d26',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        439
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5ab1e745-0e14-470b-99cd-074b0be8c393',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        77
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8be1ddc6-5156-4da2-b7ae-c7fd35e815ad',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        449
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c39cb1de-a2e8-4c25-b241-3cd61b3e9d18',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        573
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c2741311-6a3c-4c60-8009-de7a79ef3845',
        'u007',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        191
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e6a946b1-c55e-4223-b1fb-4fe660e9bc02',
        'u004',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        105
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b5c68bfa-1b89-407b-af17-3f01b611ff45',
        'u006',
        'ede635b8-afea-4964-985e-442928a9c104',
        42
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '203ab81c-7891-4875-a1fc-e6609b7982c9',
        'u001',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        214
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8468270c-e4f4-4f0c-84f9-66bd32cd0c28',
        '5beae775-0838-4778-8853-7f41275c0e37',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        421
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '27c1c83c-a964-4c1d-8eea-a69ad7fe9a31',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        428
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3deec2bf-5bd0-456c-8e74-985f3ce9406c',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        98
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b2193864-9912-4ce2-9bfb-8b832143af8e',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        16
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c8f0855f-9c54-4b9d-8f58-094b3487e822',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        338
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '01cb2b3a-888b-462d-b836-9cd2307ed1fb',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        419
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '39472121-89b0-4607-b565-cbceafc3d24f',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        567
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '72bcef52-f44b-4d07-94bd-ea39cba33d8b',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        293
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '46d278fb-5a71-4f2c-8e2d-e0cc34787eea',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        132
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '75acddb7-6f46-4cd0-91c4-aea3bf90c895',
        'u003',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        298
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0a9e5a6c-f229-49eb-8629-dfb4123c746b',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        308
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '34360b63-43d5-445b-ba02-d59ff1176d35',
        'a1943068-54de-433b-9281-cc8f239039df',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        221
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e5539a13-a499-45ae-9654-aa9222c5e415',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        407
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f1d23650-c41a-40d3-982f-24cdcd3df0f1',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '3c02184c-b1f3-4430-912b-202415653398',
        486
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e2744e87-81e7-4d88-a019-9389aa81e134',
        'u002',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '29927b45-8001-47d6-ae72-0dede334ee53',
        'a1943068-54de-433b-9281-cc8f239039df',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        519
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '36ffc3ea-99b3-46e7-8a29-d20746c12041',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        52
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '91a5ef6e-60a5-47e7-91b0-f5efd5f6cee0',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        294
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd1d36069-f44b-4738-ad5d-0812ee1c8b46',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        593
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6a098fed-a960-4d92-af74-a698757b97fc',
        'u007',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        297
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6449990c-4612-466d-809d-6e9512a92782',
        'u006',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        439
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e274be0f-eab2-4757-91ed-6a04d1511459',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        374
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8f20f8e2-16cf-4b3f-8f6a-28ca1524f735',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        122
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '99fe2641-2d94-47d9-88fc-a01258d0b973',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        401
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8f1bf5b1-781a-41b9-a624-f74a04d3b663',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        162
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd0ec0fed-bebf-4260-8717-c2158b2b1233',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        238
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '615327ba-d55f-493f-ac54-70e2c12d4ad0',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        275
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '61b70c1d-2218-4ae0-9596-8a84781fe2c0',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        'ede635b8-afea-4964-985e-442928a9c104',
        213
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ef0f6e0f-37c9-4ec3-8d32-3fbc0b632e21',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        529
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f03a0e79-39fe-4452-9180-5b5d5204234f',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        434
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e6411f78-8020-4ff6-9426-2ccee35ec53e',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        569
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0ba13e2a-48ea-4d79-bbcb-03285ed40bf3',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        29
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '58dba457-4e1e-4065-a9f6-e43fc1fdee60',
        'u001',
        '3c02184c-b1f3-4430-912b-202415653398',
        493
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7c2393fd-d6f7-47d6-aa56-34c72e00a41e',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8b83f152-58db-4a18-9659-0ce65755319e',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        458
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7e2c808e-bbed-4040-8a0d-48e5a3cef090',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'ede635b8-afea-4964-985e-442928a9c104',
        126
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0e409132-acd1-4ad4-a107-b190f9b12ba3',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        232
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1998bfef-b118-47bc-af64-66f83134d505',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        206
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '842d6b15-aa0a-4021-989b-1d84854d9356',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        476
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2ebc783f-25d2-4925-afb7-a88fe334dcf9',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        56
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '122f4f2a-ce34-4a50-8c8f-a95bb809498d',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        594
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '42298ffc-f543-42d8-b091-839d274a135a',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        151
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e3a4f1ee-1146-434a-8b3c-aada3695568a',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        461
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3e075145-da56-4c5e-9ce6-16d83a8a006c',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        539
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1abcd129-f3c9-455a-8fc8-16d7b3dc5385',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        334
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bad3f12c-4eca-419d-9624-bd6f923cce28',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        404
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1f70ca3d-8488-4178-8d00-5bbb9d26fcc2',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        143
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '458823af-60e1-4b44-bf01-3cfa6070e0ae',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        474
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '15312e8a-0275-4232-9dcf-f87a25e4ffd6',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        219
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c75ae253-bdb6-443a-8cd5-104057aa82e2',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        507
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5d5dcc79-c03a-49dd-bf9c-35497e938018',
        'u005',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        269
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '32ca7be2-18cf-4953-b698-1f78a4d5aaf9',
        'u001',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        233
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9458f2b3-d31d-4410-b4f3-bd6c4bf406c6',
        'u004',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        223
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7508edd1-85c8-4095-812f-4616a4655607',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        430
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9cf0e7f8-2942-439a-943e-3830ebed99b4',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        85
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f5120c00-9221-411f-9fdb-cdf96389efc5',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        353
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ef74e1cb-9bf3-43a2-8cea-f2bc003e3d7e',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        363
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '03f67ddf-92d1-49d9-b3e0-3fac646ce494',
        'u003',
        '3c02184c-b1f3-4430-912b-202415653398',
        165
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5792e810-579c-4594-8221-6617bd9ca44d',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        152
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4b0c2870-fcfb-4c5b-add0-3d85e83e98c6',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        226
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5daac75e-e741-439a-aaca-16aec7b40d81',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        481
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a054564c-f0b2-4225-a2c0-6ca25bf5886f',
        '42345758-0d91-412d-922a-942b0700ddaf',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        11
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bd171f40-25eb-4734-b7d5-0f0bb864e5ea',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        95
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1fb719be-8886-4606-bba8-c96957b9a1d8',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        217
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '576c0338-f688-4c7e-b8f5-343d43bb5f1b',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        573
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '028ac07c-747f-40c5-80a8-abf05b0ced91',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'ede635b8-afea-4964-985e-442928a9c104',
        61
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8bb4b04a-b9e8-4963-b3f2-cb1e05bcfc0a',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        445
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8d4e23ea-9146-47d6-8930-96da250c272b',
        'u004',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        576
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0c1fc0c4-147a-49d5-a78f-2d4d775c9c08',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        184
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1a39d0e2-4a06-4398-b511-32226d9a2a7b',
        '42345758-0d91-412d-922a-942b0700ddaf',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        256
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bd96538f-4b6e-4195-bd72-39df280c5383',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        308
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '774f388f-2c46-45c8-a0a0-63beed5356ef',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        522
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7be0ea97-4e5d-44d0-be06-6a6fd76e38b6',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        500
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '91cd7cbb-a7fd-4989-9a54-c8fc17476ad3',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        417
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b6551a95-ce65-410f-9484-e917e7ef1a40',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        539
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ab167a7b-9b5d-4162-924e-4fc5bc0f2af0',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        330
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '56cf6136-9c63-4073-b231-7befa9b78fbb',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        214
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5f4fa974-553c-4e71-b583-a3e956fa608d',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        451
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6bb92b48-e292-4f09-a8ef-337069769141',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        365
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f259e3d2-5679-4f38-8fbc-2df439cbc064',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        583
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd6a9474c-8b0b-46c7-89f2-926298ca1c71',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        54
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '52a5b471-b71c-4dec-910c-fad13a3f450e',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        463
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e53f395d-c617-4555-aa29-af317f2be2af',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        278
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '83c4051f-bf18-44f2-b200-dd42ebd1b34a',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        151
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5549b309-2b74-47b4-b207-3b47deb24cda',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        15
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b35f88f2-fb78-44f2-a1ea-88d23199aeee',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        436
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b1f648d6-2d2d-4d4f-a034-e4870fe84d67',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        534
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ee7b4b1e-b7f2-4330-b481-d87c9d6ef3a8',
        'u001',
        '3c02184c-b1f3-4430-912b-202415653398',
        498
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '63b9920e-a31c-400c-8aa1-ed50393e53b9',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        15
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '35d7cd86-c41d-4a15-a5fa-285c5660b39e',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        295
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0d8ef906-fcf7-486e-bb83-5fd8c36b5c89',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        97
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '69c7f466-cef4-457a-b249-ddf3460437e5',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        428
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '57742d97-c6a8-49d3-bf43-28d9281febda',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        130
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '50f90020-3713-42a6-a01e-1daf9f4972f8',
        'u006',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        530
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '12541d77-b42f-4ace-9951-aabf81b88cea',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        127
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f915b504-e0d8-4781-a3ed-bd467b0c1065',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fbd0bce9-fbaf-456b-8bf4-4e33fcb8d119',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        250
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e1259055-1fc5-4267-85a5-af754628de41',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        325
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c4e83edf-10de-42e2-9972-cbadb06b62f4',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        436
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f21777ac-7dfb-4504-9389-3b9a168932d9',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        313
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a114f1d6-ec48-40b9-b81b-bfeac6f23375',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        301
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c10a446b-e2b9-4ef9-b4f4-365392fafd3c',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        27
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5a68e826-7248-4365-b388-0c28d0f78217',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        167
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '640259ab-1cdc-4e1f-8dfc-0256857874e1',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        87
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a5896ca8-d124-4a8a-821d-4a395f992523',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        231
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2c838406-498a-4285-99e0-d6314eae593d',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        347
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '477eb4f6-9108-44e0-9a61-9a5a4f19dde6',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        432
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '495b9fd7-bdd8-44fb-83ca-82ed3c9f4cf1',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        352
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '72166624-e0ea-4563-bf76-ffe989b3b309',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        408
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e2f7e77a-a9c0-425b-80e2-1a11ac604fe6',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        369
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd423f26f-b9f2-431a-a2c1-c7d42443c07e',
        'u002',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        90
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a8836081-0d42-46e9-84a8-68f9ab7d661e',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        323
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '54b6871a-c791-40d7-a9c2-7d68ebdf43b5',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        53
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0cd4e152-3408-4e61-b9f1-37cf0c9de97b',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        383
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '197d930c-1908-4268-b6bf-c76ee00b666a',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        373
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a41d5c2f-7884-4d7b-bf85-125315568a59',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'ede635b8-afea-4964-985e-442928a9c104',
        337
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4c266e47-6092-4840-97e1-477c2b6022d2',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        193
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6249fb8c-77a0-4dc5-8718-89fc1762844c',
        '5beae775-0838-4778-8853-7f41275c0e37',
        'ede635b8-afea-4964-985e-442928a9c104',
        29
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '02705e57-bc2c-4008-9a1a-c0edb8a246cc',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        392
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8819116b-7b01-4ed9-943f-68c29ad7bbaa',
        '5beae775-0838-4778-8853-7f41275c0e37',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        298
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '05621c92-116a-4add-9d55-97ce227fe973',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        569
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '51151ff0-643a-4099-ae20-8dea3d7b49e2',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        364
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f4591293-9ffe-4b4a-a665-59a1cc09fbc3',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        221
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8a667f7b-0587-4d2c-a689-3ffbf653797d',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        534
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '335e8ddb-e91e-4e5e-9acf-fd66106028bc',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        289
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f316b615-358f-4b60-ac65-82d20cfede25',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        100
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fbc45e22-816f-4aad-8c18-db6fd0b95857',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        314
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'daadd8d5-dff1-4ae4-9645-9528d1be2332',
        'u005',
        '3c02184c-b1f3-4430-912b-202415653398',
        478
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3871ee60-c5f6-4c95-9f2a-86aaa48eff81',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        302
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8316802f-8505-44d3-b709-d70688bdfb40',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        353
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5d712c72-8d2f-4115-978b-44712d1b8eee',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        304
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '119b5555-6298-4177-ad3f-479dd19fec04',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        348
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3c6cd8c1-2007-4100-97c3-34b3f12244e8',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        483
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a2f27cdb-a267-4121-8f1d-66fe10cda2ee',
        '5beae775-0838-4778-8853-7f41275c0e37',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        87
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f2a9e6c7-ebf6-4565-9c1f-fa6a181a4b33',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        153
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4e796fc6-6a63-41a3-9b28-348b2a855e12',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        323
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0402a8bd-504a-458b-8e70-e5cdb83971a0',
        'u003',
        'ede635b8-afea-4964-985e-442928a9c104',
        127
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '13884435-2486-48be-969b-817d7c5f461b',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        469
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '58e15897-c13b-4b2a-b5bb-e225e898d08b',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        478
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ea40895d-cf8c-4828-860a-a75a13ca154f',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        247
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4d36dbe0-550f-42b2-a2a3-8e84f79865c3',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        464
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dd53954d-e8b9-4410-b26d-f48753061fef',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        227
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b6f71872-0d7d-4741-b468-b36bf956be98',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        518
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bd69fecd-baf2-425e-8ad7-e6a404ac9179',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'ede635b8-afea-4964-985e-442928a9c104',
        156
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd183eb04-b066-4cb9-a226-935680f764ed',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        481
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e4f7ec5f-fa01-4e4c-959d-9087eae5b675',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        295
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c40d5549-d851-4c8e-a25b-0fe997b11bee',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        366
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '62b14359-0afd-4f50-abb3-5b72d0b66b36',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        588
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7db8f136-faac-4b01-aab6-ddbeec2a4564',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        438
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fed9d96c-6f77-4ae6-b3ba-ec04f77a2445',
        'u002',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        346
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ce648cd8-8701-4dfd-9b42-f77466e368a7',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        314
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '705432d4-8ef3-4abd-864e-316eb4b0fed7',
        '42345758-0d91-412d-922a-942b0700ddaf',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        590
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '98e053df-7840-47c3-afc0-548331fe9257',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        205
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f1fc7e19-cacd-4080-8599-c93d28996d75',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        533
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f15ff866-27ef-44ae-a45d-cd56cb78bc59',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        225
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b2c3cdbb-3279-48fe-9ad5-0bcc196f74f0',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        460
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c588b7fd-df94-4293-b2b2-6559f1c4c0b0',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        168
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5d5224b9-50da-48ab-b610-144d810bc244',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        277
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8a3b8159-8c80-4ffb-9d2d-20bc1ecf9e04',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        144
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd018a982-1d48-4960-9772-a64000c16072',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '3c02184c-b1f3-4430-912b-202415653398',
        218
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '92a72247-f0ea-4c58-83b1-1e9c43f96f1a',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        522
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6025582b-3633-4280-aae9-773acaa8a7d6',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        211
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f6e65941-8850-4aea-97d7-a3bb551eb4af',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'ede635b8-afea-4964-985e-442928a9c104',
        140
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd4264373-c411-4902-bc89-3d06c865866c',
        'u004',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        408
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '11de1beb-54bb-41e4-b55c-d58e6e536e1f',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        120
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4cf05e69-0fd8-48a1-a458-c67642fc99f8',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        592
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '508f8a73-118b-4522-bc66-82d4b74cd479',
        'u001',
        'ede635b8-afea-4964-985e-442928a9c104',
        526
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '26887f06-529f-4a9b-a331-92bb4fcf1268',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        240
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '824fd82e-e3b6-4fa8-b619-1cff9e51d944',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        509
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0dcf1792-cee5-4517-8d33-5121f0e11b53',
        '5beae775-0838-4778-8853-7f41275c0e37',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        252
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '82d5c517-bc2c-47dc-bb2a-f7b5ff1b3ff1',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        98
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd85aa8ab-bb94-43d1-bfd2-fdeb325014f5',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        8
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6fc8d8db-4c32-44ae-b2b1-c48cad4b0092',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        251
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3c964d39-512b-450d-87e1-bb57b712fcc7',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        47
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b04bf917-a255-42ff-8f03-11d39f31a91d',
        'u003',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        460
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0c56da4d-040b-4b4e-82b5-cb830adef719',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        580
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cd0ed8db-6e67-4fef-9723-27fb8e730360',
        'u002',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        329
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ab2d5bd1-c724-47d1-817f-67339985ac9f',
        'u006',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        105
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '882f8d74-839b-4ab5-8f85-4568d9f10f07',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        12
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8f0fde0e-9fda-4a31-a753-8f8458e2601f',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        209
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c44f6ef3-f560-4ae3-8d44-0c0c57d418bf',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        270
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f4db8d8f-9c21-4eee-b628-8ed229ae930b',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        360
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4d37e59f-cc45-4061-bf6f-8538c5e2e594',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        342
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd1cb3fd9-9781-42c7-9d79-5bc2c99b4478',
        'u001',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        216
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '90c09dde-5051-4c27-a4c9-8176a3d0fe32',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'ede635b8-afea-4964-985e-442928a9c104',
        428
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3105b45a-f686-4fa6-8210-bd7fa29fbefe',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        297
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '290ba831-6424-49bf-9aa1-e5b44185daa8',
        'u006',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        272
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2496adab-550d-4958-9437-bf7926681ed3',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        374
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '379896b1-e926-4791-8b43-638877b52a73',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        27
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd3006121-88e6-4c97-90d6-65fbad894670',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'ede635b8-afea-4964-985e-442928a9c104',
        437
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '13e01fbe-f625-4cc8-9523-f3d1f4938aa3',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        256
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '47996d07-3803-4413-899c-444a594fe43f',
        '5beae775-0838-4778-8853-7f41275c0e37',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        122
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0938eb06-79ae-4b1b-9a36-e7609ec92fa1',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        147
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '76b2232d-b5ea-403f-a6c8-de7305f38dd3',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        121
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8823a638-b849-47a6-a151-9457dfe5c1e7',
        '42345758-0d91-412d-922a-942b0700ddaf',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        62
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '023af7df-8901-44f0-bb15-bb0f0bcd51a6',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        581
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bf9d96b7-1425-4464-b526-8a894564f477',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        570
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '39c99b58-4e0a-4a20-89e1-7128462dad44',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        564
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '34ed321b-fa8c-4702-8204-e230bfe3becd',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        328
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '80b1605b-a7cc-4365-8ac5-4091adb4c760',
        'u006',
        '3c02184c-b1f3-4430-912b-202415653398',
        38
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cd9436c2-1212-424c-b4e9-95c1dd6af2e2',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        80
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b1fff670-9dea-4dc6-8f24-a5a0bf69256d',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        '3c02184c-b1f3-4430-912b-202415653398',
        109
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7faa7232-86dc-4108-a6d5-b11de13019a8',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        36
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '22a902fa-5c70-4084-ba40-f08cc54610d2',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        123
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9db27017-edc1-476a-85cb-9fea179d50ef',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        163
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd771527c-b58f-4acd-9151-095f20491433',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        462
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '95b4777e-9dbe-461a-963e-d26a907ce1be',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        343
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7bd25f7f-8d50-4ed2-839a-62c5fe8caed3',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        481
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '78015991-f494-459f-bb20-b75f1da0a29d',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        306
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ac8586bb-7bfe-45ef-9bd9-88df522a8500',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        53
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'afd0399f-f2dd-43d8-84a2-97391cf95875',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        '3c02184c-b1f3-4430-912b-202415653398',
        197
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '241d281c-d5af-4c46-99be-e57d7778a881',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        191
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '61cdc964-3bff-4150-aec2-94753e603373',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        563
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2781c99a-4569-4673-b805-41c40ee02d0e',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        467
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '70c0130b-b063-4d94-9514-0cc259958138',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        30
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9b33ad23-d312-4103-a8d8-3fbd14f911a5',
        'u005',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        97
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '49e5b1ac-f765-41ea-b958-e09d23d7529d',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        430
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'da1795a6-0f74-4cf4-b9b4-1aeb28a5ed16',
        'u001',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        405
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dbcd5ca1-f7d5-4046-b985-3b573e1a1160',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        443
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '07078f72-6751-4a73-8987-ac7cc21cf403',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        498
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ca8c77fb-ee0c-4af0-ad15-417ff4c79a12',
        'a1943068-54de-433b-9281-cc8f239039df',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        563
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '612340d9-6a50-4a0d-b12f-54b4c61baa0e',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        211
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '95f4c644-7d82-42c9-adaa-f2dc631cb9c8',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        513
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '22ac4602-5c50-4ba7-85be-17f2c8cbcd8d',
        'u002',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        84
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '319e2842-22c4-49e9-8af6-2ce5030ab04b',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        'ede635b8-afea-4964-985e-442928a9c104',
        311
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '335b2837-8e9f-45d2-aa63-6789e9b43810',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        192
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a0d5cb5f-4945-484e-bc73-685fe601a045',
        '5beae775-0838-4778-8853-7f41275c0e37',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        530
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '99e32b0c-48e4-4609-b57f-73fde663e993',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        438
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd29656ef-1d65-4620-a094-92fc581d52d5',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        176
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0c9fdaa9-1a00-4258-a772-e89533ef1c9b',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        296
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a4ed4848-d9ec-4a9e-9d39-be5fe89b35be',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        204
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '52da938d-dc2f-4be9-a4b6-53a762575652',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        177
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b3b3d755-e62a-4b5b-9781-930eb5074347',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        53
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '849412d5-3321-46c5-9e8e-67ed51642b8f',
        'u007',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        40
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5b7e18fc-2cad-4a8c-b8af-5991c180b287',
        'a1943068-54de-433b-9281-cc8f239039df',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        44
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f4096cae-2e7a-4acc-936d-0dcec8911dd5',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        483
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '31b5457b-f116-4672-8d00-0a7b5c1ac5bb',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        539
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '11e5d727-6af0-4d9e-b184-4eafcc4b4592',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        'ede635b8-afea-4964-985e-442928a9c104',
        86
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b9294ff3-f3b8-4cf0-9861-092d204fefc6',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        '3c02184c-b1f3-4430-912b-202415653398',
        526
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9289171d-e6cc-4c27-acb1-a28e0db28a23',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        193
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2ce7a5cb-b2ef-4072-9de0-c5fe8d066e61',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        588
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '60f843db-400a-4226-b903-e1384d9b5935',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        493
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9aabc075-d5df-444f-8bba-ff384bf8526a',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        388
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4468611c-a772-4811-aa91-5e44601d3be5',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        182
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dbe0ac88-5cb3-416d-b7d7-8873ecebf3e2',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2be54561-1f37-46ed-8a0c-d9c6e4597d5c',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        544
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3340bb26-7173-4629-98a2-a472020d88a7',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        312
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b4020c62-4625-4787-bc73-080ecbfc306d',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '3c02184c-b1f3-4430-912b-202415653398',
        275
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '92d833d7-7485-48fd-a141-77709d8b23d0',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        105
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fc9eaae4-1e96-4bd9-b28f-d55a21122060',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        201
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aae69269-1ee8-429c-96bb-98a89623111b',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        477
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aa99b2da-9e73-4dbb-bbfb-71c56c5c3c03',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        128
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '44c3da77-6892-4c0c-b391-ff50cbf87f11',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        526
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'eda85609-5175-41e7-9207-481fe9784a90',
        'u002',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        558
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a832246f-496f-41a4-885e-9d8e85cb26a4',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        95
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dcb04a82-31c3-4356-99e1-86af0203d759',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        161
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7cec6b7d-a683-42a0-88d5-722139d059e0',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        257
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4e66a283-1210-4421-9bee-24fc1785a081',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        568
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '09625519-1672-4e12-bd01-70ef2677c730',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        314
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9697f093-2241-4f1b-a3c6-6707e2034828',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        26
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '360f3d84-71fd-4c8f-8dc2-458eb6cb2b14',
        'u007',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        36
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '582ef2c2-c2e1-4f5c-b17a-2fda58b456f4',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        557
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '03c01585-c043-4343-8962-4f1489211957',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '3c02184c-b1f3-4430-912b-202415653398',
        241
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e2d32713-b84c-4fca-9f2a-3fde6d4a9aa8',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        466
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd413cf0e-097a-4189-af8b-1f84e37dc156',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        544
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f40bfd01-14aa-40e2-ac26-601aa7efbb4c',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        188
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a5ccb10f-09f4-47b9-89bd-0d00531b688f',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '3c02184c-b1f3-4430-912b-202415653398',
        252
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bbba451c-cb18-4016-a7d1-6c996be55824',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        516
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '00ecee74-3908-480e-a120-db343378247b',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        261
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '505afe59-36bd-431c-b050-3c302c903643',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        333
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c762634f-bd18-4097-9e9d-401e46ddfe77',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        482
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cc58827e-a70c-4b57-9027-bda8c01ebd5d',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        220
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aeffe26a-6f70-4698-afad-1441c4cc7aa7',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        217
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a8c40f9e-9aa2-47f8-90bc-5c225f3395ee',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        402
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'efcdfdcb-b019-45ca-932a-0bbc3fd6fe04',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'ede635b8-afea-4964-985e-442928a9c104',
        184
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '88c2c351-1e10-4a4b-8f3e-e9d687aa9089',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        413
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '713d9669-b60f-4a5b-935e-14028f4b749b',
        'u003',
        '3c02184c-b1f3-4430-912b-202415653398',
        515
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '010d6309-ecf9-4dfb-9116-89faa3407f08',
        '5beae775-0838-4778-8853-7f41275c0e37',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        410
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '013c9445-6038-4fe2-a691-a8b5edb9afd1',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        58
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fb9c2fef-c4df-4113-885e-e216fc80b705',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        199
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5cb2144f-f4c8-48af-aee1-78c3853b0e64',
        'u006',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        542
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f3151acf-ecad-4408-baa5-9c2f4aef99b3',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        316
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5651516c-cd31-47aa-889f-4fd8b919fe72',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        301
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f7c54976-20a9-4750-9b6f-8b9567301ff7',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        212
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6094a6bf-3ac9-4267-9b7e-5d2d00afc897',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        380
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3784ea04-f07b-4925-8e38-526cfcf01ed2',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        42
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ce13ff25-f082-4dfb-a7b3-0e659b6eeb18',
        'u006',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        191
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd6e41a35-e30e-4fb5-9306-26564441da65',
        'u007',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        507
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a99bd039-fd9d-443e-b549-d464b8794621',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        11
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3ee4646a-4451-40e9-8dc1-796744e6c281',
        'a1943068-54de-433b-9281-cc8f239039df',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        407
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '10d24659-bce7-4300-bb40-8fbd10926213',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        288
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2bbdb6fb-ddf8-4e3b-b475-4d5a781430fe',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        547
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aec7636c-f86f-48f5-a51e-61d0e166f248',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        229
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'dc2266c3-3c79-446c-9b7b-006ee600206b',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        147
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '166c0f5d-b523-4cb2-8049-b470b8528ad5',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        145
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '785ac3a4-f0e0-43a4-8309-5e422fdaa288',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        444
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ea4fc0b1-6269-4f73-a4fe-d3c09a7bca05',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        560
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fccd8e43-da59-49f9-a9d4-ac4cf25256b1',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        469
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cd203f6e-331e-4696-bbcb-b40e24103acd',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        150
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0ea09713-8c8a-428d-ac10-c9fb1f559ebc',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        416
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aede5870-9517-494a-98e0-b3bd63a2160f',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        396
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b80b37e8-3652-4064-a7d0-4872f6d2e228',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        562
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b51aa28e-9c07-47b6-9aee-d9402bd9fac7',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        248
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '56859397-3046-49c4-85b9-1f98203bf591',
        'f5f5946b-2834-447e-937e-1587df58d305',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        564
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5f9adcd1-cbbf-405a-8c02-68248ab676db',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        352
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2fa87deb-14ea-4afc-985c-98c329112261',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        457
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '71022bea-bc30-4d95-998a-cb8c76b04670',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        388
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '812112da-768c-4509-9606-b213dfa08a8c',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        218
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0f4bc0bd-cafb-4623-b1f9-44e39adb40c1',
        '5beae775-0838-4778-8853-7f41275c0e37',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        49
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c0e647e5-0519-4e66-b952-6c4837886727',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        430
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '07425839-8e58-498c-941f-5e32e9a1c853',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        288
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '043c6451-f1aa-42b6-8bb3-63ab12e27f3e',
        'u004',
        '3c02184c-b1f3-4430-912b-202415653398',
        434
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '1ffb8fad-3f8c-4548-93ca-aceba86be4a3',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        300
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'de380ec3-2996-4705-8977-06155f151ef5',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        330
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '46ae48ec-14b3-44ae-a8f3-94a2bd0229c0',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        48
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bd4acd14-b940-4bef-9ff2-bfb844e78880',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        296
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a30ad983-cf5f-4993-8e20-a394d21c0d4d',
        'u007',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        538
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cdb63ad2-a6f0-4d0e-952e-72ccfe0ccd3d',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        159
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fd2b90d2-b545-4d5b-871c-c431b6e35b12',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'ede635b8-afea-4964-985e-442928a9c104',
        64
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c2910033-208d-46cc-9f24-f0fafa98198f',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'ede635b8-afea-4964-985e-442928a9c104',
        60
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '75762a3e-93d3-47cc-8f63-3e8912017b3e',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        312
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '86a5c427-9b4f-45a7-8183-7635dfeb4cbb',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        146
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ce47496a-0fc4-4225-b052-72cd9c8d03b2',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        569
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cfb8cc66-a297-4588-a80b-d5b60a60fbc5',
        '060adf54-6678-479d-a85c-2ffa48344583',
        '3c02184c-b1f3-4430-912b-202415653398',
        312
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3ef8e5c8-b390-401b-9a9f-432003836356',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        134
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ea40a4a3-79ce-4f3b-9ec6-ec204c43e9e4',
        '5846341e-b295-4fa0-bfbf-a01d5bcc598a',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        66
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bc7f1c86-8aeb-4538-b877-4c71ca8cb4f2',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        27
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '36f67fd3-0c08-41ce-954c-31ca959a7a22',
        'u006',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        516
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '75446031-4b07-4f87-a113-6b25b3486e12',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        242
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6671600e-e280-4624-86cc-4ace9f8b62cc',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        146
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '26b14ddd-9b0e-4f95-86f6-e4ab23d415f4',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        140
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8217bf5a-a92d-44c9-8f56-8af075bbfb5d',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        94
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'efa7e542-ba89-4d89-b225-06c671360731',
        'f5f5946b-2834-447e-937e-1587df58d305',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        197
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'deed445c-1d1d-4bdf-91be-6af01b23fee6',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        451
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b4e3f1e7-6027-4591-9608-fcf0cf1ebe58',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        256
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b27dc234-68ac-4191-bee6-67eabef23ce1',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        97
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7b17eb4a-c13f-4991-8e92-e629c4b183f5',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        374
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '288451be-9f4a-481b-8ed7-7c2f42aa75ef',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        357
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3ebf8297-5583-48b7-8726-e3abe2225544',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        167
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '66cf26fe-0049-44e1-98d7-dddbd16c4de2',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        532
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ca82e5f4-9013-4922-8bac-becbb78a5d23',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        592
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '320c6e77-5719-4cd5-83d3-a18e8e4315d8',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        300
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e1657556-663f-48dd-905e-affae989d5b1',
        'a1943068-54de-433b-9281-cc8f239039df',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        268
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '46760f63-3d42-479c-9a76-9ab9a0d30c50',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        475
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '53536090-d4e0-4994-8655-f531f96ca65f',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        260
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6b0d74cc-9b5d-4580-8cd3-09a574f76221',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        '3c02184c-b1f3-4430-912b-202415653398',
        43
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '44cd7f33-0558-4cd5-883b-fc645a35d3e1',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        90
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'df35a5a8-33e4-4387-8db6-88c3bc055873',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        335
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '082a7281-5422-46e1-8df8-598c350b74f9',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        571
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '80356e54-a25f-4e4a-b945-025089ab0c1f',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        82
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8d169ff6-8ee7-4d08-9ced-3edcb848591b',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        100
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3ae7f8ca-7833-471a-aab0-6fd26025bec2',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        581
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '641ef90f-25ed-4cc4-9893-6ce35d1cbe1c',
        'u007',
        'ede635b8-afea-4964-985e-442928a9c104',
        484
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ea7cd97c-77f4-4e18-92df-1038f1d20427',
        'f84a2ead-f61a-4c86-aa98-bea3e65c6492',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        108
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cd6e820a-fa3d-4f38-8a4d-d69f6465ddd1',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        595
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e1e02e01-c843-436b-b6bd-ee22e761a525',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        380
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9630e6cd-545a-4c55-a398-54724f197c3b',
        'u006',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        195
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'afe11b9e-8280-4504-b8d3-5c614da84805',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        417
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a7900a6f-baff-4cb9-b177-c6cdc3166d93',
        '5beae775-0838-4778-8853-7f41275c0e37',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        565
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '03bde350-638c-420c-a271-d7ece5ed6d6e',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        36
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '08954831-4345-4687-9d76-862c143c1700',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        319
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0c7a7161-f854-4ef6-a9d7-fc86ea0c7ab7',
        'u001',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        91
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'eacdaf0e-50e1-411c-b686-d0e03c6c3f92',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        113
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'da2d2179-56b1-45c8-80ff-84b456b4aefa',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        391
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a7bd821e-9ed2-466d-bc4e-c49efb2f9f97',
        'u003',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        272
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0e947eb9-1ac8-4819-8957-e5f1d3b23c4b',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        21
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c5c4cd0c-f3e4-49a9-a1a7-a5a9b7dd4348',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'ede635b8-afea-4964-985e-442928a9c104',
        548
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e86c8483-1639-411f-9d1a-2476d6fa2ba3',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '3c02184c-b1f3-4430-912b-202415653398',
        229
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b4f77d91-17bd-4350-a9ce-b0d7508582f8',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        341
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd347d717-584d-46d5-82a4-290cad5a5710',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        270
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fc405a65-cec1-4b93-9a86-d87b8ccac7b7',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        374
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f9dd5aa8-0aaf-4e47-8c36-4625ae3a0cb2',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        298
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7452b259-3745-4da4-9a11-a18446bf4245',
        'a0bb5844-bf79-45a1-9723-908d70623aaa',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        233
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fc922fcb-c3c8-4760-9929-d61101e2e19e',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        298
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0ef8a182-34af-4137-953f-18cf74fb9890',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        526
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd7a83312-0a3a-4df8-aa1e-b04966e2e319',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        194
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fcba7744-ce50-49ce-babf-07a24b8e5d2e',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        123
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b7e25036-38dc-45c1-a932-6a0f097ec823',
        'u004',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        321
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2fed8ac3-da60-4fc1-a4bd-3ba5354ac9f6',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        221
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c13c0d0a-4b81-41e5-ad20-a0bfc8ee97eb',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        136
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'cd62a6f4-9e08-411c-8e28-0bcea60ac53a',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        291
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '96d2385c-8366-4d0d-92b4-899a4a2c33b4',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        571
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3598373d-53e5-40c2-92f7-ec03c347c6ff',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        451
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '82a29b6d-7346-4e70-a6bb-7aee2e500028',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '3c02184c-b1f3-4430-912b-202415653398',
        359
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f425139e-ae57-4ccf-aa8b-edbc585910c8',
        '2f2b32ac-8096-4848-bfe8-6b948ab990f4',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        64
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '704a354e-f81f-4d6a-bf64-d43225a9a303',
        '5beae775-0838-4778-8853-7f41275c0e37',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        438
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e1962842-28d1-4e1b-9da2-1730950163fc',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        153
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5b64b272-55fe-4a84-ae04-26895185e42b',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        245
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7a359186-e62f-4e32-9535-4514baceed22',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        130
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bf15ccdb-cd7d-4d32-9035-3d820fc2b5f3',
        'a1943068-54de-433b-9281-cc8f239039df',
        '3c02184c-b1f3-4430-912b-202415653398',
        46
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '75a71ab9-630e-43c4-841c-2a461f15ad87',
        'f5f5946b-2834-447e-937e-1587df58d305',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        562
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'abc2248c-159c-47a9-a8bb-bd3e538db7fb',
        'u001',
        '3c02184c-b1f3-4430-912b-202415653398',
        198
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '647da5e8-c443-44cc-a9f2-337a29bc4540',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        441
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0df2e4a1-fda3-495b-bf76-e085758955c4',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        435
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f77c84da-1a8e-4c58-b2fa-b817ff24dfa6',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        248
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2cb84d57-882b-45b4-9111-7758fdefbb6d',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        46
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '84bf473b-04d1-4e77-8b9d-e5c99965bf47',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        494
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '48b4044f-85f2-4f74-b1ba-49f91bda74e2',
        'u006',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        357
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'da4d9b9b-6aac-4212-acc7-95ddfc448277',
        '260925ed-1177-4bab-ba0c-aa2c10841180',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        157
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ed2706c9-7858-438b-8c79-075f76270702',
        '6c7639af-3f97-45ce-9f83-694145a52aca',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        199
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f99c2b9a-65fa-477c-857e-a4b856832201',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        402
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b0e0097d-2f69-482f-9516-db9f1a9846b3',
        '6cce1682-e164-464e-8ce7-38b77fcb8c75',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        70
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd499af10-adbe-44b6-b3ed-50dbffd6f9b2',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        150
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '86d6a5b2-707d-48c5-8c7e-1dbcecd7806b',
        'u004',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        79
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '181beeab-a003-4a8f-a704-2472fc578028',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        267
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '90b68205-d2e8-4fa3-8529-3a7ac9e0e66b',
        'a1547c7b-aed0-4607-af14-13ee986ef8fa',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '58618994-f22c-4ade-920c-9cc71f24ee2e',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        465
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '22393cfd-7b30-46d0-8a4d-045a4aa4f984',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        553
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '26150226-d00f-44c5-a677-3272a69fe135',
        'u002',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        203
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2b24f2e1-1190-4a1a-aa16-08ddc10783ab',
        'u006',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        256
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '530be264-ef85-4107-a249-7db8e307426f',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        136
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c3589024-5d17-4bc1-a32a-06627dd14a34',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        498
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '21ac42de-acf6-473c-b55c-65ffeac6b959',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        413
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd95066ee-ba63-4ea4-8879-727a872f9ff5',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        15
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b51142f0-a83d-4c04-8bb1-9ec8bec0a5f6',
        'u003',
        '3c02184c-b1f3-4430-912b-202415653398',
        61
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '082cbfc2-c64f-4094-a54f-e039ca4ca1a9',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        18
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '50b76a17-0320-4d33-9b37-ef7975a55db9',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        397
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '41fd6c10-4cc8-4a76-b630-a1acde34d06e',
        'u007',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        274
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '67345a73-9e54-4a08-9701-964fdf3dd2ab',
        'u004',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        539
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e8091ccb-7132-4cd5-8d5b-bf8dce162837',
        '670616bd-074e-45c6-9e55-b2b2f87ceb40',
        '3c02184c-b1f3-4430-912b-202415653398',
        92
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '09d2868d-3112-4d28-ac29-72a1cecb0034',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        78
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '73fd8230-4c09-4cb1-b2e9-52260a3155c6',
        'u004',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        115
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'abe5139a-47da-44fe-a15a-7b42e0698340',
        '060adf54-6678-479d-a85c-2ffa48344583',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        62
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '85fe0fef-3d25-4c1f-b71a-f7c5b6432179',
        '060adf54-6678-479d-a85c-2ffa48344583',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        83
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'fa84579b-25f8-4850-8471-c38e4122e524',
        'u003',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        328
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f54839e1-25ca-4cf5-bb04-29bd1c5cfaa3',
        '5703dd83-7177-4205-abe7-ba36962edc86',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        236
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3532074a-99c4-4fda-8c79-33b48a5964e2',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        110
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9dea8b48-d7ff-4f68-9581-f3ab062322fa',
        '84f32a52-e72b-48a6-8032-2cb028cd14d8',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        15
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '46201d74-8884-4727-bf4a-26a4d5af7a44',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        326
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '93779ff1-4665-49f3-9eeb-c1646b5b715d',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        470
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '089667f1-d966-4c3c-a9a3-ee314cd52328',
        'u007',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        103
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3f6ccc11-1d17-47bc-b4bd-e1c15c7d8770',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        158
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8991f664-8fe6-4537-b801-27c20ca7bff3',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        512
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b8baf4fa-3440-4a27-8aa2-6a1eb84d64e1',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        214
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b0c823e6-1aa0-477b-9c84-f91458f56d11',
        '592ea85b-a394-4d62-a93a-5d638ce6a0f6',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        225
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c3d434ac-af53-4ca3-bc11-c409357170c6',
        'u003',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        525
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4e54b394-b30c-415c-97a1-4567c65ee838',
        '9f287499-1d88-4728-a15b-0deed68f95f8',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        336
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'aaea4e7c-2e48-4a76-b2de-4261fd00cfe8',
        'ca146214-41ff-4bda-bb62-4319bdd8f5fb',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        220
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f67ed341-946f-4365-9f43-6b55287f3fc9',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        154
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '68560bc9-8b17-4ba0-b79e-6e8ddd51c83f',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        252
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '48cd14d7-2c1b-4081-bed1-ddf95221b50e',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        494
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '84f31ff4-99d4-40a8-9d8e-61631172ef45',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'dac3fb74-95e3-46a7-a248-8cef6e4adb9b',
        438
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '72682892-6eeb-4586-94c0-1ab873491aa4',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        531
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8e78911d-074f-4cd9-9dd7-0022f64831dd',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        368
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3f68a1e6-81d1-4452-afef-19c98ce351b9',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        371
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'afe1dd80-2183-497d-9392-05eaa8b6928f',
        'u007',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        582
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8364f17b-11d1-4b69-966d-0f60454cc23f',
        '42345758-0d91-412d-922a-942b0700ddaf',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        569
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '499628fe-73a3-4865-b7ea-c65e0cc2fe08',
        '5ff8ba21-cc8e-4701-aab5-88344e9c7236',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        53
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a7ed7afa-0264-4e43-a76f-ddef1ad691ae',
        '57836983-0e70-4c84-be51-2aa2765b23ac',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        369
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a2c16d49-ce0b-4c9a-bd91-57792b1412cf',
        '73c89dd9-069a-4643-8c3c-d5d6aa11639a',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        338
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'de4957e8-cc32-4e38-abcb-a1ff2b82e1ab',
        'u002',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        563
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '929369dc-139f-4db4-9472-275d4adc7c0e',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        79
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c8998cbe-a733-4525-98c2-55a8463af814',
        'ce2b74df-9fd0-45bb-8cd9-34082e848e64',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        129
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e83d00fe-4691-45a6-87e4-5ca0b58429a6',
        '953755a2-a101-4934-a7f2-d9612a2de268',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        261
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '260268ce-9590-496c-b4c7-f79aa6804353',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        33
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'eb6121ef-ca60-4d95-9e8c-a18595211d7d',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        'ede635b8-afea-4964-985e-442928a9c104',
        384
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f12b370e-476f-447a-b912-589692c3dc83',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        400
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '21c597e3-002d-43d9-ac3e-a54e2f80f21c',
        '1a584811-8bb3-4610-b04e-e2fbf70563a7',
        '3c02184c-b1f3-4430-912b-202415653398',
        522
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '338e49ee-7d60-4cac-bd17-782f6778aeb6',
        'dece82bd-1cda-4eb0-bb4e-129e7dd3094f',
        '10b5fe54-327c-4806-9ea0-8ec39c242be9',
        462
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ecc8fd63-f7f3-43db-adc3-ef47f84e4e65',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        174
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ccf7f96c-105a-464a-875f-909774db2d53',
        '727dc469-a95a-4512-8c95-7f9bb4cb2a72',
        '3c02184c-b1f3-4430-912b-202415653398',
        373
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '55a4f5eb-9815-47b1-95cb-fc28c5130dbe',
        'u004',
        'e1b6578f-d711-4471-9236-3751b104aa3f',
        535
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '60602812-45e6-47bd-829a-50618fa03536',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        467
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '59e44f31-71fd-44a7-acf3-b80a418d02b2',
        '0a055668-c845-4814-a58b-d28952026ff0',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        288
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0d3d8014-c5dd-4fe5-b387-d22c68bccd3a',
        '15da7e15-2581-4c7e-8876-ed8a4d5cac85',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        483
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3a75671a-9e64-450c-abb1-e3b3251079dd',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        244
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '07425aa3-c2dd-4698-a814-c7277a2081b0',
        '060adf54-6678-479d-a85c-2ffa48344583',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        461
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'd558bf9e-f619-446d-893a-11e0aeebbf28',
        'bae2f0d9-3ffd-4356-bce4-923f942c2a1d',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        358
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'df58a3a5-8471-4ebc-84ae-582262840060',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        164
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '3891868e-f891-49d8-b856-fc0c91b7cf7d',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '0ccfce22-9eb1-46f2-add9-13c7b3784446',
        192
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0bf43823-f13b-49d8-88d1-d71e71b9af48',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '3c02184c-b1f3-4430-912b-202415653398',
        176
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '65842526-6b34-4de7-870a-54fff09b8d0f',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        58
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '580f3baf-e353-4904-b94f-c0e571425602',
        'u002',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        320
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '7864288d-bbd6-4933-9f7a-b04a621eec28',
        'd04aa22e-fd93-43ad-ba8f-ecbeb314a0bc',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        320
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6ae8e47c-a506-4677-88f7-a17a12b44b22',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        255
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '177441c7-0802-4f14-a692-f8267168dbe0',
        '7b33a5f9-edb4-4b9c-bc53-85e10675b467',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        565
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '092e65ac-0459-45ab-ac1a-b00320d9c2bd',
        'dcc22150-7372-4992-bd91-7b50263a0adc',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        340
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'bc45919f-dfa5-4bb2-809f-588de0953dc9',
        'b5747468-b762-45a0-92a4-acffdedd8293',
        'bd4cd3ac-bcc6-445c-9ae4-cbfc28f7458b',
        85
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '2b06582a-51e2-47ac-a058-330283731933',
        '8b458f88-78cb-4bed-b354-51e614ee4769',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        546
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f63d6527-002e-455f-97eb-6f1757552a10',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '618f41a0-7021-4f59-bd3b-7447f3099b6c',
        409
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '985d03cd-d12e-4c1c-b8f8-5084f28268de',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        4
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c13e9a60-5baa-406d-ae9f-8c6e9feafae4',
        'u003',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        108
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '28340630-51ab-4210-8fa0-a6d1459470b6',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        523
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '6c6ce452-0313-45d9-85c8-a06e9ee70259',
        'f1dc3d62-f490-4c25-81fb-239efada9aa0',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        532
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'ee7695b4-7b94-49bf-97a8-5042db6b5ca4',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        '944ce6aa-027e-46d5-a42d-b63f77f363e3',
        18
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c0043f45-d442-41c3-b4bc-44938712644f',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'ede635b8-afea-4964-985e-442928a9c104',
        33
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '455eba2a-ff79-482b-adb1-d8bbd6349a25',
        '1a7be708-69b9-47ed-8277-957be237bd07',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        58
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'c4a2729f-b554-48b4-9f4c-dfaccf76d645',
        '6c54d123-51f4-4e09-83a3-0231686ede3c',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        73
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '565b574a-c75b-4fc4-adfc-e5d56fb6aa9e',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'cde5e20d-b207-474c-88c5-78efefbda9a9',
        12
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '32543f76-9846-44fa-bf3d-e345ad3d0684',
        '36ee13c6-f3de-48a6-8d72-bb773125944d',
        '3c02184c-b1f3-4430-912b-202415653398',
        294
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '30c95933-cb0f-4573-8a40-96acb637fb2f',
        '249d4cc7-01d6-4321-81cc-4d4a48fbefd5',
        '94e0ad82-a01d-4b42-b0ad-b5ac189a3c3f',
        265
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '443d2229-44b3-4087-aa46-384e38ec736c',
        'fd6f2ba6-9966-46b5-ad84-94154ec0f890',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        521
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'e64c884d-bd09-4fe5-87e4-c8e329b32a8e',
        '2e3c180d-0e2e-4af7-9b38-8aa97a8eb512',
        '6c5f8ebd-0147-43be-9932-4b985f05a0b6',
        346
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '68c0aa42-619c-42f0-a92c-e084b7fff86c',
        '6bb0475d-13a0-4072-adb4-d51e33685f67',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        201
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '512e0184-d78b-4a80-9717-f4c9006f423f',
        '1eafa48f-cfda-4b7c-b206-26ab42beedde',
        'ede635b8-afea-4964-985e-442928a9c104',
        163
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b4595c5f-7901-4f58-8607-2909e90660d7',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        '16679526-49bf-49ef-8e72-dbdde32810cc',
        26
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '4b54bf40-ae20-4692-b007-273d6a6bc3be',
        '28efbf51-41c6-4809-a65f-089e480891e0',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        349
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'f6e91e0d-b1da-40ef-92ad-070fb619a66a',
        'f344afda-0dc5-4f08-9968-632d55c3ba1d',
        'e23be3aa-e4b8-4356-aaa2-e5f7f9f7ae9f',
        587
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'b6ef4dfe-0ff4-49e4-b842-92a71e0485cc',
        '26db85a6-4464-4ed2-bae1-0fc66262e116',
        'cf4d84ca-5991-43af-b745-146a39200ebf',
        162
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '8871ea9c-b899-4110-9689-cfc97605617a',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'a76b9a53-9301-49bf-8ff0-af45e98bcbc2',
        83
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5afa7b81-3f45-47ea-9aa5-98b9773b528b',
        '92856ff8-4a96-4f8f-9534-ec1e6ba97a83',
        'dfba1c97-58c0-406e-bb3b-bdf885afe3be',
        13
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        'a8f5274b-6b40-434b-9683-8967dafa7009',
        '2ed7d5c4-c59a-4831-af02-14b77299229d',
        '3b9372da-84c0-4d9e-9e8e-c6dae75dc4fd',
        482
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '9e97319b-42d3-4189-92d0-7a6d99965a86',
        '0a055668-c845-4814-a58b-d28952026ff0',
        'ede635b8-afea-4964-985e-442928a9c104',
        359
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '0c1eb584-a5a7-40f6-a3b6-bbd56de3b97d',
        'u004',
        '371a57a9-83a0-4bd5-8cc1-c516982db5b6',
        434
    );

insert into
    MusicHistory (
        id_music_history,
        id_user,
        id_music,
        play_duration
    )
values
    (
        '5f7cb1d8-c9e2-4823-881c-0800e439e6b8',
        '77abb304-c396-4b51-b1e6-2e25c21ec0ef',
        'b8a7b1e8-dac6-4b97-bb19-a4a23fbc2db9',
        431
    );