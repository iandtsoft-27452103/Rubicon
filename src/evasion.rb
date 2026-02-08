class Evasion
    require './common'
    require './piece'
    require './color'
    require './hash256'
    require './move'
    require './file'
    require './atkop'
    require './bitop'
    Direc_Misc = 0
    def generate(bt, color, move_list, abb, di, idx, atkop, bitop, cls_move, cls_mm, rd)
        #King escapes
        sq_king = bt.sq_king[color]
        ifrom = sq_king
        bt.bb_occupied[color] ^= abb.abb_mask[sq_king]
        bb_to = abb.abb_piece_attacks[color][King][sq_king] & ~bt.bb_occupied[color]
        while bb_to > 0
            ito = bitop.bitscan(bb_to)
            if atkop.is_attacked(bt, ito, color, abb) == 0
                move_list[idx] = cls_move.pack(ifrom, ito, King, bt.board[ito].abs, 0)
                idx += 1
            end
            bb_to ^= abb.abb_mask[ito]
        end
        bt.bb_occupied[color] ^= abb.abb_mask[sq_king]
        bb_checker = atkop.attacks_to_piece(bt, sq_king, color ^ 1, abb)
        checker_num = bitop.popu_count(bb_checker)
        #if double check return.
        if checker_num == 2
            return move_list, idx
        end
        sq_checker = bitop.bitscan(bb_checker)

        #Capture checker
        bb_cap_checker = atkop.attacks_to_piece(bt, sq_checker, color, abb)
        ito = sq_checker
        while bb_cap_checker > 0
            ifrom = bitop.bitscan(bb_cap_checker)
            bb_cap_checker ^= abb.abb_mask[ifrom]
            if ifrom == sq_king
                next
            end
            ipiece = bt.board[ifrom].abs#if ipiece is king skips.
            idirec = di[ifrom][sq_checker]
            flag = false
            if atkop.is_pinned_on_king(bt, ifrom, idirec, color, abb) == 0
                if Set_Piece_Can_Promote0.include?(ipiece) && (abb.abb_piece_attacks[color][ipiece][ifrom] & BB_Rev_Color_Position[color] > 0)
                #if Set_Piece_Can_Promote0.include?(ipiece)
                    move = cls_move.pack(ifrom, ito, ipiece, bt.board[ito].abs, 1)
                    cls_mm.Do(bt, color, move, cls_move, abb.abb_mask, rd)
                    if atkop.is_attacked(bt, sq_king, color, abb) == 0
                        move_list[idx] = move
                        idx += 1
                    end
                    cls_mm.UnDo(bt, color, move, cls_move, abb.abb_mask)
                    if ipiece == Pawn
                        flag = true
                    end
                end
                if Set_Piece_Can_Promote1.include?(ipiece)
                    if (BB_Rev_Color_Position[color] & abb.abb_mask[ifrom]) > 0 || (BB_Rev_Color_Position[color] & abb.abb_mask[ito]) > 0
                        move = cls_move.pack(ifrom, ito, ipiece, bt.board[ito].abs, 1)
                        cls_mm.Do(bt, color, move, cls_move, abb.abb_mask, rd)
                        if atkop.is_attacked(bt, sq_king, color, abb) == 0
                            move_list[idx] = move
                            idx += 1
                        end
                        cls_mm.UnDo(bt, color, move, cls_move, abb.abb_mask)
                        if ipiece != Silver
                            flag = true
                        end
                    end
                end
                if flag == false
                    move = cls_move.pack(ifrom, ito, ipiece, bt.board[ito].abs, 0)
                    cls_mm.Do(bt, color, move, cls_move, abb.abb_mask, rd)
                    if atkop.is_attacked(bt, sq_king, color, abb) == 0
                        move_list[idx] = move
                        idx += 1
                    end
                    cls_mm.UnDo(bt, color, move, cls_move, abb.abb_mask)
                end
            end
        end

        # If checker is not long attacks pieces, return.
        checker = bt.board[sq_checker].abs
        if Set_Long_Attack_Pieces.include?(checker) == false
            return move_list, idx
        end

        #if check from king's neighbour return.
        bb_object = bb_checker & abb.abb_piece_attacks[color][King][sq_king]
        if bb_object > 0
            return move_list, idx
        end

        #Shut out from long attacks pieces using piece on board.
        if bb_object == 0 && Set_Long_Attack_Pieces.include?(checker)
            bb_inter = abb.abb_obstacles[sq_king][sq_checker]
            while bb_inter > 0
                ito = bitop.bitscan(bb_inter)
                bb_inter ^= abb.abb_mask[ito]
                bb_defender = atkop.attacks_to_piece(bt, ito, color, abb)
                while bb_defender > 0
                    ifrom = bitop.bitscan(bb_defender)
                    bb_defender ^= abb.abb_mask[ifrom]
                    if ifrom == sq_king
                        next
                    end
                    ipiece = bt.board[ifrom].abs
                    idirec = di[sq_king][ifrom]
                    flag = false
                    if idirec == Direc_Misc || atkop.is_pinned_on_king(bt, ifrom, idirec, color, abb) == 0
                        if Set_Piece_Can_Promote0.include?(ipiece)
                            if ipiece != Lance && (abb.abb_piece_attacks[color][ipiece][ifrom] & BB_Rev_Color_Position[color]) > 0
                                move = cls_move.pack(ifrom, ito, ipiece, bt.board[ito].abs, 1)
                                move_list[idx] = move
                                idx += 1
                                if ipiece == Pawn
                                    flag = true
                                end
                            elsif ipiece == Lance
                                bb_occupied = bt.bb_occupied[color] | bt.bb_occupied[color ^ 1]
                                h = bb_occupied & abb.abb_lance_mask_ex[color][ifrom]
                                if abb.abb_lance_attacks[color][ifrom][h] & BB_Rev_Color_Position[color] > 0
                                    move = cls_move.pack(ifrom, ito, ipiece, bt.board[ito].abs, 1)
                                    move_list[idx] = move
                                    idx += 1
                                end
                            end
                        end
                        if Set_Piece_Can_Promote1.include?(ipiece)
                            if (BB_Rev_Color_Position[color] & abb.abb_mask[ifrom]) > 0 || (BB_Rev_Color_Position[color] & abb.abb_mask[ito]) > 0
                                move = cls_move.pack(ifrom, ito, ipiece, bt.board[ito].abs, 1)
                                move_list[idx] = move
                                idx += 1
                                if ipiece != Silver
                                    flag = true
                                end
                            end
                        end
                        if flag == false
                            if (ipiece == Knight || ipiece == Lance) && (BB_Knight_Must_Promote[color] & abb.abb_mask[ito]) > 0
                                next
                            end
                            move = cls_move.pack(ifrom, ito, ipiece, bt.board[ito].abs, 0)
                            move_list[idx] = move
                            idx += 1
                        end
                    end
                end
            end
        end
        ##Shut out from long attacks pieces with drop move.
        bb_empty = abb.abb_obstacles[sq_king][sq_checker]
        bb_pawn_can_drop = 0
        if bt.hand[color] & Hand_Mask[Pawn] > 0
            i = File1
            while i <= File9
                bb_pawn_can_drop |= BB_File[i] & (BB_Full & ~bt.bb_piece[color][Pawn]) & Pawn_Lance_Can_Drop[color] & bb_empty
                i += 1
            end
            sq = bt.sq_king[color] + Delta_Table[color]
            if sq >= 0 && sq < Square_NB && bt.board[sq] == Empty && (bb_pawn_can_drop & abb.abb_mask[sq]) != 0
                if atkop.is_mate_pawn_drop(bt, sq, color, abb, di, bitop) > 0
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
                    move = cls_move.pack(ifrom, ito, i, Empty, 0)
                    move_list[idx] = move
                    idx += 1
                end
            end
            i += 1
        end
        return move_list, idx
    end
end