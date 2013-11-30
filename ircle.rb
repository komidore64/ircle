require 'cinch'
require 'yaml'

ircle_config = YAML.load_file("./config.yml")

Cinch::Bot.new do

  configure do |c|
    c.server = ircle_config["server"]
    c.channels = ircle_config["channels"]
    c.nick = ircle_config["nick"]
    c.plugins.plugins << Figlet
    c.plugins.plugins << Lunchbot
    c.plugins.plugins << Stockerbot
    c.plugins.plugins << Googlebot
  end

  on :channel, /\A!help/ do |m|
    classes = bot.config.plugins.plugins

    help_arr = classes.inject([]) do |arr, klass|
      arr << [ klass.help_section, klass.help ]
    end

    help_text = "help:\n"
    help_text << help_arr.collect do |item|
      "#{item[0]}\n#{item[1].collect { |sub| "    #{sub}" }.join("\n")}"
    end.join("\n")

    m.reply(help_text)
  end

end.start
