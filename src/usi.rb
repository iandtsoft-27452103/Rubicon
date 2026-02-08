class USI
    require './common'
    require './piece'
    require './move'
    def usi_to_move(bt, str_usi, cls_move)
        flag_promo = 0
        from_sq = 0
        pc = 0
        cap_pc = 0
        l = str_usi.count
        if l == 5
            flag_promo = 1
        end
        if str_usi[0] == '*'
            pc = Usi_Drop_Piece[str_usi[0]]
            from_sq = Square_NB + pc
        else
            from_sq = USI_TO_SQ[str_usi[0,2]]
            pc = bt.board[from_sq].abs
        end
        to_sq = USI_TO_SQ[str_usi[2,2]]
        cap_pc = bt.board[to_sq].abs
        return cls_move.pack(from_sq, to_sq, pc, cap_pc, flag_promo)
    end
end
