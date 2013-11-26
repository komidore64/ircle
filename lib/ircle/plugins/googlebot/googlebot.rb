require 'rest-client'

class Google
  include Cinch::Plugin
  include Ircle::Help

  HELP_SECTION = "google"
  HELP = "!google <text> - google <text> for me please"

  match(/google (.+)/, :method => :lmgtfy, :react_on => :channel)
  match(/google (.+)/, :method => :lmgtfy, :react_on => :private)

  def lmgtfy(message, search_str)
    m.reply(RestClient.get(URI.escape("http://tinyurl.com/api-create.php?url=http://lmgtfy.com/?q=#{search_str}")))
  end
end
