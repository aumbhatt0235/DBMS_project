USE dbsprojecttest;

-- DROP TRIGGER update_last_active;
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