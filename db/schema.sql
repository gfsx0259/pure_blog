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
    content TEXT
);