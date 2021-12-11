#! /usr/bin/env ruby

raw_patterns_and_digits = File.open(ARGV[0], 'r').readlines.map{|p| p.strip.split('|').map{|s| s.strip.split ' '}}
puts raw_patterns_and_digits.first[0]
puts raw_patterns_and_digits.first[1]

def identify_digit signal
  return '1' if signal.length == 2
  return '7' if signal.length == 3
  return '4' if signal.length == 4
  return ['2', '3', '5'] if signal.length == 5
  return ['0', '6', '9'] if signal.length == 6
  return '8' if signal.length == 7
  return nil
end

sum = 0
raw_patterns_and_digits.each do |pattern_digits_pair|
  _, digits = pattern_digits_pair
  sum += digits.map{|d| identify_digit d}.select{|d| ['1', '4', '7', '8'].include? d}.count
end
puts sum
