class Board
    require './common'
    require './piece'
    require './color'
    require './hash256'

    def bb_piece_init()
        bb = [[0, 133955584, 257, 130, 68, 40, 65536, 1024, 16, 0, 0, 0, 0, 0, 0, 0], [0, (511<<54), ((1<<80)|(1<<72)), ((1<<79)|(1<<73)), ((1<<78)|(1<<74)), ((1<<77)|(1<<75)), (1<<64), (1<<70), (1<<76), 0, 0, 0, 0, 0, 0, 0]]
        return bb
    end
    def bb_occupied_init()
        bb =  [((133955584)|(257)|(130)|(68)|(40)|(65536)|(1024)|(16)),((511<<54)|((1<<80)|1<<72))|((1<<79)|(1<<73))|((1<<78)|(1<<74))|((1<<77)|(1<<75))|(1<<64)|(1<<70)|(1<<76)]
        return bb
    end
    def hand_init()
        return [0, 0]
    end
    def root_color_init()
        return Black
    end
    def sq_king_init()
        return [76, 4]
    end
    def ply_init()
        return 1
    end
    def board_array_init()
        ar = [-Lance, -Knight, -Silver, -Gold, -King, -Gold, -Silver, -Knight, -Lance,
               Empty, -Rook  ,  Empty , Empty, Empty, Empty,  Empty , -Bishop, Empty ,
              -Pawn , -Pawn  , -Pawn  , -Pawn, -Pawn, -Pawn, -Pawn  , -Pawn  , -Pawn ,
               Empty, Empty  ,  Empty , Empty, Empty, Empty,  Empty ,  Empty , Empty ,
               Empty, Empty  ,  Empty , Empty, Empty, Empty,  Empty ,  Empty , Empty ,
               Empty, Empty  ,  Empty , Empty, Empty, Empty,  Empty ,  Empty , Empty ,
               Pawn , Pawn   ,  Pawn  , Pawn , Pawn , Pawn ,  Pawn  ,  Pawn  , Pawn  ,
               Empty, Bishop ,  Empty , Empty, Empty, Empty,  Empty ,  Rook  , Empty ,
               Lance, Knight ,  Silver, Gold , King , Gold ,  Silver,  Knight, Lance
             ]
        return ar
    end
    #root_movesが未実装
    def board_init(am, bi, hs, rd)
        b = Board.new
        o = b.bb_occupied_init()
        p = b.bb_piece_init()
        ar = b.board_array_init()
        h = b.hand_init()
        c = b.root_color_init()
        k = b.sq_king_init()
        ply = b.ply_init()
        chash = hs.hash_func(p, am, bi, rd)
        phash = 0
        har = Array.new(Ply_Max)
        har.fill(0)
        har[1] = chash
        rm = Array.new(Moves_Max)
        rm.fill(0)
        st = Struct.new(:bb_occupied, :bb_piece, :board, :hand, :root_color, :sq_king, :ply, :current_hash, :prev_hash, :hash_array, :root_moves)
        bt = st.new(o, p, ar, h, c, k, ply, chash, phash, har, rm)
        return bt
    end
end