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

bad_chars = []
stack = []
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
        #puts "wanted to close #{other} but got #{char}"
        bad_chars << char
        do_next = true
        break
      end
    else
      puts "error"
      exit
    end
    (stack.clear ; next) if do_next
  end

  if stack.empty?
    #puts "line #{line} parses OK"
  else
    #puts "incomplete #{line}"
    #puts "  stack: #{stack}"
  end
  stack.clear
end

points = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}
#puts points.to_s
puts "bad chars are #{bad_chars.to_s}"
puts bad_chars.map{|c| points[c]}.sum

