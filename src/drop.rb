class Drop
    require './common'
    require './piece'
    require './color'
    require './hash256'
    require './move'
    require './file'
    require './atkop'
    require './bitop'
    def generate(bt, color, move_list, abb, di, idx, atkop, bitop, cls_move)
        bb_occupied = bt.bb_occupied[Black] | bt.bb_occupied[White]
        bb_empty = BB_Full & ~bb_occupied
        bb_pawn_can_drop = 0
        if bt.hand[color] & Hand_Mask[Pawn] > 0
            i = File1
            while i <= File9
                if BB_File[i] & bt.bb_piece[color][Pawn] == 0
                    bb_pawn_can_drop |= BB_File[i] & (BB_Full & ~bt.bb_piece[color][Pawn]) & Pawn_Lance_Can_Drop[color] & bb_empty
                end
                i += 1
            end
            sq = bt.sq_king[color ^ 1] + Delta_Table[color ^ 1]
            if sq >= 0 && sq < Square_NB && bt.board[sq] == Empty && (bb_pawn_can_drop & abb.abb_mask[sq]) != 0
                if atkop.is_mate_pawn_drop(bt, sq, color ^ 1, abb, di, bitop) != 0
                    bb_pawn_can_drop ^= abb.abb_mask[sq]
                end
            end
        end
        bb_lance_can_drop = Pawn_Lance_Can_Drop[color] & bb_empty
        bb_knight_can_drop = Knight_Can_Drop[color] & bb_empty
        bb_silver_can_drop = bb_gold_can_drop = bb_bishop_can_drop = bb_rook_can_drop = Others_Can_Drop & bb_empty
        bb_can_drops = [bb_pawn_can_drop, bb_lance_can_drop, bb_knight_can_drop, bb_silver_can_drop, bb_gold_can_drop, bb_bishop_can_drop, bb_rook_can_drop]
        i = Pawn
        while i <= Rook
            if bt.hand[color] & Hand_Mask[i] > 0
                bb = bb_can_drops[i - 1]
                while bb > 0
                    ifrom = Square_NB + i - 1
                    ito = bitop.bitscan(bb)
                    bb ^= abb.abb_mask[ito]
                    move_list[idx] = cls_move.pack(ifrom, ito, i, 0, 0)
                    idx += 1
                end
            end
            i += 1
        end
        return move_list, idx
    end
end
