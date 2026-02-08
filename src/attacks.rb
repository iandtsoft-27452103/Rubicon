class Attacks
    require './common'
    require './piece'
    require './color'
    def abb_mask_init()
        bbs = Array.new(Square_NB, 0)
        i = 0
        while i < Square_NB
            bbs[i] = 1 << (Square_NB - i - 1)
            i += 1
        end
        return bbs
    end
    def abb_piece_init(abb_mask)
        bbs = Array.new(Color_NB){Array.new(Piece_NB){Array.new(Square_NB, 0)}}
        c = Black
        while c < Color_NB
            pc = Pawn
            while pc < Piece_NB
                sq = 0
                while sq < Square_NB
                    if c == Black
                        if pc == Pawn and sq > 9
                            bbs[c][pc][sq] = abb_mask[sq - 9]
                        #elsif pc == Pawn and sq <= 9
                            #bbs[c][pc][sq] = 0
                        elsif pc == Silver
                            if sq == 0
                                bbs[c][pc][sq] = abb_mask[sq + 10]
                            elsif sq == 8
                                bbs[c][pc][sq] = abb_mask[sq + 8]
                            elsif sq == 72
                                bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq - 9])
                            elsif sq == 80
                                bbs[c][pc][sq] = (abb_mask[sq - 9] | abb_mask[sq - 10])
                            elsif sq >= 1 and sq <= 7
                                bbs[c][pc][sq] = (abb_mask[sq + 8] | abb_mask[sq + 10])
                            elsif sq >= 73 and sq <= 79
                                bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq - 9] | abb_mask[sq - 10])
                            elsif sq != 0 and sq != 72 and (abb_mask[sq] & BB_File[0]) != 0
                                bbs[c][pc][sq] = (abb_mask[sq - 9] | abb_mask[sq - 8] | abb_mask[sq + 10])
                            elsif sq != 8 and sq != 80 and (abb_mask[sq] & BB_File[8]) != 0
                                bbs[c][pc][sq] = (abb_mask[sq - 10] | abb_mask[sq - 9] | abb_mask[sq + 8])
                            else
                                bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq - 9] | abb_mask[sq - 10] | abb_mask[sq + 8] | abb_mask[sq + 10])
                            end
                        elsif (pc == Gold || pc == Pro_Pawn || pc == Pro_Lance || pc == Pro_Knight || pc == Pro_Silver)
                            if sq == 0
                                bbs[c][pc][sq] = (abb_mask[sq + 1] | abb_mask[sq + 9])
                            elsif sq == 8
                                bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq + 9])
                            elsif sq == 72
                                bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq - 9] | abb_mask[sq + 1])
                            elsif sq == 80
                                bbs[c][pc][sq] = (abb_mask[sq - 9] | abb_mask[sq - 10] | abb_mask[sq - 1])
                            elsif sq >= 1 and sq <= 7
                                bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq + 1] | abb_mask[sq + 9])
                            elsif sq >= 73 and sq <= 79
                                bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq - 8] | abb_mask[sq - 9] | abb_mask[sq - 10] | abb_mask[sq + 1])
                            elsif sq != 0 and sq != 72 and (abb_mask[sq] & BB_File[0]) != 0
                                bbs[c][pc][sq] = (abb_mask[sq - 9] | abb_mask[sq - 8] | abb_mask[sq + 1] | abb_mask[sq + 9])
                            elsif sq != 8 and sq != 80 and (abb_mask[sq] & BB_File[8]) != 0
                                bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq - 9] | abb_mask[sq - 8] | abb_mask[sq + 9])
                            else
                                bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq - 9] | abb_mask[sq - 10] | abb_mask[sq - 1] | abb_mask[sq + 1] | abb_mask[sq + 9])
                            end
                        elsif pc == Knight
                            if sq >= 18
                                if (abb_mask[sq] & BB_File[0]) != 0
                                    bbs[c][pc][sq] = abb_mask[sq - 17]
                                elsif (abb_mask[sq] & BB_File[8]) != 0
                                    bbs[c][pc][sq] = abb_mask[sq - 19]
                                else
                                    bbs[c][pc][sq] = (abb_mask[sq - 17] | abb_mask[sq - 19])
                                end
                            #else
                                #bbs[c][pc][sq] = 0
                            end
                        end
                    else
                        if pc == Pawn and sq < 72
                            bbs[c][pc][sq] = abb_mask[sq + 9]
                        #elsif pc == Pawn and sq >= 72
                            #bbs[c][pc][sq] = 0
                        elsif pc == Silver
                            if sq == 0
                                bbs[c][pc][sq] = (abb_mask[sq + 9] | abb_mask[sq + 10])
                            elsif sq == 8
                                bbs[c][pc][sq] = (abb_mask[sq + 8] | abb_mask[sq + 9])
                            elsif sq == 72
                                bbs[c][pc][sq] = abb_mask[sq - 8]
                            elsif sq == 80
                                bbs[c][pc][sq] = abb_mask[sq - 10]
                            elsif sq >= 1 and sq <= 7
                                bbs[c][pc][sq] = (abb_mask[sq + 8] | abb_mask[sq + 9] | abb_mask[sq + 10])
                            elsif sq >= 73 and sq <= 79
                                bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq - 10])
                            elsif sq != 0 and sq != 72 and (abb_mask[sq] & BB_File[0]) != 0
                                bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq + 9] | abb_mask[sq + 10])
                            elsif sq != 8 and sq != 80 and (abb_mask[sq] & BB_File[8]) != 0
                                bbs[c][pc][sq] = (abb_mask[sq - 10] | abb_mask[sq + 8] | abb_mask[sq + 9])
                            else
                                bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq - 10] | abb_mask[sq + 8] | abb_mask[sq + 9] | abb_mask[sq + 10])
                            end
                        elsif (pc == Gold || pc == Pro_Pawn || pc == Pro_Lance || pc == Pro_Knight || pc == Pro_Silver)
                            if sq == 0
                                bbs[c][pc][sq] = (abb_mask[sq + 1] | abb_mask[sq + 9] | abb_mask[sq + 10])
                            elsif sq == 8
                                bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq + 9] | abb_mask[sq + 8])
                            elsif sq == 72
                                bbs[c][pc][sq] = (abb_mask[sq - 9] | abb_mask[sq + 1])
                            elsif sq == 80
                                bbs[c][pc][sq] = (abb_mask[sq - 9] | abb_mask[sq - 1])
                            elsif sq >= 1 and sq <= 7
                                bbs[c][pc][sq] = (abb_mask[sq + 8] | abb_mask[sq + 9] | abb_mask[sq + 10] | abb_mask[sq - 1] | abb_mask[sq + 1])
                            elsif sq >= 73 and sq <= 79
                                bbs[c][pc][sq] = (abb_mask[sq - 1] |  abb_mask[sq - 9] |  abb_mask[sq + 1])
                            elsif sq != 0 and sq != 72 and (abb_mask[sq] & BB_File[0]) != 0
                                bbs[c][pc][sq] = (abb_mask[sq + 9] | abb_mask[sq + 10] | abb_mask[sq + 1] | abb_mask[sq - 9])
                            elsif sq != 8 and sq != 80 and (abb_mask[sq] & BB_File[8]) != 0
                                bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq - 9] | abb_mask[sq + 8] | abb_mask[sq + 9])
                            else
                                bbs[c][pc][sq] = (abb_mask[sq + 8] | abb_mask[sq + 9] | abb_mask[sq + 10] | abb_mask[sq - 1] | abb_mask[sq + 1] | abb_mask[sq - 9])
                            end
                        elsif pc == Knight
                            if sq <= 62
                                if (abb_mask[sq] & BB_File[0]) != 0
                                    bbs[c][pc][sq] = abb_mask[sq + 19]
                                elsif (abb_mask[sq] & BB_File[8]) != 0
                                    bbs[c][pc][sq] = abb_mask[sq + 17]
                                else
                                    bbs[c][pc][sq] = (abb_mask[sq + 17] | abb_mask[sq + 19])
                                end
                            #else
                                #bbs[c][pc][sq] = 0
                            end
                        end
                    end
                    if pc == King
                        if sq == 0
                            bbs[c][pc][sq] = (abb_mask[sq + 1] | abb_mask[sq + 9] | abb_mask[sq + 10])
                        elsif sq == 8
                            bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq + 9] | abb_mask[sq + 8])
                        elsif sq == 72
                            bbs[c][pc][sq] = (abb_mask[sq + 1] | abb_mask[sq - 9] | abb_mask[sq - 8])
                        elsif sq == 80
                            bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq - 9] | abb_mask[sq - 10])
                        elsif sq >= 1 and sq <= 7
                            bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq + 1] | abb_mask[sq + 8] | abb_mask[sq + 9] | abb_mask[sq + 10])
                        elsif sq >= 73 and sq <= 79
                            bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq + 1] | abb_mask[sq - 8] | abb_mask[sq - 9] | abb_mask[sq - 10])
                        elsif sq != 0 and sq != 72 and (abb_mask[sq] & BB_File[0]) != 0
                            bbs[c][pc][sq] = (abb_mask[sq + 1] | abb_mask[sq - 9] | abb_mask[sq - 8] | abb_mask[sq + 9] | abb_mask[sq + 10])
                        elsif sq != 8 and sq != 80 and (abb_mask[sq] & BB_File[8]) != 0
                            bbs[c][pc][sq] = (abb_mask[sq - 1] | abb_mask[sq - 9] | abb_mask[sq - 10] | abb_mask[sq + 8] | abb_mask[sq + 9]) 
                        else
                            bbs[c][pc][sq] = (abb_mask[sq - 8] | abb_mask[sq - 9] | abb_mask[sq - 10] | abb_mask[sq - 1] | abb_mask[sq + 1] | abb_mask[sq + 8] | abb_mask[sq + 9] | abb_mask[sq + 10] )
                        end
                    end
                    sq += 1
                end
                pc += 1
            end
            c += 1
        end
        return bbs
    end
    def abb_rank_mask_init()
        bbs = Array.new(Square_NB)
        f = File.new("abb_rank_mask_ex.txt", "r")
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            k = s[0].to_i
            v = s[1].to_i
            bbs[k - 1] = v
        end
        f.close
        return bbs
    end
    def abb_rank_attacks_init()
        d = Array.new(Square_NB)
        i = 0
        while i < Square_NB
            d[i] = {}
            i += 1
        end
        f = File.new("abb_rank_attacks.txt", "r")
        index = -1
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            i = s[0].to_i
            i -= 1
            if i != index
                index = i
            end
            k = s[1].to_i
            v = s[2].to_i
            x = d[i]
            x[k] = v
        end
        f.close
        return d
    end
    def abb_file_mask_init()
        bbs = Array.new(Square_NB)
        f = File.new("abb_file_mask_ex.txt", "r")
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            k = s[0].to_i
            v = s[1].to_i
            bbs[k - 1] = v
        end
        f.close
        return bbs
    end
    def abb_file_attacks_init()
        d = Array.new(Square_NB)
        i = 0
        while i < Square_NB
            d[i] = {}
            i += 1
        end
        f = File.new("abb_file_attacks.txt", "r")
        index = -1
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            i = s[0].to_i
            i -= 1
            if i != index
                index = i
            end
            k = s[1].to_i
            v = s[2].to_i
            x = d[i]
            x[k] = v
        end
        f.close
        return d
    end
    def abb_diag1_mask_init()
        bbs = Array.new(Square_NB)
        f = File.new("abb_diag1_mask_ex.txt", "r")
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            k = s[0].to_i
            v = s[1].to_i
            bbs[k - 1] = v
        end
        f.close
        return bbs
    end
    def abb_diag1_attacks_init()
        d = Array.new(Square_NB)
        i = 0
        while i < Square_NB
            d[i] = {}
            i += 1
        end
        f = File.new("abb_diag1_attacks.txt", "r")
        index = -1
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            i = s[0].to_i
            i -= 1
            if i != index
                index = i
            end
            k = s[1].to_i
            v = s[2].to_i
            x = d[i]
            x[k] = v
        end
        f.close
        return d
    end
    def abb_diag2_mask_init()
        bbs = Array.new(Square_NB)
        f = File.new("abb_diag2_mask_ex.txt", "r")
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            k = s[0].to_i
            v = s[1].to_i
            bbs[k - 1] = v
        end
        f.close
        return bbs
    end
    def abb_diag2_attacks_init()
        d = Array.new(Square_NB)
        i = 0
        while i < Square_NB
            d[i] = {}
            i += 1
        end
        f = File.new("abb_diag2_attacks.txt", "r")
        index = -1
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            i = s[0].to_i
            i -= 1
            if i != index
                index = i
            end
            k = s[1].to_i
            v = s[2].to_i
            x = d[i]
            x[k] = v
        end
        f.close
        return d
    end
    def abb_cross_mask_init()
        bbs = Array.new(Square_NB)
        f = File.new("abb_cross_mask_ex.txt", "r")
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            k = s[0].to_i
            v = s[1].to_i
            bbs[k - 1] = v
        end
        f.close
        return bbs
    end
    def abb_cross_attacks_init()
        d = Array.new(Square_NB)
        i = 0
        while i < Square_NB
            d[i] = {}
            i += 1
        end
        f = File.new("abb_cross_attacks.txt", "r")
        index = -1
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            i = s[0].to_i
            i -= 1
            if i != index
                index = i
            end
            k = s[1].to_i
            v = s[2].to_i
            x = d[i]
            x[k] = v
        end
        f.close
        return d
    end
    def abb_diagonal_mask_init()
        bbs = Array.new(Square_NB)
        f = File.new("abb_diagonal_mask_ex.txt", "r")
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            k = s[0].to_i
            v = s[1].to_i
            bbs[k - 1] = v
        end
        f.close
        return bbs
    end
    def abb_diagonal_attacks_init()
        d = Array.new(Square_NB)
        i = 0
        while i < Square_NB
            d[i] = {}
            i += 1
        end
        f = File.new("abb_diagonal_attacks.txt", "r")
        index = -1
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            i = s[0].to_i
            i -= 1
            if i != index
                index = i
            end
            k = s[1].to_i
            v = s[2].to_i
            x = d[i]
            x[k] = v
        end
        f.close
        return d
    end
    def abb_chk_table_init()
        f = File.new("abb_chk_table.txt", "r")
        bbs = Array.new(Color_NB){Array.new(5){Array.new(Square_NB)}}
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            c = s[0].to_i
            pc = s[1].to_i
            sq = s[2].to_i
            v = s[3].to_i
            bbs[c - 1][pc - 1][sq - 1] = v
        end
        return bbs
    end
    def abb_obstacles_init()
        f = File.new("abb_obstacles.txt", "r")
        bbs = Array.new(Square_NB){Array.new(Square_NB)}
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            ifrom = s[0].to_i
            ito = s[1].to_i
            v = s[2].to_i
            bbs[ifrom - 1][ito - 1] = v
        end
        return bbs
    end
    def abb_lance_mask_init()
        bbs = Array.new(Color_NB){Array.new(Square_NB)}
        f = File.new("abb_lance_mask_ex.txt", "r")
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            c = s[0].to_i
            k = s[1].to_i
            v = s[2].to_i
            bbs[c - 1][k - 1] = v
        end
        f.close
        return bbs
    end
    def abb_lance_attacks_init()
        d = Array.new(Color_NB){Array.new(Square_NB)}
        i = 0
        while i < Color_NB
            j = 0
            while j < Square_NB
                d[i][j] = {}
                j += 1
            end
            i += 1
        end
        f = File.new("abb_lance_attacks.txt", "r")
        index0 = -1
        index1 = -1
        while f.gets(chomp: true) != nil
            $_
            s = $_.split(',')
            i = s[0].to_i
            i -= 1
            if i != index0
                index0 = i
            end
            j = s[1].to_i
            if j != index1
                index1 = j
            end
            j -= 1
            k = s[2].to_i
            v = s[3].to_i
            x = d[i][j]
            d[i][j][k] = v
        end
        f.close
        return d
    end
end