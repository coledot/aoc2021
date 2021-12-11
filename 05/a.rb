#! /usr/bin/env ruby

point_pairs = []
File.open('./input', 'r').lines do |line|
  point = line.split(' -> ').map{|s| s.split(',').map(&:to_i)}
  if (point[0][0] == point[1][0]) || (point[0][1] == point[1][1])
    puts "adding point #{point.to_s}"
    point_pairs << point
  end
end

point_counts = Hash.new 0
point_pairs.each do |pair|
  if pair[0][0] == pair[1][0]
    # x1 == x2
    lower = [pair[0][1], pair[1][1]].min
    upper = [pair[0][1], pair[1][1]].max
    (lower..upper).each do |idx|
      new_point = [pair[0][0], idx]
      point_counts[new_point] += 1
    end
  else
    # y1 == y2
    lower = [pair[0][0], pair[1][0]].min
    upper = [pair[0][0], pair[1][0]].max
    (lower..upper).each do |idx|
      new_point = [idx, pair[0][1]]
      point_counts[new_point] += 1
    end
  end
end

two_or_more_overlaps = point_counts.values.select{|v| v >= 2}
puts two_or_more_overlaps.to_s
puts two_or_more_overlaps.count

