require 'test_helper'

describe Everlane::RotoCipher do
  before do
    @decoder = Everlane::DecoderRing.new("abcdefghijklmnopqrstuvwxyz".split(''))
    @cipher = Everlane::RotoCipher.new(@decoder)
  end

  after do
    @decoder.reset_pin
  end

  describe '#rotx' do
    describe 'when encrypting' do
      it 'should encrypt a lower case string' do
        @cipher.rotx(10, 'hello').must_equal 'rovvy'
      end

      it 'should encrypt uppers and lowers respectively' do
        @cipher.rotx(10, 'Hello').must_equal 'Rovvy'
      end

      it 'should encrypt only A-Z and a-z with rotations > 26' do
        @cipher.rotx(36, 'Hello, World').must_equal('Rovvy, Gybvn')
      end
    end

    describe 'when decrypting' do
      it 'should decrypt a lower case string' do
        @cipher.rotx(10, 'rovvy', false).must_equal 'hello'
      end

      it 'should encrypt uppers and lowers respectively' do
        @cipher.rotx(10, 'Rovvy', false).must_equal 'Hello'
      end

      it 'should encrypt only A-Z and a-z with rotations > 26' do
        @cipher.rotx(36, 'Rovvy, Gybvn', false).must_equal('Hello, World')
      end
    end
  end
end