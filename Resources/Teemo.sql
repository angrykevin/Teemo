
CREATE TABLE tBuddy(
  pk INTEGER PRIMARY KEY,
  bid TEXT,

  nickname TEXT,
  familyname TEXT,
  givenname TEXT,
  photo TEXT,
  birthday TEXT,
  desc TEXT,
  homepage TEXT, 
  
  groupname TEXT
);

CREATE TABLE tChatlog(
  pk INTEGER PRIMARY KEY,
  passport TEXT,
  date TEXT
);

CREATE TABLE tMessage(
  pk INTEGER PRIMARY KEY,
  passport TEXT,
  content TEXT,
  date TEXT,
  read INTEGER
);
