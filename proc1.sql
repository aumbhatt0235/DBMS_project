use dbsprojecttest;
drop procedure createNewUser;
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
    WHERE message_id = (
        SELECT message_id FROM messages_meta
        WHERE m_meta_sender_id = del_user_id
    );

    DELETE FROM chat
    WHERE chat_id = (
        SELECT m_link_chat_id FROM messages_link
        WHERE m_link_message_id = (
            SELECT message_id FROM messages_meta
            WHERE m_meta_sender_id = del_user_id
        )
    );

    DELETE FROM chat_users
    WHERE chat_id = (
        SELECT m_link_chat_id FROM messages_link
        WHERE m_link_message_id = (
            SELECT message_id FROM messages_meta
            WHERE m_meta_sender_id = del_user_id
        )
    );

    DELETE FROM messages_link
    WHERE message_id = (
        SELECT message_id FROM messages_meta
        WHERE m_meta_sender_id = del_user_id
    );

    DELETE FROM messages_meta
    WHERE del_user_id = m_link_sender_id;

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