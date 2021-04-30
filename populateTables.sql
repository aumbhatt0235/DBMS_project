USE dbsproject;
CALL createNewUser('abc123', 'aum', 'Aum Bhatt', 'passab123', current_timestamp());
CALL createNewUser('taf456', 'taf', 'Tafveez Ahmad', 'passtaf456', current_timestamp());
CALL createNewUser('arc789', 'aardch', 'Aaradhya Chauhan', 'passarc789', current_timestamp());

CALL sendMessage(getNewMessageId(), 'Test Message 1', NULL, 'Nerd_Gang', 'abc123');
CALL sendMessage(getNewMessageId(), 'Test Message 2', NULL, 'Rockstars', 'taf456');
CALL sendMessage(getNewMessageId(), 'Test Message 2', NULL, 'FunkyBoys', 'arc789');
CALL sendMessage(getNewMessageId(), 'Test Message 3', 'chat_2', 'Nerd_Gang', 'taf456');
CALL sendMessage(getNewMessageId(), 'Test Message 4', 'chat_3', 'Rockstars', 'abc123');
CALL sendMessage(getNewMessageId(), 'Test Message 5', 'chat_4', 'FunkyBoys', 'abc123');
CALL sendMessage(getNewMessageId(), 'Test Message 6', 'chat_2', 'Nerd_Gang', 'arc789');
CALL sendMessage(getNewMessageId(), 'Test Message 7', 'chat_4', 'FunkyBoys', 'abc123');

call deleteUser("taf456");