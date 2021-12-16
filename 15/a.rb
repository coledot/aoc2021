#! /usr/bin/env ruby

filename = ARGV[0] || 'example'
cost_map = File.open(filename, 'r').readlines.map{|s| s.strip.split('').map(&:to_i)}
y_max = cost_map.count-1
x_max = cost_map.first.count-1

# https://en.wikipedia.org/wiki/Dijkstra's_algorithm

class Vertex
  def initialize cost, point
    @cost = cost
    @point = point
  end
  attr_accessor :cost, :point

  def < other
    @cost < other.cost
  end

  def <= other
    @cost <= other.cost
  end

  def > other
    @cost > other.cost
  end

  def >= other
    @cost >= other.cost
  end

  def to_s
    "[#{@cost}, [#{@point[0]}, #{@point[1]}]]"
  end
end

vertices = []
cost_map.each_with_index do |cost_row, y|
  cost_row.each_with_index do |cost, x|
    vertex = Vertex.new(cost, [x,y])
    vertices << vertex
  end
end

distances = Hash.new(2**16-1)
distances[[0,0]] = 0
paths = {}

puts "processing #{vertices.count} vertices"
end_point = [x_max, y_max]

while not vertices.empty?
  #start_time = Time.now
  # FIXME horribly slow, use a min heap or priority queue
  vertices.sort!{|l,r| distances[l.point] <=> distances[r.point]}
  #sort_time = Time.now
  #puts "sort_time: #{(sort_time - start_time).to_s}"

  vert = vertices.shift
  point = vert.point
  puts "vert: #{vert.to_s}"
  puts "distance[#{point}]: #{distances[point]}"

  if distances.keys.include? end_point
    puts "#{end_point} found in distances.keys"
    break
  end

  adjacent_vertices = []
  [[point[0], point[1]+1], [point[0]+1, point[1]], [point[0]-1, point[1]], [point[0], point[1]-1]].each do |adj_point|
    #puts vertices.elements.to_s
    adjacent_vertices += vertices.select{|v| v.point == adj_point}
  end
  #puts "adjacent_vertices: #{adjacent_vertices.to_s}"
  adjacent_vertices.each do |adj_vert|
    new_cost = distances[point] + adj_vert.cost
    #puts "new_cost: #{new_cost.to_s} =?= distances[#{adj_vert[1].to_s}]: #{distances[adj_vert[1]].to_s}"
    if new_cost < distances[adj_vert.point]
      #puts "setting distance for point #{adj_vert[1]} to new_cost #{new_cost}"
      distances[adj_vert.point] = new_cost
      paths[adj_vert.point] = point
      #puts "distances: #{distances.to_s}"
      #puts "paths: #{paths.to_s}"
    end
  end
  #adjacency_time = Time.now
  #puts "adjacency_time: #{(adjacency_time - sort_time).to_s}"
end

#puts distances.keys.to_s
puts distances[end_point]
