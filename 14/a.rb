#! /usr/bin/env ruby

filename = ARGV[0] || 'example'
file = File.open(filename, 'r')
polymer = file.readline.strip
_ = file.readline
rules = {}
file.readlines.map{|l| l.strip.split ' -> '}.map{|p| rules[p[0]] = p[1]}
puts polymer
puts rules.to_s

10.times do |t|
  puts "step #{t+1}"
  new_polymer = ''
  (0...(polymer.length-1)).each do |idx|
    #puts "idx: #{idx}"
    pair = String.new polymer[idx...[idx+2,polymer.length].min]
    #puts "pair: #{pair}"
    unless idx == polymer.length-2
      pair[1] = rules[pair]
    else
      pair.insert(1, rules[pair])
    end
    new_polymer += pair
    #puts "new_polymer: #{new_polymer}"
  end
  polymer = new_polymer
  puts "polymer: #{polymer}"
end

split_polymer = polymer.split('')
frequency = split_polymer.group_by{|s| split_polymer.select{|c| c==s}.count}
low, high = frequency.keys.min, frequency.keys.max
puts frequency[high].count - frequency[low].count
