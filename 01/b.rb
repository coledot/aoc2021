#! /usr/bin/env ruby

increase_count = 0

#depth_list = [199,200,208,210,200,207,240,269,260,263]
depth_list = []
File.open('./input', 'r').lines do |line|
  depth_list << line.to_i
end

last_window_sum = depth_list[0...3].sum
(0...depth_list.length-2).each do |start_idx|
  #puts start_idx
  window_sum = depth_list[start_idx...start_idx+3].sum
  if window_sum > last_window_sum
    #puts "#{window_sum} > #{last_window_sum}"
    increase_count += 1
  end
  last_window_sum = window_sum
end

puts increase_count

