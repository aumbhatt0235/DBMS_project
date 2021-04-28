USE dbsprojecttest;

CREATE VIEW Chat_history AS
SELECT message_id,message_content,message_timestamp
FROM messages_data;

SELECT * FROM Chat_history;

CREATE VIEW User_Info AS
SELECT username,user_og_name,last_active
FROM usersTable_data;

SELECT * FROM User_Info;

CREATE VIEW Login_Details As
SELECT creds_user_id,user_password
FROM usersTable_creds;

SELECT * FROM Login_Details;