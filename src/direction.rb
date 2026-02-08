class Direction
    require './common'
    require './rank'
    require './file'
    Direc_Misc = 0
    Direc_Diag1_U2d = 8
    Direc_Diag1_D2u = -8
    Direc_Diag2_U2d = 10
    Direc_Diag2_D2u = -10
    Direc_File_U2d = 9
    Direc_File_D2u = -9
    Direc_Rank_L2r = 1
    Direc_Rank_R2l = -1
    Direc_Knight_L_U2d = 19
    Direc_Knight_R_U2d = 17
    Direc_Knight_L_D2u = -17
    Direc_Knight_R_D2u = -19
    def init()
        adirec = Array.new(Square_NB){Array.new(Piece_NB){}}
        f = File.new("adirec.txt", "r")
        ls = f.readlines(chomp: true)
        f.close
        limit = ls.count
        i = 0
        while i < limit
            s = ls[i].split(',')
            from = s[0].to_i
            to = s[1].to_i
            direc = s[2].to_i
            adirec[from][to] = direc
            i += 1
        end
        return adirec
    end
end