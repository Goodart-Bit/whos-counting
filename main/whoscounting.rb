#Who's Counting, programa de simulación
#Por Juan Mateo De la Hoz y Juan Pablo Avilan 
class Reader
    def read_strategy file_name
        strategy_table = File.readlines("files/#{file_name}.txt").map(&:chomp)
        strategy_rows = strategy_table.map {|strategy_line| strategy_line.split("\t")}
        strategy_rows.each {|strset_arr| strset_arr.map! {|number| number.to_i}}
        strategy_rows
    end
end

class NumberFromSpins
    def initialize user_table
        @strategy_table = user_table
    end

    def define_number #array of arrays with the optimal digit location per number
        spins_num =  -1  #spins number, from -1 to 4 (5 spins)
        numbers_by_spin = Array.new(@strategy_table[0].length) #array to allocate numbers per spin throughout the 5 spins
        while spins_num < 4 #continue while there are spins left
            observed_num = rand(0..9).floor
            jumps = @strategy_table[observed_num][spins_num = spins_num+1] #jumps correspond to the number of jumps indicated for a number in an nth spin
            suggested_idx = deduct_jump(numbers_by_spin,jumps)
            numbers_by_spin[suggested_idx] = observed_num
        end
        numbers_by_spin.join.to_i
    end

    def deduct_jump array , jumps
        jump_counter = 0
        for i in 0..array.length
            if array[i] == nil
                jump_counter = jump_counter+1
                if jump_counter == jumps
                    return i
                end
            end
        end
    end
end

puts "**SO WHO'S COUNTING!**"
reader = Reader.new
strategy = reader.read_strategy "strategy"
counter = -1
puts "--estrategia del usuario--"
strategy.each {|line| puts "" + (counter = counter + 1).to_s + ": " +line.to_s}
puts "-------------------------"
number_generator = NumberFromSpins.new strategy
#calculating average expected profit
result_num = 0
iterations = 10000
puts "# de iteraciones: #{iterations}"
iterations.times do
    result_num += number_generator.define_number
end
puts "Ganancia promedio esperada: #{result_num/iterations}"