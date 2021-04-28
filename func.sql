use dbsprojecttest;
select * from usersTable_data;
select * from chat;

drop function getNewChatId;
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

drop function getNewMessageId;
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
select CONCAT('message_', getNewMessageId());

DROP FUNCTION getLastMessageSenderId;
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