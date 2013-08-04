# cinch irc bot api
require 'cinch'

# ircle
require './ircle/help'

# plugins
require './plugins/ircle_figlet/ircle_figlet'

bot = Cinch::Bot.new do

  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#komidore64-testing"]
    c.nick = "ircle"
    c.plugins.plugins << IrcleFiglet
  end

  on :channel, /\A!help/ do |m|
    classes = bot.config.plugins.plugins
    help_arr = classes.inject([]) do |help_arr, klass|
      help_arr << [ klass::HELP_SECTION, klass::HELP ]
    end
    help_text = "help:\n"
    help_text << help_arr.collect { |item| "#{item[0]}\n    #{item[1]}" }.join("\n")
    m.reply(help_text)
  end

end

bot.start
