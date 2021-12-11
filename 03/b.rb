#! /usr/bin/env ruby

binary_list = []
File.open('./input', 'r').lines do |line|
  binary_list << line
end
#binary_list = ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"]

oxy_values = binary_list.clone
idx = 0
while oxy_values.length > 1
  #puts '---'
  threshold = oxy_values.length / 2.0
  #puts "thresh #{threshold}"
  #puts oxy_values
  bit_cnt = 0
  oxy_values.each do |value|
    if value[idx] == "1"
      bit_cnt += 1
    end
  end
  #puts "idx #{idx}"
  #puts "bc #{bit_cnt}"

  filter_bit = ((bit_cnt >= threshold) ?  '1' : '0')
  oxy_values = oxy_values.select do |value|
    #puts "val[#{idx}] #{value[idx]} #{filter_bit}"
    value[idx] == filter_bit
  end
  #puts oxy_values.length
  idx += 1
end
#puts oxy_values.length
oxy_rating = oxy_values.first.to_i(2)
puts oxy_rating

co2_values = binary_list.clone
idx = 0
while co2_values.length > 1
  #puts '---'
  threshold = co2_values.length / 2.0
  #puts "thresh #{threshold}"
  #puts co2_values
  bit_cnt = 0
  co2_values.each do |value|
    if value[idx] == "1"
      bit_cnt += 1
    end
  end
  #puts "idx #{idx}"
  #puts "bc #{bit_cnt}"

  filter_bit = ((bit_cnt >= threshold) ?  '0' : '1')
  co2_values = co2_values.select do |value|
    #puts "val[#{idx}] #{value[idx]} #{filter_bit}"
    value[idx] == filter_bit
  end
  #puts co2_values.length
  idx += 1
end
#puts co2_values.first
#puts co2_values.first.to_i(2)
co2_rating = co2_values.first.to_i(2)
puts co2_rating

puts oxy_rating * co2_rating
