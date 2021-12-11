#! /usr/bin/env ruby

filename = ARGV[0].nil? ? './example' : ARGV[0]
lines = File.open(filename, 'r').readlines.map{|l| l.strip.split('')}

OPEN_CHARS = ['[', '(', '<', '{']
CLOSE_CHARS = [']', ')', '>', '}']

def type_matches l, r
  l, r = [l,r].sort
  return true if l == '[' && r == ']'
  return true if l == '(' && r == ')'
  return true if l == '<' && r == '>'
  return true if l == '{' && r == '}'
  return false
end

stack = []
incomplete_stacks = []
lines.each do |line|
  #puts line.join('')
  do_next = false
  line.each do |char|
    if OPEN_CHARS.include? char
      stack.push char
      #puts "pushed #{char}"
    elsif CLOSE_CHARS.include? char
      other = stack.pop
      #puts "popped #{other}"
      unless type_matches other, char
        #puts "parse error #{line.join ''}"
        #puts "  wanted to close #{other} but got #{char}"
        do_next = true
        break
      end
    else
      puts "error"
      exit
    end
    break if do_next
  end
  (stack = []; next) if do_next

  if stack.empty?
    #puts "line #{line} parses OK"
  else
    #puts "incomplete #{line.join ''}"
    #puts "  stack: #{stack}"
    incomplete_stacks << stack
  end
  stack = []
end

points = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}
scores = incomplete_stacks.map do |stack|
  score = 0
  #puts "stack: #{stack.join ''}"
  stack.reverse.each do |c|
    score *= 5
    score += points[c]
  end
  score
end

puts scores.to_s
puts scores.sort[scores.length/2]

