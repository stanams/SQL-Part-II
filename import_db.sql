DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id INTEGER PRIMARY KEY
  , fname VARCHAR(500) NOT NULL
  , lname VARCHAR(500) NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Stan', 'Amsellem'), ('Stephen', 'Saekoo'), ('Luke', 'Skywalker');


DROP TABLE IF EXISTS questions;
CREATE TABLE questions(
  id INTEGER PRIMARY KEY
  , title VARCHAR(500) NOT NULL
  , body text NOT NULL
  , author_id INTEGER NOT NULL
  , FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  questions (title, body, author_id)
SELECT
  'Luke question', 'Tell me about how you feel today', users.id
FROM
  users
WHERE
  users.fname = "Luke" AND users.lname = "Skywalker";

INSERT INTO
  questions (title, body, author_id)
SELECT
  'Stephen question', 'I am fine how are you Stan?', users.id
FROM
  users
WHERE
  users.fname = "Stephen" AND users.lname = "Saekoo";

INSERT INTO
  questions (title, body, author_id)
SELECT
  'Stan question', 'I am also fine how are you?', users.id
FROM
  users
WHERE
  users.fname = "Stan" AND users.lname = "Amsellem";

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY
  , question_id INTEGER NOT NULL
  , user_id INTEGER NOT NULL
  , FOREIGN KEY (question_id) REFERENCES questions(id)
  , FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Stan" AND lname = "Amsellem"),
  (SELECT id FROM questions WHERE title = "Stan question")),

  ((SELECT id FROM users WHERE fname = "Stephen" AND lname = "Saekoo"),
  (SELECT id FROM questions WHERE title = "Stephen question")
);


DROP TABLE IF EXISTS replies;
CREATE TABLE replies(
  id INTEGER PRIMARY KEY
  , question_id INTEGER
  , parent_reply_id INTEGER
  , author_id INTEGER
  , body TEXT NOT NULL
  , FOREIGN KEY (question_id) REFERENCES questions(id)
  , FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
  , FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  replies (question_id, parent_reply_id, author_id, body)
SELECT
  questions.id
  , replies.id
  , users.id
  , 'blah blah blah'
FROM
  questions
JOIN
  users
ON questions.author_id = users.id
LEFT JOIN
  replies
ON replies.question_id = questions.id
WHERE
  users.fname = "Luke";



DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY
  , question_id INTEGER NOT NULL
  , user_id INTEGER NOT NULL
  , FOREIGN KEY (question_id) REFERENCES questions(id)
  , FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (1, 2), (2, 2)

# other way to find luke and make him like question 1
-- INSERT INTO
--   questions_likes (question_id, user_id)
-- SELECT
--   1, users.id
-- FROM users
-- WHERE users.fname = 'Luke'
