module Everlane
  class RotoCipher
    ASCII_ANCHOR = 97
    attr_reader :decoder

    def initialize(decoder)
      @decoder = decoder
    end

    def rotx(x, str, encrypt = true)
      decoder.set_pin(x)
      crypt_string(str, encrypt)
    end

    private
      def crypt_string(str, encrypt)
        mthd = encrypt ? :dial : :undial
        str = crypt_lowers(str, mthd)
        str = crypt_uppers(str, mthd)
        return str
      end

      def char_index(char)
        char.ord - ASCII_ANCHOR;
      end

      def crypt_lowers(str, mthd)
        str.gsub(/[a-z]+/) do |match|
          decoder.send(mthd, convert_to_dial(match)).join
        end
      end

      def crypt_uppers(str, mthd)
        str.gsub(/[A-Z]+/) do |match|
          lower = match.downcase
          converted = decoder.send(mthd, convert_to_dial(lower)).join
          converted.upcase
        end
      end

      def convert_to_dial(str)
        str.split('').map {|c| char_index(c)}
      end
  end

  class DecoderRing
    attr_reader :pin

    def initialize(values);
      @values = values
      @length = values.length
      @pin = 0
    end

    def undial(positions)
      offsets = positions.map do |pos|
        pos - @pin
      end

      offsets.map do |pos|
        @values[normalize_position(pos, 0)]
      end
    end

    def set_pin(pos)
      @pin = pos.divmod(@length)[1]
    end

    def reset_pin
      @pin = 0
    end

    def dial(positions)
      positions.map do |p|
        @values[normalize_position(p, @pin)]
      end
    end

    private

      def normalize_position(pos, pin)
        (pos + pin).divmod(@length)[1]
      end
  end
end
