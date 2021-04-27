DROP DATABASE dbsprojecttest;
CREATE DATABASE dbsprojecttest;
use dbsprojecttest;
show tables;

CREATE TABLE usersTable_data(
    user_id varchar(20) NOT NULL,
    username varchar(20),
    user_og_name varchar(20),
    last_active timestamp,
    PRIMARY KEY(user_id)
);

CREATE TABLE usersTable_creds(
    creds_user_id varchar(20),
    user_password varchar(20),
    PRIMARY KEY(creds_user_id),
    FOREIGN KEY(creds_user_id) REFERENCES usersTable_data(user_id) ON DELETE CASCADE
);

DROP TABLE chat;
CREATE TABLE chat(
    chat_id varchar(20) NOT NULL,
    chat_name varchar(20),
    owner_id varchar(20) NOT NULL,
    PRIMARY KEY(chat_id),
    FOREIGN KEY(owner_id) REFERENCES usersTable_data(user_id) ON DELETE CASCADE
);

CREATE TABLE chat_users(
    chat_id varchar(20) NOT NULL,
    chat_user_id varchar(20) NOT NULL,
    PRIMARY KEY(chat_id),
    FOREIGN KEY(chat_id) REFERENCES chat(chat_id) ON DELETE CASCADE,
    FOREIGN KEY(chat_user_id) REFERENCES usersTable_data(user_id) ON DELETE CASCADE
);

DROP TABLE messages_data;
CREATE TABLE messages_data(
    message_id varchar(20) NOT NULL,
    message_content varchar(20),
    message_timestamp timestamp,
    PRIMARY KEY(message_id)
);

DROP TABLE messages_link;
CREATE TABLE messages_link(
    m_link_message_id varchar(20) NOT NULL,
    m_link_chat_id varchar(20) NOT NULL,
    PRIMARY KEY(m_link_message_id),
    FOREIGN KEY(m_link_message_id) REFERENCES messages_data(message_id) ON DELETE CASCADE,
    FOREIGN KEY(m_link_chat_id) REFERENCES chat(chat_id) ON DELETE CASCADE
);
DROP TABLE messages_meta;
CREATE TABLE messages_meta(
    m_meta_message_id varchar(20) NOT NULL,
    m_meta_sender_id varchar(20),
    PRIMARY KEY(m_meta_message_id),
    FOREIGN KEY(m_meta_sender_id) REFERENCES usersTable_data(user_id) ON DELETE CASCADE
);