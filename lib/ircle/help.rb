module Ircle

  module Help

    module ClassMethods

      def help
        [self::HELP || "help not found for [ #{help_name} ]"].flatten
      end

      def help_section
        self::HELP_SECTION || self.class.name
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end

end
