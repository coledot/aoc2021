#! /usr/bin/env ruby

filename = ARGV[0].nil? ? './example' : ARGV[0]
raw_values = File.open(filename, 'r').readlines.first
timers = raw_values.split(',').map(&:to_i).group_by(&:itself).transform_values{|v| v.count}
timers.default = 0

256.times do |d|
  puts d+1
  puts timers.to_s

  births = timers[0]
  (1..8).to_a.each do |k|
    timers[k-1] = timers[k]
  end
  puts "#{births} births"
  timers[8] = births
  timers[6] += births
end

puts timers.values.sum
