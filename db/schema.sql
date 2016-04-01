CREATE TABLE authors
(
    id INT(11) PRIMARY KEY NOT NULL,
    email VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL
);
CREATE UNIQUE INDEX authors_email_uindex ON authors (email);
CREATE UNIQUE INDEX authors_username_uindex ON authors (username);

CREATE TABLE posts
(
    id INT(11) PRIMARY KEY NOT NULL,
    author_id INT(11),
    title VARCHAR(255),
    content TEXT,
    created_at TIMESTAMP DEFAULT 'CURRENT_TIMESTAMP'
);

CREATE TABLE tags
(
    id INT(11) PRIMARY KEY NOT NULL,
    body VARCHAR(255) NOT NULL
);
CREATE UNIQUE INDEX tags_body_uindex ON tags (body);

CREATE TABLE tags_posts
(
    post_id INT(11) NOT NULL,
    tag_id INT(11) NOT NULL,
    CONSTRAINT `PRIMARY` PRIMARY KEY (tag_id, post_id)
);

CREATE TABLE comments
(
    id INT(11) PRIMARY KEY NOT NULL,
    post_id INT(11) NOT NULL,
    author_id INT(11) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT 'CURRENT_TIMESTAMP'
);