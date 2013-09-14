require 'test_helper'

describe Everlane::DecoderRing do
  before do
    @decoder = Everlane::DecoderRing.new("abcde".split(''))
  end

  after do
    @decoder.reset_pin
  end

  describe '#set_pin' do
    it 'should set the anchor on the decoder wheel' do
      @decoder.set_pin(1)
      @decoder.pin.must_equal 1
    end

    it 'should wrap around if pos is out of range' do
      @decoder.set_pin(11)
      @decoder.pin.must_equal 1
    end
  end

  describe '#reset_pin' do
    it 'should set the anchor on the decoder wheel' do
      @decoder.reset_pin
      @decoder.pin.must_equal 0
    end
  end

  describe '#dial' do
    it 'should return encryption values' do
      @decoder.set_pin(1)
      @decoder.dial([1,2]).must_equal ['c', 'd']

      @decoder.set_pin(0)
      @decoder.dial([0]).must_equal ['a']
      @decoder.dial([1,2]).must_equal ['b', 'c']
    end

    it 'should wrap around like a ring if its out of range' do
      @decoder.set_pin(3)
      @decoder.dial([1,5]).must_equal ['e', 'd']

      @decoder.set_pin(0)
      @decoder.dial([5]).must_equal ['a']
      @decoder.dial([4]).must_equal ['e']

      @decoder.set_pin(11)
      @decoder.dial([1,2]).must_equal ['c', 'd']
      @decoder.dial([5]).must_equal ['b']
      @decoder.dial([4]).must_equal ['a']
      @decoder.dial([11]).must_equal ['c']
    end
  end

  describe '#undial' do
    it 'should return decrypted values' do
      @decoder.set_pin(1)
      #ex:
      #01234
      #abcde
      #eabcd
      @decoder.undial([1,2]).must_equal ['a', 'b']

      @decoder.set_pin(0)
      @decoder.undial([0]).must_equal ['a']
      @decoder.undial([1,2]).must_equal ['b', 'c']
    end

    it 'should wrap around like a ring if its out of range' do
      @decoder.set_pin(3)
      @decoder.undial([1,5]).must_equal ['d', 'c']

      @decoder.set_pin(0)
      @decoder.undial([5]).must_equal ['a']
      @decoder.undial([4]).must_equal ['e']

      @decoder.set_pin(11)
      @decoder.undial([1,2]).must_equal ['a', 'b']
      @decoder.undial([5]).must_equal ['e']
      @decoder.undial([4]).must_equal ['d']
      @decoder.undial([11]).must_equal ['a']
    end
  end

end