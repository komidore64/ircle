# font_list.rb - one-off script to sort through all of Artii's fonts
require 'artii'
require 'yaml'

def prompt(message, default = nil)
    print("%s " % message)
    result = gets.chomp
    result.empty? ? default : result
end

fonts = YAML.load_file("fonts.yml")

artii_fonts = Artii::Base.new.all_fonts.keys
artii_fonts -= fonts[:included]
artii_fonts -= fonts[:excluded]

artii_fonts.each do |font|
  puts font
  puts
  puts Artii::Base.new(:font => font).asciify("sample text")
  puts
  ret = prompt("include? (default: N)", "N")
  case ret
  when "Y", "y"
    where = :included
  else
    where = :excluded
  end
  fonts[where] << font
  File.open("fonts.yml", "w") do |file|
    file.write(fonts.to_yaml)
  end
  puts
  puts "===================="
end
