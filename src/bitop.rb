class BitOp
    require './common'
    def bitscan(bb)
        return Square_NB - bb.bit_length
    end
    def popu_count(n)
        return n.bit_length - n.to_s(2).count('0')
    end
end
