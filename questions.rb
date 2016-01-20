require_relative 'questions_database.rb'
require_relative 'users.rb'
require_relative 'replies.rb'
require_relative 'question_follows.rb'

class Questions

attr_accessor :id, :title, :body, :author_id


  def self.all
   # execute a SELECT; result in an `Array` of `Hash`es, each
   # represents a single row.
   results = QuestionsDatabase.execute(<<-SQL)
      SELECT *
      FROM
        questions
    SQL
    return nil if results.empty?
   results.map { |result| Questions.new(result) }
  end

  def self.find_by_id(question_id)

    results = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL
    return nil if results.empty?
    Questions.new(results.first)
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.execute(<<-SQL, author_id)
    SELECT *
    FROM
      questions
    WHERE
      author_id = ?
    SQL
    return nil if results.empty?
    results.map {|result| Questions.new(result) }
  end

  def self.find_by_author(fname, lname)
    Users.find_by_name(fname, lname)
  end

  def self.replies(question_id)
    Replies.find_by_question_id(question_id)
  end

  def self.find_by_title(title)
    results = QuestionsDatabase.execute(<<-SQL, title)
    SELECT *
    FROM
      questions
    WHERE
      title = ?
    SQL
    return nil if results.empty?
    Questions.new(results.first)
  end

  def self.followers(question_id)
    QuestionsFollows.followers_for_question_id(question_id)
  end

  def self.most_followed(n)
    QuestionsFollows.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end

  def initialize(options = {})
    @id, @title, @body, @author_id = options['id'], options['title'], options['body'], options['author_id']
  end

end
