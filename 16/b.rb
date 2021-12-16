#! /usr/bin/env ruby

filename = ARGV[0] || 'example'
bitstring = File.open(filename, 'r').readline.strip.split('').map{|c| "%04b" % c.to_i(16)}.join ''

class Integer
  def gtop other
    self > other ? 1 : 0
  end
  def ltop other
    self < other ? 1 : 0
  end
  def eqop other
    self == other ? 1 : 0
  end
end

class DingusParser
  def initialize bitstring
    @decoded_length = 0
    @bitstring = bitstring
    @version_sum = 0
    @values = []
  end
  attr_reader :version_sum, :values

  def decode_packet!
    puts "starting @bitstring: #{@bitstring}"
    @version = consume_bits!(3).to_i(2)
    puts "@version #{@version}"
    @version_sum += @version
    @type_id = consume_bits!(3).to_i(2)
    puts "@type_id #{@type_id}"

    if @type_id == 4
      #puts "value packet; remaining @bitstring: #{@bitstring}"
      value, length = decode_value @bitstring
      @values << value
      consume_bits! length
    else
      #puts "operator packet; remaining @bitstring: #{@bitstring}"
      length_type_id = consume_bits!(1).to_i(2)

      if length_type_id == 0
        #puts "length_type_id #{length_type_id}"
        subpacket_bit_length = consume_bits!(15).to_i(2)
        #puts "subpacket_bit_length #{subpacket_bit_length}"
        #puts "subpacket bits are #{@bitstring[0..subpacket_bit_length-1]}"

        while subpacket_bit_length > 0
          value, length = decode_subpacket! @bitstring
          subpacket_bit_length -= length
          @values += value.flatten
        end
      else
        #puts "length_type_id #{length_type_id}"
        subpacket_count = consume_bits!(11).to_i(2)

        #puts "subpacket_count: #{subpacket_count}"
        subpacket_count.times do
          value, _ = decode_subpacket! @bitstring
          @values += value.flatten
        end
      end

      evaluate!
    end
    return @decoded_length
  end

  def consume_bits! n
    bits = @bitstring[0...n]
    @bitstring = @bitstring[n..]
    @decoded_length += bits.length
    #puts "bits: #{bits}"
    return bits
  end

  def decode_subpacket! bitstring
    parser = DingusParser.new bitstring
    length = parser.decode_packet!
    @version_sum += parser.version_sum
    #puts "decoded #{length} bits from subpacket"
    consume_bits! length
    return parser.values, length
  end

  def decode_value bitstring
    length = 0
    group_of_5 = bitstring[0..4]
    bitstring = bitstring[5..]
    value_bits = ''
    while not group_of_5.nil?
      #puts "gof: #{group_of_5}"
      value_bits += group_of_5[1..]
      length += 5
      break unless group_of_5[0] == '1'

      group_of_5 = bitstring[0..4]
      bitstring = bitstring[5..]
    end
    return 0, 0 if length == 0

    #puts "value_bits: #{value_bits}"
    value = value_bits.to_i(2)
    puts "value: #{value}"
    return value, length
  end

  def evaluate!
    operator = case @type_id
               when 0 then :+
               when 1 then :*
               when 2 then :min
               when 3 then :max
               when 5 then :gtop
               when 6 then :ltop
               when 7 then :eqop
               else raise "dafuq? #{@type_id}"
               end

    puts "reducing @values #{@values} with operator #{operator}"
    if [:min, :max].include? operator
      @values = [@values.send(operator)]
    else
      @values = [@values.reduce(&operator)]
    end
  end
end

parser = DingusParser.new bitstring
parser.decode_packet!
puts parser.version_sum
puts parser.values.to_s
