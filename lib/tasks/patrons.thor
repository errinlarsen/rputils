require 'yaml'
require 'pry'

class Patrons < Thor
  desc 'generate', 'Generate patrons for The Brazen Strumpet'

  def generate
    @d100 = D100.new
    table_data = YAML.load_file('data/brazen_strumpet.yml')

    location_name = table_data.keys.first
    patrons_data = table_data[location_name]

    response = ask(<<~ASK_TOD, :limited_to => %w[1 2 3])
      Please choose:
        1. Morning
        2. Afternoon
        3. Evening
    ASK_TOD

    chances_index = response.to_i - 1
    time_of_day = case response.to_i
    when 1 then 'Morning'
    when 2 then 'Afternoon'
    when 3 then 'Evening'
    else raise "Something went wrong!"
    end

    patrons_present = patrons_data.map do |patron|
      chance = patron['chances'][chances_index]
      roll = @d100.roll
      next unless roll <= chance
      "- (Roll => %3d) #{' '*10}%-32s" % [roll, patron['name']]
    end.compact

    location_header = '## %-21s   %9s' % [location_name, time_of_day]
    puts <<~PATRONS
      # PATRONS
      ----------------------------------

      #{location_header}

      #{patrons_present.join("\n")}

    PATRONS
  end

  class D100
    def initialize(seed = beginning_of_day)
      Random.srand(seed.to_i)
    end

    def roll
      actual_roll = Random.rand(10) * 10 + Random.rand(10)
      actual_roll == 00 ? 100 : actual_roll
    end

    private

    def now
      Time.now
    end

    def beginning_of_day
      Time.new(now.year, now.month, now.day, 0)
    end
  end
end
