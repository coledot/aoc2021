#! /usr/bin/env ruby

filename = ARGV[0] || 'example'
energy_levels = File.open(filename, 'r').readlines.map{|s| s.strip.split('').map(&:to_i)}

class Octopus
  def initialize energy
    @energy = energy
    @flashing = false
  end
  attr_accessor :flashing

  def energize!
    unless @flashing
      @energy += 1
      if @energy > 9
        @flashing = true
      end
      return @flashing
    end
    return false
  end

  def discharge!
    if @flashing
      @energy = 0
      @flashing = false
    end
  end

  def to_s
    #"#{@energy}, is #{@flashing ? '' : 'NOT '}flashing"
    formatting = "%4d"
    if @energy == 0
      # bold white
      formatting = "\e[97m#{formatting}\e[0m"
    end
    formatting % @energy.to_s
  end
end

class OctopusGrid
  def initialize grid
    @grid = grid.map do |row|
      row.map do |val|
        Octopus.new val
      end
    end
    @lifetime_flash_count = 0
    @tick_flash_count = 0
  end
  attr_reader :lifetime_flash_count
  attr_reader :tick_flash_count

  def tick!
    @tick_flash_count = 0
    @grid.each_with_index do |row, y|
      row.each_with_index do |octo, x|
        #puts "octo: #{octo.to_s} point: #{[x,y].to_s}"
        recursive_energize! octo, [x,y]
      end
    end
    @grid.each do |row|
      row.each do |octo|
        octo.discharge!
      end
    end
  end

  def recursive_energize! octo, point
    #puts "energizing octo at #{point.to_s}"
    if octo.energize!
      #puts "octo at #{point.to_s} is energized!"
      @tick_flash_count += 1
      @lifetime_flash_count += 1
      x_rng = ([point[0]-1,0].max..[point[0]+1,@grid.first.count-1].min).to_a
      y_rng = ([point[1]-1,0].max..[point[1]+1,@grid.count-1].min).to_a
      new_points = x_rng.product(y_rng).uniq - [point]
      #puts "new_points: #{new_points}"
      new_points.each do |new_pt|
        #puts "recursing into point #{new_pt.to_s}"
        recursive_energize! @grid[new_pt[1]][new_pt[0]], new_pt
      end
    end
  end

  def to_s
    @grid.map{ |row| row.join ' '}.join "\n"
  end

  def count
    @grid.map{ |row| row.count}.reduce :+
  end
end

grid = OctopusGrid.new energy_levels
t = 1
while true
  #puts t
  grid.tick!
  #puts grid
  break if grid.tick_flash_count == grid.count
  t += 1
end
puts grid
puts t
