require 'yaml'
require_relative 'patronage'

class NPC
  attr_reader :id
  attr_accessor :name

  FILE_NAME = 'data/npcs.yml'

  def self.all
    npcs = YAML.load_file(FILE_NAME)
    npcs.map { |npc| new(npc) }
  end

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def to_patron
    Patron.new(self)
  end

  class Patron
    def id; @npc.id; end
    def name; @npc.name; end

    def initialize(npc:)
      @npc = npc
    end

    def patronages
      Patronage.all_for(patron: self)
    end

    def present_at?(meeting_place:, time_of_day: nil)
      patronage_at_meeting_place = patronages.find do |patronage|
        patronage.meeting_place_id = meeting_place.id
      end
      return nil if patronage_at_meeting_place.nil?

      chances = patronage_at_meeting_place.chances
      return nil if time_of_day.nil? && chances.empty?

      chance = chances.find { |chance| chance[:defalt] } || chances.first
      return true if chance == 100

      roll = roller.rand(10) * 10 + roller.rand(10)
      roll <= chance
    end

    private

    def roller
      @prng ||= Random.new
    end
  end
end
