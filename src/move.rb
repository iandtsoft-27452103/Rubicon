class Move
    def pack(ifrom, ito, pc, cap_pc, flag_promo)
        return ((cap_pc << 19) | (pc << 15) | (flag_promo << 14) | (ifrom << 7) | ito)
    end
    def from(move)
        return ((move >> 7) & 0x007f)
    end
    def to(move)
        return (move & 0x007f)
    end
    def is_promo(move)
        return ((move >> 14) & 1)
    end
    def piece_type(move)
        return ((move >> 15) & 0x000f)
    end
    def cap_piece(move)
        return ((move >> 19) & 0x000f)
    end
end
