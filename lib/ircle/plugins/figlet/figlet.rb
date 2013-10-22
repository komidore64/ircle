require 'artii'
require 'yaml'

FONTS = YAML.load_file("#{File.dirname(File.expand_path(__FILE__))}/fonts.yml")

class Figlet
  include Cinch::Plugin
  include Ircle::Help

  HELP_SECTION = "figlet"
  HELP = "!figlet <text> - display <text> as ascii art"

  match(/figlet .+\z/, :method => :render_figlet, :react_on => :channel)
  match(/figlet .+\z/, :method => :render_figlet, :react_on => :message)

  def render_figlet(m)
    text = m.message
    text.slice!(/\A!figlet/)
    text.strip!

    font = FONTS[:included].sample

    m.reply("rendering with: #{font}")
    figgles = Artii::Base.new(:font => font).asciify(text)

    m.reply(figgles)
  end

end
