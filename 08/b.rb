#! /usr/bin/env ruby

require 'set'

filename = ARGV[0].nil? ? 'example' : ARGV[0]

raw_patterns_and_digits = File.open(filename, 'r').readlines.map{|p| p.strip.split('|').map{|s| s.strip.split ' '}}

class Decoder
  def initialize pats, digs
    @patterns = pats
    @digits = digs
    @encoding = {}
  end

  def descramble!
    # deduce a by comparing 1 and 7
    if @patterns.select{|s| [2,3].include? s.length}.uniq.count == 2
      validate_and_encode_as seven_signal - one_signal, 'a'
    end
    # deduce b by comparing [0,6,9] to [2,3,5] and to 1
    if @patterns.select{|s| [2,5,6].include? s.length}.uniq.count == 7
      validate_and_encode_as (abfg_mask - adg_mask) - one_signal, 'b'
    end
    # deduce d by comparing [2,3,5] to [0,6,9]
    if @patterns.select{|s| [5,6].include? s.length}.uniq.count == 6
      validate_and_encode_as adg_mask - abfg_mask, 'd'
    end
    # deduce e by comparing 8 to 4 and to 7 and to [2,3,5]
    if @patterns.select{|s| [3,4,5,7].include? s.length}.uniq.count == 6
      validate_and_encode_as eg_mask - adg_mask, 'e'
    end
    # deduce f by comparing [0,6,9] to [2,3,5] and to 4 and to 1
    if @patterns.select{|s| [4,5,6].include? s.length}.uniq.count == 7
      validate_and_encode_as (abfg_mask - adg_mask) - bd_mask, 'f'
    end
    # deduce g by comparing 8 to 4 and to 7 and to the encoding
    if @patterns.select{|s| [3,4,7].include? s.length}.uniq.count == 3
      validate_and_encode_as eg_mask - Set.new(@encoding.keys), 'g'
    end
    # finally, c is whatever mapping remains
    validate_and_encode_as eight_signal - Set.new(@encoding.keys), 'c'
    #puts "encoding: #{@encoding.to_s}"
  end

  def decode_digits
    return @digits.map{ |signal| signal_to_digit decode(signal) }.join('')
  end

  S2D = {
    'abcefg'  => '0',
    'cf'      => '1',
    'acdeg'   => '2',
    'acdfg'   => '3',
    'bcdf'    => '4',
    'abdfg'   => '5',
    'abdefg'  => '6',
    'acf'     => '7',
    'abcdefg' => '8',
    'abcdfg'  => '9'
  }
  def signal_to_digit signal
    return S2D[signal.split('').sort.join('')]
  end

  def decode signal
    return signal.split('').map{|c| @encoding[c]}.join('')
  end

  private

  def one_signal
    Set.new @patterns.select{|s| s.length == 2}.uniq.first.split('')
  end

  def four_signal
    Set.new @patterns.select{|s| s.length == 4}.uniq.first.split('')
  end

  def seven_signal
    Set.new @patterns.select{|s| s.length == 3}.uniq.first.split('')
  end

  def eight_signal
    Set.new @patterns.select{|s| s.length == 7}.uniq.first.split('')
  end

  def abfg_mask
    length_six_signals = @patterns.select{|s| s.length == 6}.map{|s| Set.new s.split('')}
    #puts "len 6 signals: #{length_six_signals}"
    return length_six_signals.reduce(&:intersection)
  end

  def adg_mask
    length_five_signals = @patterns.select{|s| s.length == 5}.map{|s| Set.new s.split('')}
    #puts "len 5 signals: #{length_five_signals}"
    return length_five_signals.reduce(&:intersection)
  end

  def eg_mask
    return eight_signal - abcdf_mask
  end

  def bd_mask
    return four_signal - one_signal
  end

  def abcdf_mask
    return four_signal + seven_signal
  end

  def validate_and_encode_as segments, mapped
    #puts "deducing '#{mapped}'"
    #puts "segments: #{segments}"
    if segments.count == 1
      #puts "#{segments.first} maps to '#{mapped}'"
      @encoding[segments.first] = mapped
    end
  end
end

sum = 0
raw_patterns_and_digits.each do |pair|
  patterns, digits = pair
  #puts "patterns: #{patterns.join ' '}"
  #puts "digits: #{digits.join ' '}"
  dec = Decoder.new patterns, digits
  dec.descramble!
  decoded = dec.decode_digits
  #puts "decoded: #{decoded}"
  sum += decoded.to_i
end
puts sum
