#! /usr/bin/env ruby

positions = File.open('./input', 'r').readlines.first.split(',').map(&:to_i).sort

min_fuel_use = 2**31
min_fuel_pos = -1
(positions.min..positions.max).each do |pos|
  fuel_use = positions.map{|p| (pos - p).abs}.sum
  if fuel_use < min_fuel_use
    min_fuel_use = fuel_use
    min_fuel_pos = pos
  end
end

puts "#{min_fuel_use} fuel at #{min_fuel_pos}"

# 478568: too high
