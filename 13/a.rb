#! /usr/bin/env ruby

require 'set'

filename = ARGV[0] || 'example'
file = File.open(filename, 'r')
line = file.readline
points = Set.new
while not line.strip.empty?
  points << line.split(',').map(&:to_i)
  line = file.readline
end
folds = file.readlines.map{|s| s.strip.split('=')}.map{|f| [f[0][-1], f[1].to_i]}
puts "points: #{points.to_s}"
puts "folds: #{folds.to_s}"

fold = folds.first
#folds.each do |fold|
  idx = fold[0] == 'x' ? 0 : 1
  loc = fold[1]
  points.each do |pt|
    if pt[idx] > loc
      pt[idx] = pt[idx] - 2*(pt[idx] - loc)
    end
  end
  points = points.uniq
#end
puts "points after first fold: #{points.to_s}"
puts "#{points.count}"


