require 'sqlite3'
require 'Singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true
    self.type_translation = true
  end

  def self.execute(query, *args)
    instance.execute(query, *args)
  end
end
