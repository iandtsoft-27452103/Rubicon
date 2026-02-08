class InOut
    require './record'
    require './csa'
    require './move'
    require './board'
    require './makemove'
    def read_record_file(str_file_name, am, bi, hs, rd)
        cls_csa = CSA.new
        cm = Move.new
        cls_board = Board.new
        cls_mm = MakeMove.new
        f = File.new(str_file_name, "r")
        ls = f.readlines(chomp: true)
        f.close
        limit = ls.count
        rs = Array.new(limit, Record.new)
        rc = 0
        print ls
        #cnt_out = 0
        while rc < limit
            #$_
            #s = $_.split(',')
            if ls[rc] == nil
                break
            end
            s = ls[rc].split(',')
            ply = s[1].to_i#千日手の場合のデータにズレがあったので注意
            r = Record.new
            r.init(ply)
            if s[0] == "B"
                r.result = Black
            elsif s[0] == "W"
                r.result = White
            else
                r.result = 2
            end
            r.ply = ply
            i = 0
            bt = cls_board.board_init(am, bi, hs, rd)
            color = Black
            limit = s.length - 2
            while i < limit
                r.str_moves[i] = s[i + 2]
                str_csa = s[i + 2]
                r.moves[i] = cls_csa.csa_to_move(bt, str_csa, cm)
                move = r.moves[i]
                cls_mm.Do(bt, color, move, cm, am, rd)
                color ^= 1
                i += 1
            end
            rs[rc] = r
            rc += 1
            #cnt_out += 1
        end
        return rs
        #注）まだデータを返していない
    end
end
