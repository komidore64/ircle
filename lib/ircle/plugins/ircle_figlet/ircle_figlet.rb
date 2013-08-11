require 'artii'
require 'yaml'

FIGLET_YAML = "#{File.dirname(File.expand_path(__FILE__))}/figlet.yml"
FIGLET_YAML_STRUCTURE = {"excluded" => []}

class IrcleFiglet
  include Cinch::Plugin
  include Ircle::Help

  HELP_SECTION = "figlet"
  HELP = "!figlet <text> - display <text> as ascii art"

  match(/figlet .+\z/, :method => :render_text, :react_on => :channel)
  match(/figlet#exclude .+\z/, :method => :exclude_font, :react_on => :channel)
  match(/figlet#include .+\z/, :method => :include_font, :react_on => :channel)
  match(/figlet#list .+\z/, :method => :list_fonts, :react_on => :channel)

  def render_text(m)
    text = m.message
    text.slice!(/\A!figlet/)
    text.strip!

    font_list = Artii::Base.new.all_fonts.keys
    font = font_list[rand(font_list.size)]

    m.reply("rendering with: #{font}")
    figgles = Artii::Base.new(:font => font).asciify(text)

    m.reply(figgles)
  end

  def exclude_font(m)
    text = m.message
    text.slice!(/\A!figlet#exclude/)
    font = text.strip!

    save_font_exclusion(font)
    m.reply("[ #{font} ] excluded from figlet")
  end

  def include_font(m)
    text = m.message
    text.slice!(/\A!figlet#include/)
    text.strip!

  end

  def list_fonts(m)
    text = m.message
    text.slice!(/\A!figlet#list/)
    text.strip!

  end

  private

  def save_font_exclusion(font)
    hash = YAML.load(get_figlet_file())
    hash["excluded"] << font

    get_figlet_file("w") do |file|
      file.write(hash.to_yaml)
    end

  end

  def save_font_inclusion(font)

  end

  def font_list(font_set)
    case font_set
    when :excluded
    when :included
    else
      return Artii::Base.new.all_fonts.keys
    end
  end

  def get_figlet_file(file_action = "r")

    if !File.exists?(FIGLET_YAML)
      File.open(FIGLET_YAML, "w") do |f|
        f.write(FIGLET_YAML_STRUCTURE.to_yaml)
      end
    end

    if block_given?
      File.open(FIGLET_YAML, file_action) do |file|
        yield(file)
      end
    else
      File.open(FIGLET_YAML, file_action)
    end
  end

end

class IrcleFigletError < RuntimeError

  def initialize(message = "")
    super(message)
  end

end

class FontAlreadyExcludedError < IrcleFigletError

  def initialize(message = "font has already been excluded from IrcleFiglet's output")
    super(message)
  end

end

class FontAlreadyIncludedError < IrcleFigletError

  def initialize(message = "font has already been included for IrcleFiglet's output")
    super(message)
  end

end

class FontNotFoundError < IrcleFigletError

  def initialize(message = "font not found")
    super(message)
  end

end
