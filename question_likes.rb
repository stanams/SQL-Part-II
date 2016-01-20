require_relative 'questions_database.rb'

class QuestionsLikes

  attr_accessor :id, :likes, :question_id, :user_id


  def self.all
    results = QuestionsDatabase.execute(<<-SQL)
      SELECT *
      FROM question_likes
    SQL
    return nil if results.empty?
    results.map{|result| QuestionsLikes.new(result)}
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.execute(<<-SQL, id)
      SELECT *
      FROM question_likes
      WHERE id = ?
    SQL
    return nil if result.empty?
    QuestionsLikes.new(result.first)
  end

  def self.find_by_likes(likes)
    result = QuestionsDatabase.execute(<<-SQL, likes)
      SELECT *
      FROM question_likes
      WHERE likes = ?
    SQL
    return nil if result.empty?
    QuestionsLikes.new(result.first)
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT *
      FROM question_likes
      WHERE question_id = ?
    SQL
    return nil if result.empty?
    QuestionsLikes.new(result.first)
  end

  def self.find_by_user_id(user_id)
    result = QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT *
      FROM question_likes
      WHERE user_id = ?
    SQL
    return nil if result.empty?
    QuestionsLikes.new(result.first)
  end

  def self.likers_for_question_id(question_id)
    result = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT users.*
      FROM users
      JOIN question_likes
      ON users.id = question_likes.user_id
      WHERE question_id = ?
    SQL
    return nil if result.empty?
    QuestionsLikes.new(result.first)
  end

  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT COUNT(*)
      FROM question_likes
      WHERE question_id = ?
    SQL
    result.first['COUNT(*)']
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT questions.*
      FROM questions
      JOIN question_likes
        ON questions.id = question_likes.question_id
      WHERE user_id = ?
    SQL
    results.map{ |result| Questions.new(result) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.execute(<<-SQL, n)
      SELECT questions.*
      FROM
        questions
      JOIN (SELECT
          question_id
          , COUNT(*) AS counts
        FROM question_likes
        GROUP BY question_id
      ) AS question_likes2
      ON questions.id = question_likes2.question_id
      ORDER BY counts DESC
      LIMIT ?
    SQL
    return nil if results.empty?
    results.map {|result| Questions.new(result) }
  end

  def initialize(options = {})
    @id, @likes, @question_id, @user_id = options['id'], options['likes'], options['question_id'], options['user_id']
  end

end
