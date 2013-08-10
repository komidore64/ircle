module Ircle

  module Help

    def self.help
      HELP || "help not found for [ #{help_name} ]"
    end

    def self.help_section
      HELP_SECTION || self.class.name
    end

  end

end
