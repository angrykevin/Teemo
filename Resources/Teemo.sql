
CREATE TABLE tBuddy(
  pk INTEGER PRIMARY KEY,
  passport TEXT,
  name TEXT,
  desc TEXT
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
