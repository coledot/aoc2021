#! /usr/bin/env ruby

command_list = []
File.open('./input', 'r').lines do |line|
  direction, distance = line.split ' '
  command_list << [direction, distance.to_i]
end

length = 0
depth = 0

command_list.each do |cmd|
  direction, distance = cmd

  case direction
  when 'forward' then length += distance
  when 'down' then depth += distance
  when 'up' then depth -= distance
  else puts "wtf: #{direction}"
  end
end
puts length * depth
