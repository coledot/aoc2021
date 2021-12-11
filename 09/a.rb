#! /usr/bin/env ruby

filename = ARGV[0].nil? ? 'example' : ARGV[0]
heightmap = File.open(filename, 'r').readlines.map(&:strip).map{|s| s.split('').map(&:to_i)}
heightmap_t = heightmap.first.zip(*heightmap[1..-1])

low_points = []
max_x = heightmap.first.length
max_y = heightmap.length
(0...max_y).each do |y|
  (0...max_x).each do |x|
    val = heightmap[y][x]
    adj_vals = []
    #puts "val(#{x},#{y}): #{val}"

    x_rng = ([0,x-1].max..[max_x-1,x+1].min)
    #puts heightmap[y].to_s
    #puts x_rng.to_s
    tmp_vals = heightmap[y].slice(x_rng)
    tmp_vals.slice!(tmp_vals.index val)
    adj_vals += tmp_vals

    y_rng = ([0,y-1].max..[max_y-1,y+1].min)
    #puts heightmap_t[x].to_s
    #puts y_rng.to_s
    tmp_vals = heightmap_t[x].slice(y_rng)
    tmp_vals.slice!(tmp_vals.index val)
    adj_vals += tmp_vals

    #puts "adjacents: #{adj_vals.to_s}"
    if adj_vals.select{|v| val < v}.count == adj_vals.count
      puts "(#{x},#{y}) #{val} lower than its neighbors #{adj_vals.to_s}"
      low_points << val
    end
  end
end

puts "sum of risk: #{low_points.map{|v| v+1}.sum}"
