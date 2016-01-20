require_relative 'questions_database.rb'
require_relative 'questions.rb'
require_relative 'replies.rb'
require_relative 'question_follows.rb'

class Users

  attr_accessor :id, :fname, :lname

  def self.all
    results = QuestionsDatabase.execute(<<-SQL)
      SELECT *
      FROM users
    SQL
    return nil if result.empty?
    results.map{|result| Users.new(result)}
  end

  def self.find_by_id(user_id)
    result = QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT *
      FROM users
      WHERE id = ?
    SQL
    return nil if result.empty?
    Users.new(result.first)
  end

  def self.find_by_fname(fname)
    result = QuestionsDatabase.execute(<<-SQL, fname)
      SELECT *
      FROM users
      WHERE fname = ?
    SQL
    return nil if result.empty?
    Users.new(result.first)
  end

  def self.find_by_lname(lname)
    result = QuestionsDatabase.execute(<<-SQL, lname)
      SELECT *
      FROM users
      WHERE lname = ?
    SQL
    return nil if result.empty?
    Users.new(result.first)
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname = ?
      AND lname = ?
    SQL
    return nil if result.empty?
    Users.new(result.first)
  end

  def self.authored_questions(author_id)
    Questions.find_by_author_id(author_id)
  end

  def self.authored_replies(user_id)
    Replies.find_by_author_id(user_id)
  end

  def self.followed_questions(user_id)
    QuestionsFollows.followers_for_user_id(user_id)
  end

  def self.average_karma
    result = QuestionsDatabase.execute(<<-SQL, fname, lname)
      SELECT
        users.id
        , question_likes2.counts / questions2.question_counts AS karma
      FROM users
      JOIN (SELECT
              author_id
              , COUNT(*) as question_counts
            FROM
              question
            GROUP BY author_id
        ) questions2
      ON users.id = questions2.author_id
      JOIN (SELECT
              question_id
              , COUNT(*) AS counts
            FROM
              question_likes
            GROUP BY question_id
            ) AS question_likes2
      ON question_likes2.question_id = questions2.question_id
    SQL
  end

  def initialize(options = {})
    @id, @fname, @lname = options['id'], options['fname'], options['lname']
  end
#stored in db: obj(id = 1, fname = 'Stan', lname 'Amsellem')
#objobj(id = 1, fname = 'Stephen', lname 'Saekoo')
  def save
    if !self.id.nil?
      QuestionsDatabase.execute(<<-SQL)
      UPDATE TABLE
        users
      SET
        fname = #{self.fname}
        lname = #{self.lname}
      WHERE
        users.id = #{self.id}
    SQL
    else
      QuestionsDatabase.execute(<<-SQL)
      INSERT INTO users
        (fname, lname)
      VALUES
        (#{self.fname}, #{self.lname})
      SQL
    end
  end
end
