class Hash256
    require './common'
    require './bitop'
    class RandWorkT
        attr_accessor :count, :cnst, :vec
        def init()
            @count = RandN; @cnst = [0, 0x9908b0df]; @vec = Array.new(RandN)
        end
    end
    def ini_random_table()
        piece_hash = Array.new(Color_NB){Array.new(Piece_NB){Array.new(Square_NB)}}
        rwt = RandWorkT.new
        rwt.init()
        ini_rand(rwt, 5489)
        i = 0
        while i < Color_NB
            j = 0
            while j < Piece_NB
                k = 0
                while k < Square_NB
                    piece_hash[i][j][k] = rand256(rwt)
                    k += 1
                end
                j += 1
            end
            i += 1
        end
        return piece_hash
    end
    def ini_rand(rwt, u)
        i = 0
        while i < RandN
            u = (i + 1812433253 * (u ^ u >> 30))
            u &= Mask32
            rwt.vec[i] = u
            i += 1
        end
    end
    def rand32(rwt)
        if rwt.count == RandN
            rwt.count = 0
            limit = RandN - RandM
            i = 0
            while i < limit
                u = rwt.vec[i] & MaskU
                u |= rwt.vec[i + 1] & MaskL
                u0 = rwt.vec[i + RandM]
                u1 = u >> 1
                u2 = rwt.cnst[u & 1]
                rwt.vec[i] = u0 ^ u1 ^ u2
                i += 1
            end
            i = limit + 1
            limit2 = RandN - 1
            while i < limit2
                u = rwt.vec[i] & MaskU
                u |= rwt.vec[i + 1] & MaskL
                u0 = rwt.vec[i + RandM - RandN]
                u1 = u >> 1
                u2 = rwt.cnst[u & 1]
                rwt.vec[i] = u0 ^ u1 ^ u2
                i += 1
            end
            u = rwt.vec[RandN - 1] & MaskU
            u |= rwt.vec[0] & MaskL
            u0 = rwt.vec[RandM - 1]
            u1 = u >> 1
            u2 = rwt.cnst[u & 1]
            rwt.vec[RandN - 1] = u0 ^ u1^ u2
        end
        u = rwt.vec[rwt.count]
        rwt.count += 1
        u ^= (u >> 11)
        u ^= (u << 7) & 0x9d2c5680
        u ^= ( u << 15 ) & 0xefc60000
        u ^= ( u >> 18 )
        return u
    end
    def rand64(rwt)
        h = rand32(rwt)
        l = rand32(rwt)
        v = (l | (h << 32))
        return v
    end
    def rand128(rwt)
        h = rand64(rwt)
        l = rand64(rwt)
        v = (l | (h << 64))
        return v
    end
    def rand256(rwt)
        h = rand128(rwt)
        l = rand128(rwt)
        v = (l | (h << 128))
        return v
    end
    def hash_func(bb_piece, am, bi, ph)
        h = 0
        i = 0
        while i < Color_NB
            j = 0
            while j < Piece_NB
                bb = bb_piece[i][j]
                while bb != 0
                    sq = bi.bitscan(bb)
                    bb ^= am[sq]
                    h ^= ph[i][j][sq]
                end
                j += 1
            end
            i += 1
        end
        return h
    end
end
