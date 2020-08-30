require 'yaml'

class Patronage
  attr_reader :id, :patron_id, :meeting_place_id
  attr_accessor :chances

  FILE_NAME = 'data/patronages.yml'

  def self.all
    patronages_data = YAML.load_file(FILE_NAME)
    patronages_data.map { |patronage_data| new(patronage_data) }
  end

  def self.all_for(patron:)
    all.select { |patronage| patronage.patron_id == patron.id }
  end

  def initialize(id:, patron_id:, meeting_place_id:, chances: {})
    @id = id
    @patron_id = patron_id
    @meeting_place_id = meeting_place_id
    @chances = chances
  end
end
