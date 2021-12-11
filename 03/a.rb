#! /usr/bin/env ruby

binary_list = []
File.open('./input', 'r').lines do |line|
  binary_list << line
end
#binary_list = ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"]

digits_sum = [0] * 12
#digits_sum = [0] * 5
binary_list.each do |binary|
  digits = binary.strip.chars.map(&:to_i)

  digits_sum.each_with_index do |summ, idx|
    digits_sum[idx] = summ + digits[idx]
  end
end

threshold = binary_list.length / 2
gamma_values = '0b'
digits_sum.each do |summ|
  gamma_values += (summ > threshold) ? "1" : "0"
end
gamma_rate = gamma_values.to_i(2)
puts "gr #{gamma_rate}"
epsilon_rate = (gamma_rate ^ 0xfff)
puts "er #{epsilon_rate}"
puts gamma_rate * epsilon_rate
