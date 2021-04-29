use dbsprojecttest;
select * from userstable_data;
select * from userstable_creds;
select * from chat;
select * from chat_users;
select * from messages_data;
select * from messages_link;
select * from messages_meta;

select CONCAT('chat_', getNewChatId());

CALL createNewUser('abc123', 'aum', 'Aum Bhatt', 'passab123', current_timestamp());
CALL createNewUser('taf456', 'taf', 'Tafveez Ahmad', 'passtaf456', current_timestamp());

CALL sendMessage(getNewMessageId(), 'Test Message 1', NULL, 'tEST cHAT 1', 'abc123');
CALL sendMessage(getNewMessageId(), 'Test Message 2', NULL, 'tEST cHAT 2', 'taf456');
CALL sendMessage(getNewMessageId(), 'Test Message 3', 'chat_2', 'tEST cHAT 2', 'taf456');
CALL sendMessage(getNewMessageId(), 'Test Message 4', 'chat_2', 'tEST cHAT 2', 'abc123');
CALL sendMessage(getNewMessageId(), 'Test Message 5', 'chat_2', 'tEST cHAT 2', 'abc123');
CALL sendMessage(getNewMessageId(), 'Test Message 6', 'chat_2', 'tEST cHAT 2', 'abc123');
CALL sendMessage(getNewMessageId(), 'Test Message 7', 'chat_2', 'tEST cHAT 2', 'abc123');
CALL createChat('chat_0', 'test 101', 'abc123');
delete from chat where chat_id = 'chat_0';


select getLastMessageSenderId();