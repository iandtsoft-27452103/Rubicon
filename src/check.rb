class Check
    require './common'
    require './piece'
    require './color'
    require './hash256'
    require './move'
    require './file'
    require './atkop'
    require './bitop'
    Direc_Misc = 0
    Direc_Diag1_U2d = 8
    Direc_Diag2_U2d = 10
    Direc_File_U2d = 9
    Direc_Rank_L2r = 1
    #It contains check move to own king.
    def generate(bt, color, move_list, abb, di, idx, atkop, bitop, cls_move)
        opponent_color = color ^ 1
        bb_move_to = BB_Full & ~bt.bb_occupied[color]
        bb_empty = BB_Full & ~(bt.bb_occupied[color] | bt.bb_occupied[opponent_color])
        sq_opponent_king = bt.sq_king[opponent_color]
        sq_object = sq_opponent_king + Delta_Table[opponent_color]
        sq_pawn = sq_opponent_king + (2 * Delta_Table[opponent_color])
        #normal pawn move
        if sq_pawn >= 0 && sq_pawn < Square_NB && (abb.abb_mask[sq_object] & BB_Pawn_Mask[color]) > 0 && bt.board[sq_pawn] == Sign_Table[opponent_color] * Pawn && (bb_move_to & abb.abb_mask[sq_object]) > 0
            move_list[idx] = cls_move.pack(ifrom, ito, Pawn, 0, 0)
            idx += 1
        end
        #pawn promote
        bb_from = bt.bb_piece[color][Pawn]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            bb_object = BB_Rev_Color_Position[color] & abb.abb_piece_attacks[color][Pawn][ifrom] & abb.abb_piece_attacks[opponent_color][King][sq_opponent_king] & bb_move_to
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Pawn, bt.board[ito].abs, 1)
                idx += 1
            end
        end
        #pawn move using rook(discovered check), contains promote move
        bb_from = abb.abb_rank_attacks[sq_opponent_king][0] & bt.bb_piece[color][Pawn]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            bb_rd = bt.bb_piece[color][Rook] | bt.bb_piece[color][Dragon]
            if (abb.abb_rank_attacks[ifrom][0] & bb_rd) > 0 && (abb.abb_piece_attacks[color][Pawn][ifrom] & bb_move_to) > 0
                if BB_Rev_Color_Position[color] & abb.abb_piece_attacks[color][Pawn][ifrom] == 0
                    flag_promo = 0
                else
                    flag_promo = 1
                end
                ito = ifrom + Delta_Table[color]
                move_list[idx] = cls_move.pack(ifrom, ito, Pawn, bt.board[ito].abs, flag_promo)
                idx += 1
            end
        end
        #pawn move using bishop(discovered check), contains promote move
        bb_from = abb.abb_diag1_attacks[sq_opponent_king][0] & bt.bb_piece[color][Pawn]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            bb_bh = bt.bb_piece[color][Bishop] | bt.bb_piece[color][Horse]
            if (abb.abb_diag1_attacks[ifrom][0] & bb_bh) > 0 && (abb.abb_piece_attacks[color][Pawn][ifrom] & bb_move_to) > 0
                if BB_Rev_Color_Position[color] & abb.abb_piece_attacks[color][Pawn][ifrom] == 0
                    flag_promo = 0
                else
                    flag_promo = 1
                end
                ito = ifrom + Delta_Table[color]
                move_list[idx] = cls_move.pack(ifrom, ito, Pawn, bt.board[ito].abs, flag_promo)
                idx += 1
            end
        end
        bb_from = abb.abb_diag2_attacks[sq_opponent_king][0] & bt.bb_piece[color][Pawn]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            bb_bh = bt.bb_piece[color][Bishop] | bt.bb_piece[color][Horse]
            if (abb.abb_diag2_attacks[ifrom][0] & bb_bh) > 0 && (abb.abb_piece_attacks[color][Pawn][ifrom] & bb_move_to) > 0
                if BB_Rev_Color_Position[color] & abb.abb_piece_attacks[color][Pawn][ifrom] == 0
                    flag_promo = 0
                else
                    flag_promo = 1
                end
                ito = ifrom + Delta_Table[color]
                move_list[idx] = cls_move.pack(ifrom, ito, Pawn, bt.board[ito].abs, flag_promo)
                idx += 1
            end
        end
        #pawn drop
        if sq_object >= 0 && sq_object < Square_NB && (bt.hand[color] & Hand_Mask[Pawn]) > 0 && bt.board[sq_object] == Empty && (BB_File[FileTable[sq_object]]& bt.bb_piece[color][Pawn]) == 0 && atkop.is_mate_pawn_drop(bt, sq_object, color ^ 1, abb, di, bitop) == 0
            move_list[idx] = cls_move.pack(Square_NB + Pawn - 1, sq_object, Pawn, 0, 0)
            idx += 1
        end
        #normal silver move
        bb_from = bt.bb_piece[color][Silver]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = abb.abb_piece_attacks[color][Silver][ifrom] & abb.abb_piece_attacks[opponent_color][Silver][sq_opponent_king] & bb_move_to
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_behind & abb.abb_piece_attacks[color][Silver][ifrom] & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Silver, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        #silver promote
        bb_from = bt.bb_piece[color][Silver]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = abb.abb_piece_attacks[color][Silver][ifrom] & abb.abb_piece_attacks[opponent_color][Gold][sq_opponent_king] & bb_move_to
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_behind & abb.abb_piece_attacks[color][Silver][ifrom] & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                if (abb.abb_mask[ifrom] & BB_Rev_Color_Position[color]) > 0 || (abb.abb_mask[ito] & BB_Rev_Color_Position[color]) > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Silver, bt.board[ito].abs, 1)
                    idx += 1
                end
            end
        end
        #silver drop
        if (bt.hand[color] & Hand_Mask[Silver]) > 0
            bb_object = abb.abb_piece_attacks[opponent_color][Silver][sq_opponent_king] & bb_empty
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(Square_NB + Silver - 1, ito, Silver, 0, 0)
                idx += 1
            end           
        end
        #normal gold(promoted gold) move
        bb_from = bt.bb_piece[color][Gold] | bt.bb_piece[color][Pro_Pawn] | bt.bb_piece[color][Pro_Lance] | bt.bb_piece[color][Pro_Knight] | bt.bb_piece[color][Pro_Silver]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = abb.abb_piece_attacks[color][Gold][ifrom] & abb.abb_piece_attacks[opponent_color][Gold][sq_opponent_king] & bb_move_to
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_behind & abb.abb_piece_attacks[color][Gold][ifrom] & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, bt.board[ifrom].abs, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        #gold drop
        if (bt.hand[color] & Hand_Mask[Gold]) > 0
            bb_object = abb.abb_piece_attacks[opponent_color][Gold][sq_opponent_king] & bb_empty
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(Square_NB + Gold - 1, ito, Gold, 0, 0)
                idx += 1
            end           
        end
        #normal knight move
        bb_from = bt.bb_piece[color][Knight]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = abb.abb_piece_attacks[color][Knight][ifrom] & abb.abb_piece_attacks[opponent_color][Knight][sq_opponent_king] & bb_move_to
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_behind & abb.abb_piece_attacks[color][Knight][ifrom] & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Knight, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        #knight promote
        bb_from = bt.bb_piece[color][Knight]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = abb.abb_piece_attacks[color][Knight][ifrom] & abb.abb_piece_attacks[opponent_color][Gold][sq_opponent_king] & bb_move_to
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_behind & abb.abb_piece_attacks[color][Knight][ifrom] & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                if (abb.abb_mask[ifrom] & BB_Rev_Color_Position[color]) > 0 || (abb.abb_mask[ito] & BB_Rev_Color_Position[color]) > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Knight, bt.board[ito].abs, 1)
                    idx += 1
                end
            end
        end

        #knight drop
        if (bt.hand[color] & Hand_Mask[Knight]) > 0
            bb_object = abb.abb_piece_attacks[opponent_color][Knight][sq_opponent_king] & bb_empty
            while bb_object > 0
                ito =  bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(Square_NB + Knight - 1, ito, Knight, 0, 0)
                idx += 1
            end           
        end

        #king move(discovered check)
        ifrom = bt.sq_king[color]
        idirec = di[sq_opponent_king][ifrom]
        if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
            bb_object = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
            bb_object = bb_object & abb.abb_piece_attacks[color][King][ifrom] & bb_move_to
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, King, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        bb_occupied = bt.bb_occupied[Black] | bt.bb_occupied[White]
        #lance move
        #if a move is not discoverd check, the move is capture move.
        bb_from = bt.bb_piece[color][Lance]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_lance_mask_ex[color][ifrom]
            bb_attacks = abb.abb_lance_attacks[color][ifrom][h] & (BB_Full & ~BB_Knight_Must_Promote[color]) & bt.bb_occupied[opponent_color] & bb_move_to
            h = bb_occupied & abb.abb_lance_mask_ex[opponent_color][sq_opponent_king]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = bb_attacks & abb.abb_lance_attacks[opponent_color][sq_opponent_king][h]
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= abb.abb_lance_attacks[color][ifrom][h] & bb_behind & (BB_Full & ~BB_Knight_Must_Promote[color]) & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Lance, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        #lance promote
        bb_from = bt.bb_piece[color][Lance]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_lance_mask_ex[color][ifrom]
            bb_attacks = abb.abb_lance_attacks[color][ifrom][h] & (BB_Full & BB_Rev_Color_Position[color]) & abb.abb_piece_attacks[opponent_color][Gold][sq_opponent_king] & bb_move_to
            h = bb_occupied & abb.abb_lance_mask_ex[opponent_color][sq_opponent_king]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = bb_attacks & abb.abb_lance_attacks[opponent_color][sq_opponent_king][h]
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= abb.abb_lance_attacks[color][ifrom][h] & bb_behind & (BB_Full & BB_Rev_Color_Position[color]) & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Lance, bt.board[ito].abs, 1)
                idx += 1
            end
        end
        #lance drop
        if (bt.hand[color] & Hand_Mask[Lance]) > 0
            h = bb_occupied & abb.abb_lance_mask_ex[opponent_color][sq_opponent_king]
            bb_object = abb.abb_lance_attacks[opponent_color][sq_opponent_king][h] & bb_empty
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(Square_NB + Lance - 1, ito, Lance, 0, 0)
                idx += 1
            end           
        end
        #normal rook move
        bb_from = bt.bb_piece[color][Rook] & (BB_Color_Position[color] | BB_DMZ)
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_cross_mask_ex[ifrom]
            bb_attacks = abb.abb_cross_attacks[ifrom][h] & bb_move_to
            h = bb_occupied & abb.abb_cross_mask_ex[sq_opponent_king]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = bb_attacks & abb.abb_cross_attacks[sq_opponent_king][h] & (BB_Color_Position[color] | BB_DMZ)
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_attacks & bb_behind & (BB_Color_Position[color] | BB_DMZ) & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Rook, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        #rook promote
        bb_from = bt.bb_piece[color][Rook]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_cross_mask_ex[ifrom]
            bb_attacks = abb.abb_cross_attacks[ifrom][h] & bb_move_to
            h = bb_occupied & abb.abb_cross_mask_ex[sq_opponent_king]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = bb_attacks & (abb.abb_cross_attacks[sq_opponent_king][h] | abb.abb_piece_attacks[opponent_color][King][sq_opponent_king])
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_attacks & bb_behind & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                if (abb.abb_mask[ifrom] & BB_Rev_Color_Position[color]) > 0 || (abb.abb_mask[ito] & BB_Rev_Color_Position[color]) > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Rook, bt.board[ito].abs, 1)
                    idx += 1
                end
            end
        end
        #rook drop
        if (bt.hand[color] & Hand_Mask[Rook]) > 0
            h = bb_occupied & abb.abb_cross_mask_ex[sq_opponent_king]
            bb_object = abb.abb_cross_attacks[sq_opponent_king][h] & bb_empty
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(Square_NB + Rook - 1, ito, Rook, 0, 0)
                idx += 1
            end           
        end
        #normal bishop move
        bb_from = bt.bb_piece[color][Bishop] & (BB_Color_Position[color] | BB_DMZ)
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_diagonal_mask_ex[ifrom]
            bb_attacks = abb.abb_diagonal_attacks[ifrom][h] & bb_move_to
            h = bb_occupied & abb.abb_diagonal_mask_ex[sq_opponent_king]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = bb_attacks & abb.abb_diagonal_attacks[sq_opponent_king][h] & (BB_Color_Position[color] | BB_DMZ)
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_attacks & bb_behind & (BB_Color_Position[color] | BB_DMZ) & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Bishop, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        #bishop promote
        bb_from = bt.bb_piece[color][Bishop]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_diagonal_mask_ex[ifrom]
            bb_attacks = abb.abb_diagonal_attacks[ifrom][h] & bb_move_to
            h = bb_occupied & abb.abb_diagonal_mask_ex[sq_opponent_king]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = bb_attacks & (abb.abb_diagonal_attacks[sq_opponent_king][h] | abb.abb_piece_attacks[opponent_color][King][sq_opponent_king])
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_attacks & bb_behind & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                if (abb.abb_mask[ifrom] & BB_Rev_Color_Position[color]) > 0 || (abb.abb_mask[ito] & BB_Rev_Color_Position[color]) > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Bishop, bt.board[ito].abs, 1)
                    idx += 1
                end
            end
        end
        #bishop drop
        if (bt.hand[color] & Hand_Mask[Bishop]) > 0
            h = bb_occupied & abb.abb_diagonal_mask_ex[sq_opponent_king]
            bb_object = abb.abb_diagonal_attacks[sq_opponent_king][h] & bb_empty
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(Square_NB + Bishop - 1, ito, Bishop, 0, 0)
                idx += 1
            end           
        end
        #dragon move
        bb_from = bt.bb_piece[color][Dragon]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_cross_mask_ex[ifrom]
            bb_attacks = (abb.abb_cross_attacks[ifrom][h] | abb.abb_piece_attacks[color][King][ifrom]) & bb_move_to
            h = bb_occupied & abb.abb_cross_mask_ex[sq_opponent_king]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = bb_attacks & (abb.abb_cross_attacks[sq_opponent_king][h] | abb.abb_piece_attacks[color][King][sq_opponent_king])
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_attacks & bb_behind & bb_move_to
            end
            while bb_object > 0
                ito =  bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Dragon, bt.board[ito].abs, 0)
                idx += 1
            end           
        end
        #horse move
        bb_from = bt.bb_piece[color][Horse]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_diagonal_mask_ex[ifrom]
            bb_attacks = (abb.abb_diagonal_attacks[ifrom][h] | abb.abb_piece_attacks[color][King][ifrom]) & bb_move_to
            h = bb_occupied & abb.abb_diagonal_mask_ex[sq_opponent_king]
            idirec = di[sq_opponent_king][ifrom]
            bb_object = bb_attacks & (abb.abb_diagonal_attacks[sq_opponent_king][h] | abb.abb_piece_attacks[color][King][sq_opponent_king])
            if idirec != Direc_Misc && atkop.is_pinned_on_king(bt, ifrom, idirec, opponent_color, abb) > 0
                bb_behind = add_behind_attacks(0, idirec, sq_opponent_king, abb, di)
                bb_object |= bb_attacks & bb_behind & bb_move_to
            end
            while bb_object > 0
                ito = bitop.bitscan(bb_object)
                bb_object ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Horse, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        return move_list, idx
    end
    def add_behind_attacks(bb, idirec, ik, abb, di)
        bb_tmp = 0
        if idirec < 0
            idirec = -idirec
        end
        if idirec == Direc_Diag1_U2d
            bb_tmp = abb.abb_diag1_attacks[ik][0]
        elsif idirec == Direc_Diag2_U2d
            bb_tmp = abb.abb_diag2_attacks[ik][0]
        elsif idirec == Direc_File_U2d
            bb_tmp = abb.abb_file_attacks[ik][0]
        elsif idirec == Direc_Rank_L2r
            bb_tmp = abb.abb_rank_attacks[ik][0]
        end
        bb_tmp = BB_Full & ~bb_tmp
        return (bb | bb_tmp)
    end
end
