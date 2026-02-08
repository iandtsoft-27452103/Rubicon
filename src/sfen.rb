require './common'
require './piece'
Str_Start_Pos = "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
Str_Pc = {Pawn=>"P", Lance=>"L", Knight=>"N", Silver=>"S", Gold=>"G", Bishop=>"B", Rook=>"R", King=>"K",
          Pro_Pawn=>"+P", Pro_Lance=>"+L", Pro_Knight=>"+N", Pro_Silver=>"+S", Horse=>"+B", Dragon=>"+R",
          -Pawn=>"p", -Lance=>"l", -Knight=>"n", -Silver=>"s", -Gold=>"g", -Bishop=>"b", -Rook=>"r", -King=>"k",
          -Pro_Pawn=>"+p", -Pro_Lance=>"+l", -Pro_Knight=>"+n", -Pro_Silver=>"+s", -Horse=>"+b", -Dragon=>"+r", Empty=>""}
Int_Pc = {"P"=>Pawn,  "L"=>Lance,  "N"=>Knight,  "S"=>Silver,  "G"=>Gold,  "B"=>Bishop,  "R"=>Rook,  "K"=>King,
          "p"=>-Pawn, "l"=>-Lance, "n"=>-Knight, "s"=>-Silver, "g"=>-Gold, "b"=>-Bishop, "r"=>-Rook, "k"=>-King }
Set_Empty_Num = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
Int_Empty_Num = {"1"=>1, "2"=>2, "3"=>3, "4"=>4, "5"=>5, "6"=>6, "7"=>7, "8"=>8, "9"=>9}
Set_Hand_Num = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
Int_Hand_Num = {"0"=>0, "1"=>1, "2"=>2, "3"=>3, "4"=>4, "5"=>5, "6"=>6, "7"=>7, "8"=>8, "9"=>9}

class SFEN
    require './common'
    require './file'
    require './color'
    def to_sfen(bt, color)
        str_sfen = ""
        i = 1
        empty_count = 0
        flag = false
        while i < Square_NB
            str_piece = Str_Pc[bt.board[i]]
            if str_piece == ""
                empty_count += 1
                flag = true
            else
                if flag == true
                    flag = false
                    str_sfen += empty_count.to_s
                    empty_count = 0
                end
                str_sfen += str_piece
            end
            if i != (Square_NB - 1) && FileTable[i] == File9
                if empty_count > 0
                    flag = false
                    str_sfen += empty_count.to_s
                    empty_count = 0
                end
                str_sfen += "/"
            end            
            i += 1
        end
        if color == Black
            str_sfen += " b "
        else
            str_sfen += " w "
        end
        for i in [Black, White]
            for j in [Pawn, Lance, Knight, Silver, Gold, Bishop, Rook]
                num = (bt.hand[i] & Hand_Mask[j]) >> Hand_Rev_Bit[j]
                if num > 0
                    if num == 1
                        if i == Black
                            k = j
                        else
                            k = -j
                        end
                        str_sfen += Str_Pc[k]
                    else
                        if num < 5
                            if i == Black
                                k = j
                            else
                                k = -j
                            end
                        else
                            if i == Black
                                k = Pawn
                            else
                                k = -Pawn
                            end
                        end
                        str_sfen += num.to_s + Str_Pc[k]
                    end
                end
            end
        end
        if bt.hand[Black] == 0 && bt.hand[White] == 0
            str_sfen += "-"
        end
        str_sfen += " 1"
        return str_sfen
    end
    def to_board(str_sfen, am, bi, hs, rd, cls_board)
        bt = cls_board.board_init(am, bi, hs, rd)
        bt.bb_piece = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
        bt.bb_occupied = [0, 0]
        bt.hand = [0, 0]
        bt.sq_king = [0, 0]
        bt.board = [0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0]
        bt.root_moves = Array.new(Square_NB)
        bt.root_moves.fill(0)
        bt.prev_hash = 0
        temp = str_sfen.split(" ")
        str_board = temp[0]
        limit = str_board.length
        flag = false
        empty_num = 0
        sq = 0
        i = 0
        while i < limit
            s = str_board[i]
            if s == '+'
                flag = true
            elsif s == '/'
                #
            else
                if Set_Empty_Num.include?(s)
                    empty_num = Int_Empty_Num[s]
                    j = 0
                    while j < empty_num
                        bt.board[sq] = Empty
                        sq += 1
                        j += 1
                    end
                else
                    int_pc = Int_Pc[s]
                    if int_pc > 0
                        if flag == true
                            int_pc += Promote
                            flag = false
                        end
                        bt.bb_piece[Black][int_pc] |= am[sq]
                        bt.bb_occupied[Black] |= am[sq]
                        if int_pc == King
                            bt.sq_king[Black] = sq
                        end
                    else
                        if flag == true
                            int_pc -= Promote
                            flag = false
                        end
                        bt.bb_piece[White][-int_pc] |= am[sq]
                        bt.bb_occupied[White] |= am[sq]
                        if int_pc == -King
                            bt.sq_king[White] = sq
                        end
                    end
                    bt.board[sq] = int_pc
                    sq += 1
                end
            end
            i += 1
        end
        if temp[1] == "b"
            bt.root_color = Black
        else
            bt.root_color = White
        end
        bt.current_hash = hs.hash_func(bt.bb_piece, am, bi, rd)

        str_hand = temp[2]
        limit = str_hand.length
        flag = false
        num = 1
        i = 0
        while i < limit
            s = str_hand[i]
            if s == '-'
                break
            end

            if s == '1' && flag == false
                flag = true
            else
                if flag == true
                    num = 10 + Int_Hand_Num[s]
                    flag = false
                else
                    if Set_Hand_Num.include?(s)
                        num = Int_Hand_Num[s]
                    else
                        int_pc = Int_Pc[s]
                        if int_pc > 0
                            color = Black
                        else
                            color = White
                            int_pc = -int_pc
                        end
                        j = 0
                        while j < num
                            bt.hand[color] += Hand_Hash[int_pc]
                            j += 1
                        end
                        num = 1
                    end
                end
            end
            i += 1
        end

        bt.hash_array = Array.new(Ply_Max)
        bt.hash_array.fill(0)
        bt.hash_array[0] = bt.prev_hash
        bt.hash_array[1] = bt.current_hash
        bt.ply = 1
        return bt
    end
end