require_relative 'questions_database.rb'


class QuestionsFollows

  attr_accessor :id, :question_id, :user_id


  def self.all
    results = QuestionsDatabase.execute(<<-SQL)
      SELECT *
      FROM question_follows
    SQL
    return nil if results.empty?
    results.map{|result| QuestionsFollows.new(result)}
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.execute(<<-SQL, id)
      SELECT *
      FROM question_follows
      WHERE id = ?
    SQL
    return nil if result.empty?
    QuestionsFollows.new(result.first)
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT *
      FROM question_follows
      WHERE question_id = ?
    SQL
    return nil if result.empty?
    QuestionsFollows.new(result.first)
  end

  def self.find_by_user_id(user_id)
    result = QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT *
      FROM question_follows
      WHERE user_id = ?
    SQL
    return nil if result.empty?
    QuestionsFollows.new(result.first)
  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.execute(<<-SQL, question_id)
        SELECT
          users.*
        FROM
          question_follows
        JOIN
          users
        ON question_follows.user_id = users.id
        WHERE
          question_id = ?
      SQL
      return nil if results.empty?
      results.map {|result| Users.new(result)}
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.execute(<<-SQL, user_id)
        SELECT
          questions.*
        FROM
          question_follows
        JOIN
          questions
        ON question_follows.question_id = questions.id
        WHERE
          user_id = ?
      SQL
      return nil if results.empty?
      results.map {|result| Users.new(result)}
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        (SELECT
          question_id
          , count(*) AS counts
        FROM question_follows
        GROUP BY question_id
      ) AS question_follows2
      ON questions.id = question_follows2.question_id
      ORDER BY question_follows2.counts
      LIMIT ?
    SQL
    return nil if results.empty?
    results.map{|result| Questions.new(result)}
  end

  def initialize(options = {})
    @id, @question_id, @user_id = options['id'], options['question_id'], options['user_id']
  end

end
