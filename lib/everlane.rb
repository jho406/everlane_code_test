module Everlane
  module RotoCipher
    LOWER_CASE = ('a'..'z').to_a
    UPPER_CASE = ('A'..'Z').to_a

    def self.rotx(x, str, encrypt = true)
      offset = (x % letter_count)
      offset = -offset unless encrypt
      str    = crypt(offset, str, LOWER_CASE)
      str    = crypt(offset, str, UPPER_CASE)
    end

    private
      def self.letter_count
        LOWER_CASE.length
      end

      def self.crypt(offset, str, letters)
        regex = Regexp.new "[#{letters.join}]"

        str.gsub(regex) do |match|
          index = (letters.index(match) + offset) % letter_count
          letters[index]
        end
      end
  end
end
