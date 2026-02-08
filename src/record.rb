class Record
    attr_accessor :result, :str_moves, :moves, :ply
    def init(num)
        @result = 0; @str_moves = Array.new(num); @moves = Array.new(num), @ply = num
    end
end
