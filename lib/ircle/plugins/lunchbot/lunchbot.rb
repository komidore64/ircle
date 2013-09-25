require 'yaml'

class Lunchbot
  include Cinch::Plugin
  include Ircle::Help

  PLACES = YAML.load_file("#{File.dirname(File.expand_path(__FILE__))}/restaurants.yml")

  HELP_SECTION = "lunchbot"
  HELP = "!lunch - figure out where to go to lunch!"

  match(/lunch\z/, :method => :decide_restaurant, :react_on => :channel)

  def decide_restaurant(m)
    m.reply("lunchbot says: #{PLACES.sample}")
  end

end
