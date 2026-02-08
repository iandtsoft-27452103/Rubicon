class MakeMove
    require './common'
    require './piece'
    require './move'
    def Do(bt, color, m, cm, am, rs)
        isign = [-1, 1]
        bt.prev_hash = bt.current_hash
        from = cm.from(m)
        to = cm.to(m)
        pc = cm.piece_type(m)
        is_promote = cm.is_promo(m)
        if from >= Square_NB
            bt.bb_piece[color][pc] ^= am[to]
            bt.current_hash ^= rs[color][pc][to]
            bt.hand[color] -= Hand_Hash[pc]
            bt.board[to] = -isign[color] * pc
            bt.bb_occupied[color] ^= am[to]
        else
            bb_set_clear = (am[from] | am[to])
            bt.bb_occupied[color] ^= bb_set_clear
            bt.board[from] = Empty
            if is_promote == 1
                bt.bb_piece[color][pc] ^= am[from]
                bt.bb_piece[color][pc + Promote] ^= am[to]
                bt.current_hash ^= rs[color][pc][from] ^ rs[color][pc + Promote][to]
                bt.board[to] = -isign[color] * (pc + Promote)
            else
                if pc == King
                    bt.sq_king[color] = to
                end
                bt.bb_piece[color][pc] ^= bb_set_clear
                bt.current_hash ^= rs[color][pc][from] ^ rs[color][pc][to]
                bt.board[to] = -isign[color] * pc
            end
            cap = index = cm.cap_piece(m)
            if cap != 0
                if cap > King
                    index -= Promote
                end
                bt.hand[color] += Hand_Hash[index]
                bt.bb_piece[color ^ 1][cap] ^= am[to]
                bt.current_hash ^= rs[color][cap][to]
                bt.bb_occupied[color ^ 1] ^= am[to]
            end
        end
        bt.hash_array[bt.ply] = bt.prev_hash
        bt.hash_array[bt.ply + 1] = bt.current_hash
        bt.ply += 1
    end
    def UnDo(bt, color, m, cm, am)
        isign = [-1, 1]
        bt.current_hash = bt.prev_hash
        from = cm.from(m)
        to = cm.to(m)
        pc = cm.piece_type(m)
        is_promote = cm.is_promo(m)
        if from >= Square_NB
            bt.bb_piece[color][pc] ^= am[to]
            bt.hand[color] += Hand_Hash[pc]
            bt.board[to] = Empty
            bt.bb_occupied[color] ^= am[to]
        else
            bb_set_clear = (am[from] | am[to])
            bt.bb_occupied[color] ^= bb_set_clear
            bt.board[from] = -isign[color] * pc
            if is_promote == 1
                bt.bb_piece[color][pc] ^= am[from]
                bt.bb_piece[color][pc + Promote] ^= am[to]
            else
                if pc == King
                    bt.sq_king[color] = from
                end
                bt.bb_piece[color][pc] ^= bb_set_clear
            end
        end
        cap = index = cm.cap_piece(m)
        if cap != 0
            if cap > King
                index -= Promote
            end
            bt.hand[color] -= Hand_Hash[index]
            bt.bb_piece[color ^ 1][cap] ^= am[to]
            bt.bb_occupied[color ^ 1] ^= am[to]
            bt.board[to] = isign[color] * cap
        else
            bt.board[to] = Empty
        end
        bt.prev_hash = bt.hash_array[bt.ply - 2]
        bt.hash_array[bt.ply] = 0#配列のインデックスが1ずれていないかチェックする
        bt.ply -= 1
    end
end
