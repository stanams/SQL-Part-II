require_relative 'questions_database.rb'

class Replies

  attr_accessor :id, :question_id, :parent_reply_id, :author_id, :body

  def self.all
    results = QuestionsDatabase.execute(<<-SQL)
      SELECT *
      FROM replies
    SQL
    return nil if results.empty?
    results.map{|result| Replies.new(result)}
  end

  def self.find_by_id(reply_id)
    result = QuestionsDatabase.execute(<<-SQL, reply_id)
      SELECT *
      FROM replies
      WHERE id = ?
    SQL
    return nil if result.empty?
    Replies.new(result.first)
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT *
      FROM replies
      WHERE question_id = ?
    SQL
    return nil if result.empty?
    Replies.new(result.first)
  end

  def self.find_by_parent_reply_id(parent_reply_id)
    result = QuestionsDatabase.execute(<<-SQL, parent_reply_id)
      SELECT *
      FROM replies
      WHERE parent_reply_id = ?
    SQL
    return nil if result.empty?
    Replies.new(result.first)
  end

  def self.find_by_user_id(author_id)
    result = QuestionsDatabase.execute(<<-SQL, author_id)
      SELECT *
      FROM replies
      WHERE author_id = ?
    SQL
    return nil if result.empty?
    Replies.new(result.first)
  end


  def initialize(options = {})
    @id, @question_id, @parent_reply_id, @author_id, @body = options['id'], options['question_id'], options['parent_reply_id'], options['author_id'], options['body']
  end

end
