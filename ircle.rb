require 'cinch'

require 'ircle'

require 'yaml'

ircle_config = YAML.load_file("./config.yml")

bot = Cinch::Bot.new do

  configure do |c|
    c.server = (ircle_config["server"] || "irc.freenode.org")
    c.channels = (ircle_config["channels"] || ["#channel"])
    c.nick = (ircle_config["nick"] || "ircle")
    c.plugins.plugins << IrcleFiglet
    c.plugins.plugins << Lunchbot
  end

  on :channel, /\A!help/ do |m|
    classes = bot.config.plugins.plugins
    help_arr = classes.inject([]) do |arr, klass|
      arr << [ klass::HELP_SECTION, klass::HELP ]
    end
    help_text = "help:\n"
    help_text << help_arr.collect { |item| "#{item[0]}\n    #{item[1]}" }.join("\n")
    m.reply(help_text)
  end

end

bot.start
