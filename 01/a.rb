#! /usr/bin/env ruby

increase_count = 0
last_depth = 104
File.open('./input', 'r').lines do |line|
  depth = line.to_i
  puts depth
  if depth > last_depth
    increase_count += 1
  end
  last_depth = depth
end

puts increase_count

