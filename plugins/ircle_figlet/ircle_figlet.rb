require 'artii'

class IrcleFiglet
  include Cinch::Plugin
  include Ircle::Help

  match(/figlet.+\z/, :method => :render_figlet, :react_on => :channel)

  def render_figlet(m)
    text = m.message
    text.slice!(/\A!figlet/)
    text.strip!

    font_list = Artii::Base.new.all_fonts.keys
    font = font_list[rand(font_list.size)]

    m.reply("rendering with: #{font}")
    figgles = Artii::Base.new(:font => font).asciify(text)

    m.reply(figgles)
  end

  def help
    "!figlet <text> --> display <text> as ascii art"
  end

end
