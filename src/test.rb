class Test
    require './common'
    require './piece'
    #require './file'
    require './color'
    require './board'
    require './sfen'
    require './drop'
    require './nocap'
    require './cap'
    require './move'
    require './csa'
    require './evasion'
    require './makemove'
    require './check'
    #require './mate1ply'
    def test_drop_moves(bt, at, hs, rd, di, am, bi, cls_board, abb)
        test_file_name = "test_data_drop.txt"
        comments, positions = read_test_data(test_file_name)
        answer_file_name = "answer_data_drop.txt"
        _, answers = read_test_data(answer_file_name)
        limit = positions.count
        log_file_name = "error_log.txt"
        lf = File.new(log_file_name, "w")
        cls_drop = Drop.new()
        cls_sfen = SFEN.new()
        cls_move = Move.new()
        cls_csa = CSA.new()
        move_list = Array.new(700)
        idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(am, bi, hs, rd)
        idx = 0
        while idx < limit
            print positions[idx]
            bt = cls_sfen.to_board(positions[idx], am, bi, hs, rd, cls_board)
            print "\n"
            print bt
            move_list, move_count = cls_drop.generate(bt, bt.root_color, move_list, abb, di, 0, at, bi, cls_move)
            print move_list
            print "\n"
            print move_count
            print "\n"
            temp_answer = answers[idx].split(" ")
            i = 0
            while i < move_count
                if temp_answer[i] != nil
                    move = cls_csa.csa_to_move(bt, temp_answer[i], cls_move)
                    print move
                    if !move_list.include?(move)
                        print "error in line"
                        print idx+1
                        print "\n"
                        print "move="
                        print temp_answer[i]
                        print "\n"
                        s = "error in line " + (idx+1).to_s + "\n"
                        lf.write(s)
                        #return
                    end
                    #break
                end
                i += 1
                #break
            end
            idx += 1
        end
        lf.close()
    end
    def test_nocap_moves(bt, at, hs, rd, atkop, bi, cls_board)
        test_file_name = "test_data_gennocap.txt"
        comments, positions = read_test_data(test_file_name)
        answer_file_name = "answer_data_gennocap.txt"
        _, answers = read_test_data(answer_file_name)
        limit = positions.count
        log_file_name = "error_log.txt"
        lf = File.new(log_file_name, "w")
        cls_nocap = NoCap.new()
        cls_sfen = SFEN.new()
        cls_move = Move.new()
        cls_csa = CSA.new()
        move_list = Array.new(700)
        idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(at.abb_mask, bi, hs, rd)
        idx = 0
        while idx < limit
            print positions[idx]
            bt = cls_sfen.to_board(positions[idx], at.abb_mask, bi, hs, rd, cls_board)
            print "\n"
            print bt
            move_list, move_count = cls_nocap.generate(bt, bt.root_color, move_list, at, 0, atkop, bi, cls_move)
            print move_list
            print "\n"
            print move_count
            print "\n"
            temp_answer = answers[idx].split(" ")
            print temp_answer[0]
            i = 0
            while i < move_count
                if temp_answer[i] != nil
                    move = cls_csa.csa_to_move(bt, temp_answer[i], cls_move)
                    if !move_list.include?(move)
                        print "error in line"
                        print i+1
                        print "\n"
                        print "move="
                        print move
                        print "\n"
                        s = "error in line " + (i+1).to_s + "\n"
                        lf.write(s)
                    end
                end
                #break
                i += 1
            end
            #break
            idx += 1
        end
        lf.close()
    end
    def test_cap_moves(bt, at, hs, rd, atkop, bi, cls_board)
        test_file_name = "test_data_gencap.txt"
        comments, positions = read_test_data(test_file_name)
        answer_file_name = "answer_data_gencap.txt"
        _, answers = read_test_data(answer_file_name)
        limit = positions.count
        log_file_name = "error_log.txt"
        lf = File.new(log_file_name, "w")
        cls_cap = Cap.new()
        cls_sfen = SFEN.new()
        cls_move = Move.new()
        cls_csa = CSA.new()
        move_list = Array.new(700)
        idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(at.abb_mask, bi, hs, rd)
        idx = 0
        while idx < limit
            print positions[idx]
            bt = cls_sfen.to_board(positions[idx], at.abb_mask, bi, hs, rd, cls_board)
            print "\n"
            print bt
            move_list, move_count = cls_cap.generate(bt, bt.root_color, move_list, at, 0, atkop, bi, cls_move)
            print move_list
            print "\n"
            print move_count
            print "\n"
            temp_answer = answers[idx].split(" ")
            print temp_answer[0]
            i = 0
            while i < move_count
                if temp_answer[i] != nil
                    move = cls_csa.csa_to_move(bt, temp_answer[i], cls_move)
                    if !move_list.include?(move)
                        print "error in line"
                        print idx+1
                        print "\n"
                        print "move="
                        print move
                        print "\n"
                        s = "error in line " + (idx+1).to_s + "," + temp_answer[i] + "\n"
                        lf.write(s)
                        #if idx == 34
                        #    return
                        #end
                    end
                end
                #break
                i += 1
            end
            #break
            idx += 1
        end
        lf.close()
    end
    def test_evasion_moves(bt, at, hs, rd, di, atkop, bi, cls_board)
        test_file_name = "test_data_evasion.txt"
        comments, positions = read_test_data(test_file_name)
        print comments.count
        print "\n"
        print positions.count
        print "\n"
        answer_file_name = "answer_data_evasion.txt"
        _, answers = read_test_data(answer_file_name)
        print answers.count
        #return
        limit = positions.count
        log_file_name = "error_log.txt"
        lf = File.new(log_file_name, "w")
        cls_evasion = Evasion.new()
        cls_sfen = SFEN.new()
        cls_move = Move.new()
        cls_csa = CSA.new()
        cls_mm = MakeMove.new()
        move_list = Array.new(700)
        idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(at.abb_mask, bi, hs, rd)
        idx = 0
        while idx < limit
            print positions[idx]
            bt = cls_sfen.to_board(positions[idx], at.abb_mask, bi, hs, rd, cls_board)
            print "\n"
            print positions[idx]
            print bt
            move_list = Array.new(700)
            move_list, move_count = cls_evasion.generate(bt, bt.root_color, move_list, at, di, 0, atkop, bi, cls_move, cls_mm, rd)
            print move_list
            print "\n"
            print move_count
            print "\n"
            temp_answer = answers[idx].split(" ")
            temp_comment = comments[idx]
            print temp_answer[0]
            i = 0
            print [move_list, move_count]
            if move_count == nil
                print "foo\n"
            end
            while i < move_count
                if temp_answer[i] != nil
                    move = cls_csa.csa_to_move(bt, temp_answer[i], cls_move)
                    if !move_list.include?(move)
                        print "error in line"
                        print idx+1
                        print "\n"
                        print "move="
                        print move
                        print "\n"
                        s = "error in line " + (idx+1).to_s + "," + temp_answer[i] + "\n"
                        lf.write(s)
                        lf.write(temp_comment)
                        #if idx == 148
                        #    return
                        #end
                    end
                end
                #break
                i += 1
            end
            #break
            idx += 1
        end
        lf.close()
    end
    def test_check_moves(bt, at, hs, rd, di, atkop, bi, cls_board)
        test_file_name = "test_data_check.txt"
        comments, positions = read_test_data(test_file_name)
        answer_file_name = "answer_data_check.txt"
        _, answers = read_test_data(answer_file_name)
        limit = positions.count
        log_file_name = "error_log.txt"
        lf = File.new(log_file_name, "w")
        cls_check = Check.new()
        cls_sfen = SFEN.new()
        cls_move = Move.new()
        cls_csa = CSA.new()
        cls_mm = MakeMove.new()
        move_list = Array.new(700)
        idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(at.abb_mask, bi, hs, rd)
        idx = 0
        while idx < limit
            print positions[idx]
            bt = cls_sfen.to_board(positions[idx], at.abb_mask, bi, hs, rd, cls_board)
            print "\n"
            print bt
            move_list = Array.new(700)
            move_list, move_count = cls_check.generate(bt, bt.root_color, move_list, at, di, 0, atkop, bi, cls_move)
            print move_list
            print "\n"
            print move_count
            print "\n"
            temp_answer = answers[idx].split(" ")
            print temp_answer[0]
            temp_comment = comments[idx]
            i = 0
            while i < move_count
                if temp_answer[i] != nil
                    move = cls_csa.csa_to_move(bt, temp_answer[i], cls_move)
                    if !move_list.include?(move)
                        print "error in line"
                        print idx+1
                        print "\n"
                        print "move="
                        print move
                        print "\n"
                        print temp_answer[i]
                        print "\n"
                        print bt.board
                        s = "error in line " + (idx+1).to_s + "," + temp_answer[i] + "\n"
                        lf.write(s)
                        lf.write("\n")
                        lf.write(temp_comment)
                        lf.write("\n")
                        lf.write(move_list)
                        lf.write("\n")
                        lf.write(move)
                        lf.write("\n")
                        lf.write(bt.board[50].abs)
                        lf.write("\n")
                        if idx == 113
                            return
                        end
                    end
                end
                #break
                i += 1
            end
            #break
            idx += 1
        end
        lf.close()
    end
    def test_check_moves_additional_b(bt, at, hs, rd, di, atkop, bi, cls_board)
        test_file_name = "test_data_b_check_additional.txt"
        comments, positions = read_test_data(test_file_name)
        #answer_file_name = "answer_data_b_check_additional.txt"
        #_, answers = read_test_data(answer_file_name)
        limit = positions.count
        log_file_name = "answer_log.txt"
        lf = File.new(log_file_name, "w")
        cls_check = Check.new()
        cls_sfen = SFEN.new()
        cls_move = Move.new()
        cls_csa = CSA.new()
        cls_mm = MakeMove.new()
        move_list = Array.new(700)
        idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(at.abb_mask, bi, hs, rd)
        idx = 0
        while idx < limit
            #print positions[idx]
            bt = cls_sfen.to_board(positions[idx], at.abb_mask, bi, hs, rd, cls_board)
            print "\n"
            #print bt
            move_list = Array.new(700)
            move_list, move_count = cls_check.generate(bt, bt.root_color, move_list, at, di, 0, atkop, bi, cls_move)
            print (idx + 1)
            print "\n"
            lf.write(idx + 1)
            lf.write(",")
            str_moves = ""
            i = 0
            while i < move_count
                m = move_list[i]
                str_csa = cls_csa.move_to_csa(m, cls_move)
                print str_csa
                print "\n"
                lf.write(str_csa)
                lf.write(",")
                move = cls_csa.csa_to_move(bt, str_csa, cls_move)
                i += 1
            end
            lf.write("\n")
            idx += 1
        end
        lf.close()
    end
    def test_check_moves_additional_w(bt, at, hs, rd, di, atkop, bi, cls_board)
        test_file_name = "test_data_w_check_additional.txt"
        comments, positions = read_test_data(test_file_name)
        #answer_file_name = "answer_data_b_check_additional.txt"
        #_, answers = read_test_data(answer_file_name)
        limit = positions.count
        log_file_name = "answer_log2.txt"
        lf = File.new(log_file_name, "w")
        cls_check = Check.new()
        cls_sfen = SFEN.new()
        cls_move = Move.new()
        cls_csa = CSA.new()
        cls_mm = MakeMove.new()
        move_list = Array.new(700)
        idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(at.abb_mask, bi, hs, rd)
        idx = 0
        while idx < limit
            #print positions[idx]
            bt = cls_sfen.to_board(positions[idx], at.abb_mask, bi, hs, rd, cls_board)
            print "\n"
            #print bt
            move_list = Array.new(700)
            move_list, move_count = cls_check.generate(bt, bt.root_color, move_list, at, di, 0, atkop, bi, cls_move)
            print (idx + 1)
            print "\n"
            lf.write(idx + 1)
            lf.write(",")
            str_moves = ""
            i = 0
            while i < move_count
                m = move_list[i]
                str_csa = cls_csa.move_to_csa(m, cls_move)
                print str_csa
                print "\n"
                lf.write(str_csa)
                lf.write(",")
                move = cls_csa.csa_to_move(bt, str_csa, cls_move)
                i += 1
            end
            lf.write("\n")
            idx += 1
        end
        lf.close()
    end
    def test_mate1ply_b(bt, at, hs, rd, di, am, bi, cls_board, abb)
        test_file_name = "test_data_b_mate1ply.txt"
        comments, positions = read_test_data(test_file_name)
        answer_file_name = "answer_data_b_mate1ply.txt"
        _, answers = read_test_data(answer_file_name)
        limit = positions.count
        log_file_name = "error_log.txt"
        log_file_name2 = "not_mate_log.txt"
        log_file_name3 = "debug_log_mate1ply_b.txt"
        lf = File.new(log_file_name, "w")
        lf2 = File.new(log_file_name2, "w")
        lf3 = File.new(log_file_name3, "w")
        cls_mate1ply = Mate1Ply.new()
        cls_sfen = SFEN.new()
        cls_move = Move.new()
        cls_csa = CSA.new()
        move_list = Array.new(700)
        idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(am, bi, hs, rd)
        idx = 0
        while idx < limit
            print "mate1ply_b idx="
            print idx
            print "\n"
            print positions[idx]
            bt = cls_sfen.to_board(positions[idx], am, bi, hs, rd, cls_board)
            print "\n"
            print bt
            print "before exec mate1ply\n"
            #move_list, move_count = cls_drop.generate(bt, bt.root_color, move_list, abb, di, 0, at, bi, cls_move)
            move = cls_mate1ply.mate_in_1ply(bt, bt.root_color, abb, di, at, bi, cls_move)
            lf3.write(comments[idx] + "\n")
            if move == 0
                lf2.write("no_mate in line")
                lf2.write(idx+1)
                lf2.write(" ")
                lf2.write("\n")
                lf3.write("\n")
            else
                ss = cls_csa.move_to_csa(move, cls_move)
                lf3.write(ss + "\n")
            end
            print "mate_move="
            print move
            print "\n"
            temp_answer = answers[idx]
            #if idx == 73
            #    break
            #end
            if temp_answer != nil && temp_answer != ""
                move2 = cls_csa.csa_to_move(bt, temp_answer, cls_move)
                print "move2="
                print move2
                print "\n"
                print "Ric\n"
                print move
                print "\n"
                if move != move2
                    print "error in line"
                    print idx+1
                    print "\n"
                    print "move="
                    print temp_answer
                    print "\n"
                    s = "error in line " + (idx+1).to_s + "\n"
                    lf.write(s)
                    lf.write("\n")
                    lf.write(temp_answer)
                    lf.write("\n")

                    if idx + 1 == 148
                        idx += 1
                        next
                    elsif idx + 1 == 178
                        idx += 1
                        next
                    elsif idx + 1 == 183
                        idx += 1
                        next
                    elsif idx + 1 == 271
                        idx += 1
                        next
                    elsif idx + 1 == 272
                        idx += 1
                        next
                    elsif idx + 1 == 276
                        idx += 1
                        next
                    elsif idx + 1 == 302
                        idx += 1
                        next
                    elsif idx + 1 == 303
                        idx += 1
                        next
                    elsif idx + 1 == 306
                        idx += 1
                        next
                    elsif idx + 1 == 350
                        idx += 1
                        next
                    elsif idx + 1 == 351
                        idx += 1
                        next
                    elsif idx + 1 == 352
                        idx += 1
                        next
                    elsif idx + 1 == 353
                        idx += 1
                        next
                    elsif idx + 1 == 354
                        idx += 1
                        next
                    elsif idx + 1 == 364
                        idx += 1
                        next
                    elsif idx + 1 == 385
                        idx += 1
                        next
                    elsif idx + 1 == 397
                        idx += 1
                        next
                    elsif idx + 1 == 403
                        idx += 1
                        next
                    end
                    return
                end
                #break
            end
            idx += 1
        end
        print "last idx="
        print idx
        print "\n"
        lf.close()
        lf2.close()
        lf3.close()
    end
    def read_test_data(file_name)
        comments = []
        positions = []
        f = File.new(file_name, "r")
        ls = f.readlines(chomp: true)
        f.close()
        limit = ls.count
        flag = 1
        i = 0
        while i < limit
            if flag == 1
                comments.push(ls[i])
            else
                positions.push(ls[i])
            end
            flag ^= 1
            i += 1
        end
        return comments, positions
    end
    def test_do(bt, at, hs, rd, di, am, bi, cls_board, abb, clsio)
        test_file_name = "20220501_nhk_hai.txt"
        records = clsio.read_record_file(test_file_name, am, bi, hs, rd)
        print "\n"
        print records.count
        #return
        #limit = positions.count
        log_file_name = "error_log.txt"
        lf = File.new(log_file_name, "w")
        cls_mm = MakeMove.new()
        #cls_drop = Drop.new()
        #cls_sfen = SFEN.new()
        cls_move = Move.new()
        #cls_csa = CSA.new()
        #move_list = Array.new(700)
        #idx = 0
        #bt, color, move_list, abb, di, idx, atkop, bitop, cls_move
        bt = cls_board.board_init(am, bi, hs, rd)
        limit = records[0].moves.count
        #print limit
        color = 0
        idx = 0
        while idx < limit
            move = records[0].moves[idx]
            cls_mm.Do(bt, color, move, cls_move, am, rd)
            idx += 1
            color ^= 1
        end
        out_board(bt)
        lf.close()
    end
    def test_undo(bt, at, hs, rd, di, am, bi, cls_board, abb, clsio)
        test_file_name = "test_records.txt"
        records = clsio.read_record_file(test_file_name, am, bi, hs, rd)
        print "\n"
        print records.count
        #return
        #limit = positions.count
        rc = records.count
        log_file_name = "error_log.txt"
        lf = File.new(log_file_name, "w")
        cls_mm = MakeMove.new()
        cls_move = Move.new()
        #bt = cls_board.board_init(am, bi, hs, rd)
        #limit = records[0].moves.count
        #print limit
        i = 0
        while i < rc
            color = 0
            idx = 0
            current_record = records[i]
            limit = current_record.moves.count
            bt = cls_board.board_init(am, bi, hs, rd)
            while idx < limit
                move = current_record.moves[idx]
                bt_copy = cls_board.board_init(am, bi, hs, rd)
                bt_copy = copy_board(bt, bt_copy)
                print "aaa\n"
                print bt.bb_piece
                print "\n"
                print bt_copy.bb_piece
                print "\n"
                cls_mm.Do(bt, color, move, cls_move, am, rd)
                cls_mm.UnDo(bt, color, move, cls_move, am)
                if verify_board(bt, bt_copy)
                    print "\n"
                    print "record_number = "
                    print (i + 1)
                    print "\n"
                    print "idx="
                    print idx
                    print "\n"
                    print bt.bb_occupied[0]
                    print "\n"
                    print bt_copy.bb_occupied[0]
                    lf.close()
                    return
                end
                cls_mm.Do(bt, color, move, cls_move, am, rd)
                idx += 1
                color ^= 1
                #if idx == 3
                #    lf.close()
                #    return
                #end
            end
            i += 1
        end
        #out_board(bt)
        print "michael wallstreet\n"
        lf.close()
    end
    def out_board(bt)
        f = File.new("board_log.txt", "w")
        i = 0
        j = 0
        s = ""
        while i < Square_NB
            print "\n"
            print bt.board[i]
            print "\n"
            if bt.board[i] > 0
                case bt.board[i]
                when Pawn
                    s += " 歩"
                when Lance
                    s += " 香"
                when Knight
                    s += " 桂"
                when Silver
                    s += " 銀"
                when Gold
                    s += " 金"
                when Bishop
                    s += " 角"
                when Rook
                    s += " 飛"
                when King
                    s += " 玉"
                when Pro_Pawn
                    s += " と"
                when Pro_Lance
                    s += " 杏"
                when Pro_Knight
                    s += " 圭"
                when Pro_Silver
                    s += " 全"
                when Horse
                    s += " 馬"
                when Dragon
                    s += " 龍"
                end
            elsif bt.board[i] < 0
                case bt.board[i].abs
                when Pawn
                    s += "v歩"
                when Lance
                    s += "v香"
                when Knight
                    s += "v桂"
                when Silver
                    s += "v銀"
                when Gold
                    s += "v金"
                when Bishop
                    s += "v角"
                when Rook
                    s += "v飛"
                when King
                    s += "v玉"
                when Pro_Pawn
                    s += "vと"
                when Pro_Lance
                    s += "v杏"
                when Pro_Knight
                    s += "v圭"
                when Pro_Silver
                    s += "v全"
                when Horse
                    s += "v馬"
                when Dragon
                    s += "v龍"
                end
            else
                s += "   "
            end
            i += 1
            j += 1
            print "\nj="
            print j
            if j == 9
                s += "\n"
                print s
                print "\nj="
                print j
                #print bt.board
                f.write(s)
                s = ""
                j = 0
            else
                s += ","
            end
        end
        c = 0
        while c <= White
            i = 7
            s = ""
            if c == 0
                s = "先手の持ち駒："
            else
                s = "後手の持ち駒："
            end
            while i > Empty
                #print bt.hand[0] & Hand_Mask[i]
                b = bt.hand[c] & Hand_Mask[i]
                n_hand = b >> Hand_Rev_Bit[i]
                if c == Black
                    case i
                    when Pawn
                        s += "歩" + n_hand.to_s
                    when Lance
                        s += "香" + n_hand.to_s
                    when Knight
                        s += "桂" + n_hand.to_s
                    when Silver
                        s += "銀" + n_hand.to_s
                    when Gold
                        s += "金" + n_hand.to_s
                    when Bishop
                        s += "角" + n_hand.to_s
                    when Rook
                        s += "飛" + n_hand.to_s
                    end
                else
                    case i
                      when Pawn
                        s += "歩" + n_hand.to_s
                    when Lance
                        s += "香" + n_hand.to_s
                    when Knight
                        s += "桂" + n_hand.to_s
                    when Silver
                        s += "銀" + n_hand.to_s
                    when Gold
                        s += "金" + n_hand.to_s
                    when Bishop
                        s += "角" + n_hand.to_s
                    when Rook
                        s += "飛" + n_hand.to_s
                    end
                end
                #print n_hand
                #print "\n"
                i -= 1
                if i == Empty
                    s += "\n"
                else
                    s += ","
                end
            end
            f.write(s)
            c += 1
        end
        f.close
    end
    def copy_board(b0, b1)
        b1.bb_occupied[0] = b0.bb_occupied[0]
        b1.bb_occupied[1] = b0.bb_occupied[1]
        i = 0
        while i <= Dragon
            b1.bb_piece[0][i] = b0.bb_piece[0][i]
            b1.bb_piece[1][i] = b0.bb_piece[1][i]
            i += 1
        end
        i = 0
        while i < Square_NB
            b1.board[i] = b0.board[i]
            i += 1
        end
        b1.hand = b0.hand
        b1.root_color = b0.root_color
        b1.sq_king[0] = b0.sq_king[0]
        b1.sq_king[1] = b0.sq_king[1]
        b1.ply = b0.ply
        b1.current_hash = b0.current_hash
        b1.prev_hash = b0.prev_hash
        i = 0
        while i < Ply_Max
            b1.hash_array[i] = b0.hash_array[i]
            i += 1
        end
        i = 0
        while i < Moves_Max
            b1.root_moves[i] = b0.root_moves[i]
            i += 1
        end
        return b1
    end
    def verify_board(bt_before, bt_after)
        for i in [Black, White]
            for j in [Pawn, Lance, Knight, Silver, Gold, Bishop, Rook, King, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon]
                if bt_before.bb_piece[i][j] != bt_after.bb_piece[i][j]
                    print "error raise in bb_piece\n"
                    err_msg = "i=" + i.to_s + ", j=" + j.to_s + "\n"
                    print err_msg
                    return true
                end
            end
        end
        for i in [Black, White]
            if bt_before.bb_occupied[i] != bt_after.bb_occupied[i]
                print "error raise in bb_occupied\n"
                print "i=" + i.to_s + "\n"
                return true
            end
            if bt_before.hand[i] != bt_after.hand[i]
                print "error raise in hand\n"
                print "i=" + i.to_s + "\n"
                return true
            end
            if bt_before.sq_king[i] != bt_after.sq_king[i]
                print "error raise in sq_king\n"
                print "i=" + i.to_s + "\n"
                print "bt.before=" + bt_before.sq_king[i].to_s + "\n"
                print "bt.after="  + bt_after.sq_king[i].to_s + "\n"
                return true
            end
        end
        i = 0
        while i < Square_NB
            if bt_before.board[i] != bt_after.board[i]
                print "error raise in board\n"
                print "i=" + i.to_s + "\n"
                print "bt.before=" + bt_before.board[i].to_s + "\n"
                print "bt.after=" + bt_after.board[i].to_s + "\n"
                return true
            end
            i += 1
        end
        if bt_before.root_color != bt_after.root_color
            print "error raise in root_color\n"
            return true
        end
        if bt_before.ply != bt_after.ply
            print "error raise in ply\n"
            print "bt.before=" + bt_before.ply.to_s + "\n"
            print "bt.after=" + bt_after.ply.to_s + "\n"
            return true
        end
        if bt_before.current_hash != bt_after.current_hash
            print "error raise in current_hash\n"
            return true
        end
        if bt_before.prev_hash != bt_after.prev_hash
            print "error raise in prev_hash\n"
            print "bt.before=" + bt_before.prev_hash.to_s + "\n"
            print "bt.after=" + bt_after.prev_hash.to_s + "\n"
            return true
        end
        i = 0
        while i < Ply_Max
            if bt_before.hash_array[i] != bt_after.hash_array[i]
                print "error raise in hash_array\n"
                print "i=" + i.to_s + "\n"
                print "bt.before=" + bt_before.hash_array[i].to_s + "\n"
                print "bt.after=" + bt_after.hash_array[i].to_s + "\n"
                return true
            end
            i += 1
        end
        return false
    end
end