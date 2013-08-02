require 'cinch'
require 'artii'

bot = Cinch::Bot.new do

  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#elon-cs"]
    c.nick = "ircle"
  end

  on :channel, /\A!figlet/ do |m|
    text = m.message
    text.slice!(/\A!figlet/)
    text.strip!
    debug "text: #{text}"

    font_list = Artii::Base.new.all_fonts.keys
    font = font_list[rand(font_list.size)]

    m.reply("rendering with: #{font}")
    figgles = Artii::Base.new(:font => font).asciify(text)

    m.reply(figgles)
  end

end

bot.start
