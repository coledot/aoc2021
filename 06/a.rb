#! /usr/bin/env ruby

raw_values = File.open('./input', 'r').readlines.first
timers = raw_values.split(',').map(&:to_i)

80.times do |d|
  #puts timers.join ' '
  puts d+1
  puts timers.count
  births = timers.select{|v| v==0}.count
  timers = timers.map{|t| t > 0 ? t-1 : 6}
  timers += [8] * births
end
puts timers.count
