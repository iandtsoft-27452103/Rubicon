class CSA
    require './common'
    require './piece'
    require './move'
    def csa_to_move(bt, str_csa, m)
        from = CSA_TO_SQ[str_csa[0,2]]
        to = CSA_TO_SQ[str_csa[2,2]]
        if from < Square_NB
            pc = bt.board[from].abs
        else
            pc = CSA_TO_PC[str_csa[4,2]]
            from += pc - 1
        end
        cap_pc = bt.board[to].abs
        print str_csa[0,2]
        str_pc = str_csa[4,2]
        flag_promo = 0
        if pc < King and Str_Piece.index(str_pc) > King
            flag_promo = 1
        end
        return m.pack(from, to, pc, cap_pc, flag_promo) 
    end
    def move_to_csa(move, cls_move)
        from = cls_move.from(move)
        to = cls_move.to(move)
        ipiece = cls_move.piece_type(move)
        flag_promo = cls_move.is_promo(move)
        if flag_promo == 1
            ipiece += Promote
        end
        s = Str_CSA[from] + Str_CSA[to] + Str_Piece[ipiece]
        return s
    end
end
