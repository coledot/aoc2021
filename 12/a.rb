#! /usr/bin/env ruby

filename = ARGV[0] || 'example'
raw_graph_edges = File.open(filename, 'r').readlines.map{|l| l.strip.split '-'}

#class CaveNode
#  def initialize name
#    @name = name
#    @connections = []
#  end
#  attr_accessor :name
#
#  def connect! node
#    raise "connect! recieved something that's not a node" unless node.class == CaveNode
#    unless @connections.include? node
#      @connections << node
#    end
#  end
#
#  def to_s
#    "#{@name.to_s} -> [#{@connections.count} connections]"
#  end
#end

class CaveGraph
  def initialize edges
    @node_table = {}
    edges.each do |edge|
      add_connection edge[0], edge[1]
    end
  end

  def find_paths
    start_node = @node_table['start']
    end_node = @node_table['end']
    raise 'one of start and/or end node is missing' unless !(start_node.nil? || end_node.nil?)
    complete_paths = []
    paths = [['start']]
    while not paths.empty?
      current_path = paths.pop
      puts "current path: #{current_path}"
      current_node = current_path.last
      puts "current_node: #{current_node}"
      @node_table[current_node].each do |connection|
        unless connection == 'end'
          next if /^[[:lower:]]+$/.match(connection) && current_path.include?(connection)
          paths.unshift(current_path + [connection])
        else
          complete_paths << (current_path + ['end'])
        end
      end
    end
    puts "complete_paths: #{complete_paths.to_s}"
    return complete_paths
  end

  def to_s
    s = "{ "
    @node_table.each do |k,v|
      s += "#{k} -> #{v.to_s} "
    end
    s += "}"
    return s
  end

  private

  def add_connection node1, node2
    if @node_table.keys.include?(node1) && @node_table.keys.include?(node2)
      #puts "both nodes exist, connecting them"
      @node_table[node1] << node2
      @node_table[node2] << node1
    elsif @node_table.keys.include?(node1)
      #puts "new node: #{node2}"
      @node_table[node1] << node2
      @node_table[node2] = [node1]
    elsif @node_table.keys.include?(node2)
      #puts "new node: #{node1}"
      @node_table[node2] << node1
      @node_table[node1] = [node2]
    else
      #puts "two new nodes: #{node1} #{node2}"
      @node_table[node1] = [node2]
      @node_table[node2] = [node1]
    end
  end
end

#puts raw_graph_edges.to_s
graph = CaveGraph.new raw_graph_edges
puts graph.to_s
paths = graph.find_paths.sort
paths.map{|p| puts p.join ','}
puts paths.count
