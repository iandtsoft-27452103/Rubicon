class AttacksOperation
    require './direction'
    require './color'
    require './piece'
    require './common'
    require './bitop'
    Direc_Misc = 0
    Direc_Diag1 = 8
    Direc_Diag2 = 10
    Direc_File = 9
    Direc_Rank = 1
    def is_pinned_on_king(bt, sq, idirec, color, abb)
        bb_occupied = bt.bb_occupied[Black] | bt.bb_occupied[White]
        case idirec.abs
        when Direc_Rank
            h = bb_occupied & abb.abb_rank_mask_ex[sq]
            bb_attacks = abb.abb_rank_attacks[sq][h]
            if (bt.bb_piece[color][King] & bb_attacks) != 0
                return (bb_attacks & (bt.bb_piece[color ^ 1][Rook] | bt.bb_piece[color ^ 1][Dragon]))
            end
        when Direc_File
            h = bb_occupied & abb.abb_file_mask_ex[sq]
            bb_attacks = abb.abb_file_attacks[sq][h]
            if (bt.bb_piece[color][King] & bb_attacks) != 0
                return (bb_attacks & (bt.bb_piece[color ^ 1][Rook] | bt.bb_piece[color ^ 1][Dragon] | bt.bb_piece[color ^ 1][Lance]))
            end
        when Direc_Diag1
            h = bb_occupied & abb.abb_diag1_mask_ex[sq]
            bb_attacks = abb.abb_diag1_attacks[sq][h]
            if (bt.bb_piece[color][King] & bb_attacks) != 0
                return (bb_attacks & (bt.bb_piece[color ^ 1][Bishop] | bt.bb_piece[color ^ 1][Horse]))
            end
        when Direc_Diag2
            h = bb_occupied & abb.abb_diag2_mask_ex[sq]
            bb_attacks = abb.abb_diag2_attacks[sq][h]
            if (bt.bb_piece[color][King] & bb_attacks) != 0
                return (bb_attacks & (bt.bb_piece[color ^ 1][Bishop] | bt.bb_piece[color ^ 1][Horse]))
            end
        end
        return 0
    end
    def attacks_to_piece(bt, sq, color, abb)
        bb_occupied = bt.bb_occupied[Black] | bt.bb_occupied[White]
        bb_ret = bt.bb_piece[color][Pawn] & abb.abb_piece_attacks[color ^ 1][Pawn][sq]
        bb_ret |= bt.bb_piece[color][Knight] & abb.abb_piece_attacks[color ^ 1][Knight][sq]
        bb_ret |= bt.bb_piece[color][Silver] & abb.abb_piece_attacks[color ^ 1][Silver][sq]
        bb_total_gold = bt.bb_piece[color][Gold] | bt.bb_piece[color][Pro_Pawn] | bt.bb_piece[color][Pro_Lance] | bt.bb_piece[color][Pro_Knight] | bt.bb_piece[color][Pro_Silver]
        bb_ret |= bb_total_gold & abb.abb_piece_attacks[color ^ 1][Gold][sq]
        bb_hdk = bt.bb_piece[color][Horse] | bt.bb_piece[color][Dragon] | bt.bb_piece[color][King]
        bb_ret |= bb_hdk & abb.abb_piece_attacks[color ^ 1][King][sq]
        bb_bh = bt.bb_piece[color][Bishop] | bt.bb_piece[color][Horse]
        h = bb_occupied & abb.abb_diagonal_mask_ex[sq]
        bb_ret |= bb_bh & abb.abb_diagonal_attacks[sq][h]
        bb_rd = bt.bb_piece[color][Rook] | bt.bb_piece[color][Dragon]
        h = bb_occupied & abb.abb_cross_mask_ex[sq]
        bb_ret |= bb_rd & abb.abb_cross_attacks[sq][h]
        h = bb_occupied & abb.abb_lance_mask_ex[color ^ 1][sq]
        bb_ret |= bt.bb_piece[color][Lance] & abb.abb_lance_attacks[color ^ 1][sq][h]
        return bb_ret
    end
    def is_attacked(bt, sq, color, abb)
        bb_ret = 0
        if (sq + Delta_Table[color]) >= 0 && (sq + Delta_Table[color]) < Square_NB
            if bt.board[sq + Delta_Table[color]] == (Sign_Table[color] * Pawn)
                bb_ret = abb.abb_mask[sq + Delta_Table[color]]
            end
        end
        bb_ret |= bt.bb_piece[color ^ 1][Knight] & abb.abb_piece_attacks[color][Knight][sq]
        bb_ret |= bt.bb_piece[color ^ 1][Silver] & abb.abb_piece_attacks[color][Silver][sq]
        bb_total_gold = bt.bb_piece[color ^ 1][Gold] | bt.bb_piece[color ^ 1][Pro_Pawn] | bt.bb_piece[color ^ 1][Pro_Lance] | bt.bb_piece[color ^ 1][Pro_Knight] | bt.bb_piece[color ^ 1][Pro_Silver]
        bb_ret |= bb_total_gold & abb.abb_piece_attacks[color][Gold][sq]
        bb_hdk = bt.bb_piece[color ^ 1][Horse] | bt.bb_piece[color ^ 1][Dragon] | bt.bb_piece[color ^ 1][King]
        bb_ret |= bb_hdk & abb.abb_piece_attacks[color ^ 1][King][sq]
        bb_occupied = bt.bb_occupied[Black] | bt.bb_occupied[White]
        bb_bh = bt.bb_piece[color ^ 1][Bishop] | bt.bb_piece[color ^ 1][Horse]
        h = bb_occupied & abb.abb_diagonal_mask_ex[sq]
        bb_ret |= bb_bh & abb.abb_diagonal_attacks[sq][h]
        bb_rd = bt.bb_piece[color ^ 1][Rook] | bt.bb_piece[color ^ 1][Dragon]
        h = bb_occupied & abb.abb_cross_mask_ex[sq]
        bb_ret |= bb_rd & abb.abb_cross_attacks[sq][h]
        h = bb_occupied & abb.abb_lance_mask_ex[color][sq]
        bb_ret |= bt.bb_piece[color ^ 1][Lance] & abb.abb_lance_attacks[color][sq][h]
        return bb_ret
    end
    def is_mate_pawn_drop(bt, sq_drop, color, abb, di, bitop)
        if color == White
            if sq_drop - 9 >= 1 && bt.board[sq_drop - 9] != -King
                return 0
            end
        else
            if sq_drop + 9 <= Square_NB && bt.board[sq_drop + 9] != King
                return 0
            end
        end
        bb_sum = bt.bb_piece[color][Knight] & abb.abb_piece_attacks[color ^ 1][Knight][sq_drop]
        bb_sum |= bt.bb_piece[color][Silver] & abb.abb_piece_attacks[color ^ 1][Silver][sq_drop]
        bb_total_gold = bt.bb_piece[color][Gold] | bt.bb_piece[color][Pro_Pawn] | bt.bb_piece[color][Pro_Lance] | bt.bb_piece[color ^ 1][Pro_Knight] | bt.bb_piece[color ^ 1][Pro_Silver]
        bb_sum |= bb_total_gold & abb.abb_piece_attacks[color ^ 1][Gold][sq_drop]
        bb_occupied = bt.bb_occupied[Black] | bt.bb_occupied[White]
        bb_bh = bt.bb_piece[color][Bishop] | bt.bb_piece[color][Horse]
        h = bb_occupied & abb.abb_diagonal_mask_ex[sq_drop]
        bb_sum |= bb_bh & abb.abb_diagonal_attacks[sq_drop][h]
        bb_rd = bt.bb_piece[color][Rook] | bt.bb_piece[color][Dragon]
        h = bb_occupied & abb.abb_cross_mask_ex[sq_drop]
        bb_sum |= bb_rd & abb.abb_cross_attacks[sq_drop][h]
        bb_hd = bt.bb_piece[color][Horse] | bt.bb_piece[color][Dragon]
        bb_sum |= bb_hd & abb.abb_piece_attacks[color][King][sq_drop]
        while bb_sum > 0
            ifrom = bitop.bitscan(bb_sum)
            bb_sum ^= abb.abb_mask[ifrom]
            if is_discover_king(bt, ifrom, sq_drop, color, abb, di) != 0
                next
            end
            return 0
        end
        iking = bt.sq_king[color]
        iret = 1
        bt.bb_occupied[color ^ 1] ^= abb.abb_mask[sq_drop]
        bb_move = abb.abb_piece_attacks[color][King][iking] & ~bt.bb_occupied[color]
        while bb_move > 0
            ito = bitop.bitscan(bb_move)
            if is_attacked(bt, ito, color, abb) == 0
                iret = 0
                break
            end
            bb_move ^= abb.abb_mask[ito]
        end
        bt.bb_occupied[color ^ 1] ^= abb.abb_mask[sq_drop]
        return iret
    end
    def is_discover_king(bt, ifrom, ito, color, abb, di)
        idirec = di[bt.sq_king[color]][ifrom]
        if idirec != Direc_Misc && idirec != di[bt.sq_king[color]][ito] && is_pinned_on_king(bt, ifrom, idirec, color, abb) != 0
            return 1
        else
            return 0
        end
    end
    def is_discover_king2(bt, ifrom, ito, color, abb, di, ipiece)
        bt.bb_piece[color][ipiece] ^= abb.abb_mask[ifrom]
        bt.bb_occupied[color] ^= abb.abb_mask[ifrom]
        idirec = di[bt.sq_king[color]][ifrom]
        if idirec != Direc_Misc && idirec != di[bt.sq_king[color]][ito] && is_pinned_on_king(bt, ifrom, idirec, color, abb) != 0
            bt.bb_piece[color][ipiece] ^= abb.abb_mask[ifrom]
            bt.bb_occupied[color] ^= abb.abb_mask[ifrom]
            return 1
        else
            bt.bb_piece[color][ipiece] ^= abb.abb_mask[ifrom]
            bt.bb_occupied[color] ^= abb.abb_mask[ifrom]
            return 0
        end
    end
    def attacks_to_long_piece(bt, sq, color, abb)
        bb_occupied = bt.bb_occupied[Black] | bt.bb_occupied[White]
        bb_bh = bt.bb_piece[color][Bishop] | bt.bb_piece[color][Horse]
        h = bb_occupied & abb.abb_diagonal_mask_ex[sq]
        bb_ret = bb_bh & abb.abb_diagonal_attacks[sq][h]
        bb_rd = bt.bb_piece[color][Rook] | bt.bb_piece[color][Dragon]
        h = bb_occupied & abb.abb_cross_mask_ex[sq]
        bb_ret |= bb_rd & abb.abb_cross_attacks[sq][h]
        h = bb_occupied & abb.abb_lance_mask_ex[color ^ 1][sq]
        bb_ret |= bt.bb_piece[color][Lance] & abb.abb_lance_attacks[color ^ 1][sq][h]
        return bb_ret
    end
end
