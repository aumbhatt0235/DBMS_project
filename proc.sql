-- DROP PROCEDURE sendMessage;

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