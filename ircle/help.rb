module Ircle

  module Help

    def help_name
      self.class.name
    end

    def help
      "help not found for [ #{help_name} ]"
    end

  end

end
