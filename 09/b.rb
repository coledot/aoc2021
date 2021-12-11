#! /usr/bin/env ruby

filename = ARGV[0].nil? ? 'example' : ARGV[0]
heightmap = File.open(filename, 'r').readlines.map(&:strip).map{|s| s.split('').map(&:to_i)}
heightmap_t = heightmap.first.zip(*heightmap[1..-1])

low_coords = []
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
      low_coords << [x,y]
    end
  end
end

basin_sizes = []
puts "low coords found: #{low_coords.to_s}"
checked_coords = []

low_coords.each do |low_point|
  #puts "finding basin from coords: #{low_point}"
  pending_checks = Queue.new.enq low_point
  checked_coords << low_point
  basin_coords = [low_point]

  while pending_checks.length > 0
    x,y = pending_checks.deq
    #puts "checking (#{x},#{y})"

    y_rng = ([0,y-1].max..[max_y-1,y+1].min)
    y_rng.each do |y_i|
      new_point = [x,y_i]
      next if checked_coords.include? new_point
      next if basin_coords.include? new_point

      #puts "val at #{new_point} is #{heightmap[y_i][x]}"
      if (heightmap[y_i][x] < 9) && !(basin_coords.include? new_point)
        #puts "#{new_point} in basin starting at (#{x},#{y})"
        pending_checks.enq new_point
        basin_coords << new_point
      end
      checked_coords << new_point
    end

    x_rng = ([0,x-1].max..[max_x-1,x+1].min)
    x_rng.each do |x_i|
      new_point = [x_i,y]
      next if checked_coords.include? new_point
      next if basin_coords.include? new_point

      #puts "val at #{new_point} is #{heightmap[y][x_i]}"
      if (heightmap_t[x_i][y] < 9) && !(basin_coords.include? new_point)
        #puts "#{new_point} in basin starting at (#{x},#{y})"
        pending_checks.enq new_point
        basin_coords << new_point
      end
      checked_coords << new_point
    end
  end

  puts "basin starting at #{low_point} has size #{basin_coords.count}"
  basin_sizes << basin_coords.count
  #puts "pending checks: #{pending_checks.length}"
end

#puts "#{checked_coords.count} should equal #{max_x * max_y}"
puts basin_sizes.sort.to_s
puts basin_sizes.sort[-3..-1].inject :*

