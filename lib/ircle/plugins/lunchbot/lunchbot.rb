require 'yaml'

class Lunchbot

  class Selection
    FOUR_HOURS_AGO = 14400

    attr_accessor :place, :user
    attr_reader   :time

    def initialize(place=nil, user=nil, time=nil)
      @place = place
      @user  = user
      @time  = time || Time.now

      if @time.is_a? String
        @time = Time.iso8601(@time)
      end
    end

    def save(filename)
      File.open(filename, "w") {|f| f.write("#{@place},#{@user},#{@time.iso8601}") }
      self
    end

    def valid?
      @time > (Time.now - FOUR_HOURS_AGO)
    end

    def to_s
      @place
    end
  end

  include Cinch::Plugin
  include Ircle::Help

  SELF_DIR = File.dirname(File.expand_path(__FILE__))

  RESTAURANTS = YAML.load_file("#{SELF_DIR}/restaurants.yml")
  BEER = YAML.load_file("#{SELF_DIR}/beer.yml") if File.exists?("#{SELF_DIR}/beer.yml")

  SELECTED_LUNCHSPOT = "#{SELF_DIR}/lunchspot"
  SELECTED_BEERSPOT = "#{SELF_DIR}/beerspot"

  HELP_SECTION = "foodbot"
  HELP = "!lunch - where to go for lunch"

  match(/lunch\z/, :method => :decide_restaurant, :react_on => :channel)

  def decide_restaurant(message)
    selection = Selection.new(*File.read(SELECTED_LUNCHSPOT).split(",")) if File.exists?(SELECTED_LUNCHSPOT)
    if selection && selection.valid?
      message.reply("lunch is at #{selection.place}; sorry if you don't like it, blame #{selection.user}")
    else
      message.reply("lunchbot says: #{select(message.user)}")
    end
  end

  def select(user)
    place = RESTAURANTS.sample
    selection = Selection.new(place, user)
    selection.save(SELECTED_LUNCHSPOT)
  end

end
