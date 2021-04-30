-- CREATE DATABASE dbsproject;
-- DROP DATABASE dbsproject;
-- USE dbsproject;
/* ------------ Tables ------------*/
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

CREATE TABLE messages_data(
    message_id varchar(20) NOT NULL,
    message_content varchar(20),
    message_timestamp timestamp,
    PRIMARY KEY(message_id)
);

CREATE TABLE messages_link(
    m_link_message_id varchar(20) NOT NULL,
    m_link_chat_id varchar(20) NOT NULL,
    PRIMARY KEY(m_link_message_id),
    FOREIGN KEY(m_link_message_id) REFERENCES messages_data(message_id) ON DELETE CASCADE,
    FOREIGN KEY(m_link_chat_id) REFERENCES chat(chat_id) ON DELETE CASCADE
);

CREATE TABLE messages_meta(
    m_meta_message_id varchar(20) NOT NULL,
    m_meta_sender_id varchar(20),
    PRIMARY KEY(m_meta_message_id),
    FOREIGN KEY(m_meta_sender_id) REFERENCES usersTable_data(user_id) ON DELETE CASCADE
);

/* ------------ Functions ------------*/

DELIMITER $$
CREATE FUNCTION getNewChatId()
RETURNS integer
deterministic
BEGIN
	DECLARE newchatid INTEGER;
    SET newchatid = 0;
    WHILELBL : WHILE newchatid <= (SELECT COUNT(DISTINCT chat_id) FROM chat) DO
		SET newchatid = newchatid + 1;
    END WHILE WHILELBL;
    RETURN newchatid+1;
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION getNewMessageId()
RETURNS integer
deterministic
BEGIN
	DECLARE newmessageid INTEGER;
    SET newmessageid = 0;
    while_lbl : WHILE newmessageid <= (SELECT COUNT(DISTINCT message_id) FROM messages_data) DO
		SET newmessageid = newmessageid + 1;
    END WHILE while_lbl;
    RETURN newmessageid;
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION getLastMessageSenderId()
RETURNS INTEGER
DETERMINISTIC
BEGIN
	DECLARE counter INTEGER;
    SET counter = 0;
    WHILE_LB1: WHILE counter < (SELECT COUNT(DISTINCT message_id) FROM messages_data) DO
		SET counter = counter + 1;
    END WHILE WHILE_LB1;
    RETURN counter;
END $$
DELIMITER ;

/* ------------ Procedures ------------*/

DELIMITER $$
CREATE PROCEDURE createNewUser(
    IN user_id varchar(20),
    IN username varchar(20),
    IN user_og_name varchar(20),
    IN user_password varchar(20),
    IN last_active timestamp
)
BEGIN
    INSERT INTO usersTable_data VALUES(user_id, username, user_og_name, last_active);
    INSERT INTO usersTable_creds VALUES(user_id, user_password);
    SELECT 'USER CREATED !!';
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE deleteUser(IN del_user_id varchar(20))
BEGIN
    -- mData -> chat -> chat_users -> mLink -> mMeta -> uCreds -> uData
    DELETE FROM messages_data
    WHERE message_id IN (
        SELECT m_meta_message_id FROM messages_meta
        WHERE m_meta_sender_id = del_user_id
    );

    DELETE FROM chat
    WHERE chat_id IN (
        SELECT m_link_chat_id FROM messages_link
        WHERE m_link_message_id IN (
            SELECT m_meta_message_id FROM messages_meta
            WHERE m_meta_sender_id = del_user_id
        )
    );

    DELETE FROM chat_users
    WHERE chat_id IN (
        SELECT m_link_chat_id FROM messages_link
        WHERE m_link_message_id IN (
            SELECT m_meta_message_id FROM messages_meta
            WHERE m_meta_sender_id = del_user_id
        )
    );

    DELETE FROM messages_link
    WHERE m_link_message_id IN (
        SELECT m_meta_message_id FROM messages_meta
        WHERE m_meta_sender_id = del_user_id
    );

    DELETE FROM messages_meta
    WHERE del_user_id = m_meta_sender_id;

    DELETE FROM usersTable_creds
    WHERE del_user_id = creds_user_id;

    DELETE FROM usersTable_data
    WHERE del_user_id = user_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE createChat(
	chat_id varchar(20),
    chat_name varchar(20),
    owner_id varchar(20)
)
BEGIN
	INSERT INTO chat VALUES(chat_id, chat_name, owner_id);
	INSERT INTO chat_users VALUES(chat_id, owner_id);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sendMessage(
	IN new_message_id varchar(20),
    IN m_content varchar(20),
    IN m_chat_id varchar(20),
    IN m_chat_name varchar(20),
    IN m_sender_id varchar(20)
)
BEGIN
	DECLARE new_message_id varchar(20);
    SET new_message_id = concat('message_', getNewMessageId());
    IF m_chat_id IS NULL THEN
		SET m_chat_id = concat('chat_', getNewChatId());
        CALL createChat(m_chat_id, m_chat_name, m_sender_id);
	END IF;
    INSERT INTO messages_data VALUES(
		new_message_id,
        m_content,
        current_timestamp()
	);
    INSERT INTO messages_meta VALUES(
        new_message_id,
        m_sender_id
    );
    INSERT INTO messages_link VALUES(
		new_message_id,
        m_chat_id
    );
END $$
DELIMITER ;

/* ------------ Triggers ------------*/

DELIMITER $$
CREATE TRIGGER update_last_active
AFTER INSERT ON messages_meta
FOR EACH ROW
BEGIN
	DECLARE msgid varchar(20);
    SET msgid = concat('message_', getLastMessageSenderId());
    UPDATE usersTable_data SET last_active = current_timestamp()
    WHERE user_id = (
		SELECT m_meta_sender_id FROM messages_meta
		WHERE msgid = m_meta_message_id
    );
END $$
DELIMITER ;

/* ------------ Views ------------*/

CREATE VIEW Chat_history AS
SELECT message_id,message_content,message_timestamp
FROM messages_data;

CREATE VIEW User_Info AS
SELECT username,user_og_name,last_active
FROM usersTable_data;

CREATE VIEW Login_Details As
SELECT creds_user_id,user_password
FROM usersTable_creds;