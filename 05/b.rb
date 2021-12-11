#! /usr/bin/env ruby

point_pairs = []
File.open('./input', 'r').lines do |line|
  point = line.split(' -> ').map{|s| s.split(',').map(&:to_i)}
  point_pairs << point
end
# sort each pair by x values
point_pairs = point_pairs.map{|p| p.sort{|l,r| l[0] <=> r[0]}}

point_counts = Hash.new 0
point_pairs.each do |pair|
  start = pair[0]
  _end = pair[1]
  if start[0] == _end[0]
    # x1 == x2
    lower = [start[1], _end[1]].min
    upper = [start[1], _end[1]].max
    (lower..upper).each do |idx|
      new_point = [start[0], idx]
      point_counts[new_point] += 1
    end
  elsif start[1] == _end[1]
    # y1 == y2
    lower = [start[0], _end[0]].min
    upper = [start[0], _end[0]].max
    (lower..upper).each do |idx|
      new_point = [idx, start[1]]
      point_counts[new_point] += 1
    end
  elsif (start[0] == _end[1]) && (start[1] == _end[0])
    # diagonal up
    puts "diag up #{start.to_s} #{_end.to_s}"
    range = (start[1].._end[1])
    if start[1] > _end[1]
      range = (_end[1]..start[1]).to_a.reverse
    end
    (start[0].._end[0]).zip(range).each do |point|
      puts point.to_s
      point_counts[point] += 1
    end
  else
    # diagonal down
    puts "diag down #{start.to_s} #{_end.to_s}"
    range = (start[1].._end[1])
    if start[1] > _end[1]
      range = (_end[1]..start[1]).to_a.reverse
    end
    (start[0].._end[0]).zip(range).each do |point|
      puts point.to_s
      point_counts[point] += 1
    end
  end
end

two_or_more_overlaps = point_counts.values.select{|v| v >= 2}
puts two_or_more_overlaps.to_s
puts two_or_more_overlaps.count

