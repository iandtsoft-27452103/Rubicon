class Cap
    require './common'
    require './piece'
    require './color'
    require './hash256'
    require './move'
    require './file'
    require './atkop'
    require './bitop'
    def generate(bt, color, move_list, abb, idx, atkop, bitop, cls_move)
        bb_occupied = bt.bb_occupied[Black] | bt.bb_occupied[White]
        bb_can_cap = bt.bb_occupied[color ^ 1]
        bb_from = bt.bb_piece[color][Pawn]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            bb_to = abb.abb_piece_attacks[color][Pawn][ifrom] & bb_can_cap
            while bb_to > 0
                ito = bitop.bitscan(bb_to)
                bb_to ^= abb.abb_mask[ito]
                bb_can_promote = BB_Rev_Color_Position[color] & abb.abb_mask[ito]
                if bb_can_promote > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Pawn, bt.board[ito].abs, 1)
                else
                    move_list[idx] = cls_move.pack(ifrom, ito, Pawn, bt.board[ito].abs, 0)
                end
                idx += 1
            end
        end
        bb_from = bt.bb_piece[color][Knight]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            bb_to = abb.abb_piece_attacks[color][Knight][ifrom] & bb_can_cap
            while bb_to > 0
                ito = bitop.bitscan(bb_to)
                bb_to ^= abb.abb_mask[ito]
                bb_can_promote = BB_Rev_Color_Position[color] & abb.abb_mask[ito]
                if bb_can_promote > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Knight, bt.board[ito].abs, 1)
                    idx += 1
                end
                if (BB_Knight_Must_Promote[color] & abb.abb_mask[ito]) == 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Knight, bt.board[ito].abs, 0)
                    idx += 1                 
                end
            end
        end
        bb_from = bt.bb_piece[color][Silver]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            bb_to = abb.abb_piece_attacks[color][Silver][ifrom] & bb_can_cap
            while bb_to > 0
                ito = bitop.bitscan(bb_to)
                bb_to ^= abb.abb_mask[ito]
                bb_from_to = abb.abb_mask[ifrom] | abb.abb_mask[ito]
                bb_can_promote = BB_Rev_Color_Position[color] & bb_from_to
                if bb_can_promote > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Silver, bt.board[ito].abs, 1)
                    idx += 1
                end
                move_list[idx] = cls_move.pack(ifrom, ito, Silver, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        piece_list = [Gold, King, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver]
        limit = piece_list.count
        pc = 0
        while pc < limit
            bb_from = bt.bb_piece[color][piece_list[pc]]
            while bb_from > 0
                ifrom = bitop.bitscan(bb_from)
                bb_from ^= abb.abb_mask[ifrom]
                bb_to = abb.abb_piece_attacks[color][piece_list[pc]][ifrom] & bb_can_cap
                while bb_to > 0
                    ito = bitop.bitscan(bb_to)
                    bb_to ^= abb.abb_mask[ito]
                    move_list[idx] = cls_move.pack(ifrom, ito, piece_list[pc], bt.board[ito].abs, 0)
                    idx += 1
                end
            end
            pc += 1
        end
        bb_from = bt.bb_piece[color][Lance]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_lance_mask_ex[color][ifrom]
            bb_to = abb.abb_lance_attacks[color][ifrom][h] & bb_can_cap
            while bb_to > 0
                ito = bitop.bitscan(bb_to)
                bb_to ^= abb.abb_mask[ito]
                bb_can_promote = BB_Rev_Color_Position[color] & abb.abb_mask[ito]
                if bb_can_promote > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Lance, bt.board[ito].abs, 1)
                    idx += 1
                end
                if (BB_Knight_Must_Promote[color] & abb.abb_mask[ito]) == 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Lance, bt.board[ito].abs, 0)
                    idx += 1                   
                end
            end
        end
        bb_from = bt.bb_piece[color][Bishop]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_diagonal_mask_ex[ifrom]
            bb_to = abb.abb_diagonal_attacks[ifrom][h] & bb_can_cap
            while bb_to > 0
                ito = bitop.bitscan(bb_to)
                bb_to ^= abb.abb_mask[ito]
                bb_from_to = abb.abb_mask[ifrom] | abb.abb_mask[ito]
                bb_can_promote = BB_Rev_Color_Position[color] & bb_from_to
                if bb_can_promote > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Bishop, bt.board[ito].abs, 1)
                else
                    move_list[idx] = cls_move.pack(ifrom, ito, Bishop, bt.board[ito].abs, 0)
                end
                idx += 1
            end
        end
        bb_from = bt.bb_piece[color][Horse]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_diagonal_mask_ex[ifrom]
            bb_to = (abb.abb_diagonal_attacks[ifrom][h] | abb.abb_piece_attacks[color][King][ifrom]) & bb_can_cap
            while bb_to > 0
                ito = bitop.bitscan(bb_to)
                bb_to ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Horse, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        bb_from = bt.bb_piece[color][Rook]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_cross_mask_ex[ifrom]
            bb_to = abb.abb_cross_attacks[ifrom][h] & bb_can_cap
            while bb_to > 0
                ito = bitop.bitscan(bb_to)
                bb_to ^= abb.abb_mask[ito]
                bb_from_to = abb.abb_mask[ifrom] | abb.abb_mask[ito]
                bb_can_promote = BB_Rev_Color_Position[color] & bb_from_to
                if bb_can_promote > 0
                    move_list[idx] = cls_move.pack(ifrom, ito, Rook, bt.board[ito].abs, 1)
                else
                    move_list[idx] = cls_move.pack(ifrom, ito, Rook, bt.board[ito].abs, 0)
                end
                idx += 1
            end
        end
        bb_from = bt.bb_piece[color][Dragon]
        while bb_from > 0
            ifrom = bitop.bitscan(bb_from)
            bb_from ^= abb.abb_mask[ifrom]
            h = bb_occupied & abb.abb_cross_mask_ex[ifrom]
            bb_to = (abb.abb_cross_attacks[ifrom][h] | abb.abb_piece_attacks[color][King][ifrom]) & bb_can_cap
            while bb_to > 0
                ito = bitop.bitscan(bb_to)
                bb_to ^= abb.abb_mask[ito]
                move_list[idx] = cls_move.pack(ifrom, ito, Dragon, bt.board[ito].abs, 0)
                idx += 1
            end
        end
        return move_list, idx
    end
end