require 'minitest/autorun'

class PatronsTest < Minitest::Test
  def test_one_patron_with_all_100_percent
    assert_output(<<~EXPECTED, '') do
      # PATRONS

      ----------------------------------

      ## One Patron With All 100 Percent

      - Joe Test

    EXPECTED
      test_file = File.join File.dirname(__FILE__), 'patrons_test.yaml'
      puts `bundle exec thor patrons:generate --patronsfile #{test_file} 'One Patron With All 100 Percent' morning`
    end
  end
end
