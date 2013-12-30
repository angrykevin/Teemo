
CREATE TABLE t_buddy(
  pk INTEGER PRIMARY KEY,
  bid TEXT,
  displayedname TEXT,
  groupname TEXT,
  subscription INTEGER,

  nickname TEXT,
  familyname TEXT,
  givenname TEXT,
  photo TEXT,
  birthday TEXT,
  desc TEXT,
  homepage TEXT
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
