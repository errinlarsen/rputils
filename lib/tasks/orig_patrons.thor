require 'yaml'

class OrigPatrons < Thor
  desc 'orig_generate LOCATION TIME_OF_DAY', 'Generate patrons present at location and time-of-day'
  option :patronsfile, type: :string

  def generate(location, time_of_day)
    if options.key? :patronsfile
      @patrons_data = YAML.load_file(options.fetch :patronsfile)
    end

    puts <<~PATRONS
      # PATRONS

      ----------------------------------

      ## #{location}

      - Joe Test

    PATRONS
  end
end

class Character  # < PersonPlaceThing
  attr_accessor :name
  def initialize(name:)
    @name = name
  end
end

class Patron  # < Role
  attr_reader :character, :chances
  def initialize(character:, chances: [])
    @character = character  # belongs_to Character
    @chances = chances.dup
    @original_chances = chances
  end
end

class Patronage  # < Moment-Interval
end

class GatheringPlace  # < Role
  attr_reader :location, :patrons
  def initialize(location:, patrons: [])
    @location = location
    @patrons = patrons.dup
    @original_patrons = patrons
  end
end

class Location  # < PersonPlaceThing
  attr_accessor :name
  def initialize(name:)
    @name = name
  end
end
