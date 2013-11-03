namespace :clean do

  desc "remove selected lunch location"
  task :lunch do
    lunchfile = File.join([File.expand_path(File.dirname(__FILE__)), "lib", "ircle", "plugins", "lunchbot", "lunchspot"])
    FileUtils.rm(lunchfile)
    puts "lunch selection removed"
  end

end
