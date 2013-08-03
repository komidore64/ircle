# cinch irc bot api
require 'cinch'

# ircle
require './ircle/help'

# plugins
require './plugins/ircle_figlet/ircle_figlet'

bot = Cinch::Bot.new do

  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#elon-cs"]
    c.nick = "ircle"
    c.plugins.plugins << IrcleFiglet
  end

  on :channel, /\A!help/ do |m|
    m.reply("help stuff goes here")
  end

end

bot.start
