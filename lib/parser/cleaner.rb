module NewsAgg
  module Parser
    module Cleaner

      private
        def clean_whitespace(text)
          text.gsub(/\s{2,}|\t|\n/, ' ').strip
        end

    end
  end
end
