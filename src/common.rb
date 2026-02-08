require './piece'

Color_NB = 2
Piece_NB = 16
Square_NB = 81
Moves_Max = 700
Chk_Table_NB = 5
File_NB = 9
Rank_NB = 9
Piece_Can_Drop_NB = 7
Ply_Max = 1024
Value_Max = 32768
Value_Min = -Value_Max
Value_Draw = 0
#Bit_Diff = 128 - Square_NB
Hand_Pawn = 1
Hand_Lance = 1 << 5
Hand_Knight = 1 << 8
Hand_Silver = 1 << 11
Hand_Gold = 1 << 14
Hand_Bishop = 1 << 17
Hand_Rook = 1 << 19
Flip_Color = [1, 0]
Hand_Hash = [nil, Hand_Pawn, Hand_Lance, Hand_Knight, Hand_Silver, Hand_Gold, Hand_Bishop, Hand_Rook]
Hand_Rev_Bit = [nil, 0, 5, 8, 11, 14, 17, 19]
Hand_Mask = [nil, 31, 224, 1792, 14336, 114688, 393216, 1572864]
Square_Edge = [true,  true,  true,  true,  true,  true,  true,  true, true,
               true, false, false, false, false, false, false, false, true,
               true, false, false, false, false, false, false, false, true,
               true, false, false, false, false, false, false, false, true,
               true, false, false, false, false, false, false, false, true,
               true, false, false, false, false, false, false, false, true,
               true, false, false, false, false, false, false, false, true,
               true, false, false, false, false, false, false, false, true,
               true,  true,  true,  true,  true,  true,  true,  true, true]
Str_CSA = ["91", "81", "71", "61", "51", "41", "31", "21", "11",
           "92", "82", "72", "62", "52", "42", "32", "22", "12",
           "93", "83", "73", "63", "53", "43", "33", "23", "13",
           "94", "84", "74", "64", "54", "44", "34", "24", "14",
           "95", "85", "75", "65", "55", "45", "35", "25", "15",
           "96", "86", "76", "66", "56", "46", "36", "26", "16",
           "97", "87", "77", "67", "57", "47", "37", "27", "17",
           "98", "88", "78", "68", "58", "48", "38", "28", "18",
           "99", "89", "79", "69", "59", "49", "39", "29", "19",
           "00", "00", "00", "00", "00", "00", "00"]
Str_USI = ["9a", "8a", "7a", "6a", "5a", "4a", "3a", "2a", "1a",
           "9b", "8b", "7b", "6b", "5b", "4b", "3b", "2b", "1b",
           "9c", "8c", "7c", "6c", "5c", "4c", "3c", "2c", "1c",
           "9d", "8d", "7d", "6d", "5d", "4d", "3d", "2d", "1d",
           "9e", "8e", "7e", "6e", "5e", "4e", "3e", "2e", "1e",
           "9f", "8f", "7f", "6f", "5f", "4f", "3f", "2f", "1f",
           "9g", "8g", "7g", "6g", "5g", "4g", "3g", "2g", "1g",
           "9h", "8h", "7h", "6h", "5h", "4h", "3h", "2h", "1h",
           "9i", "8i", "7i", "6i", "5i", "4i", "3i", "2i", "1i"]
CSA_TO_SQ = {"91"=>0,  "81"=>1,  "71"=>2,  "61"=>3,  "51"=>4,  "41"=>5,  "31"=>6,  "21"=>7,  "11"=>8,
             "92"=>9,  "82"=>10, "72"=>11, "62"=>12, "52"=>13, "42"=>14, "32"=>15, "22"=>16, "12"=>17,
             "93"=>18, "83"=>19, "73"=>20, "63"=>21, "53"=>22, "43"=>23, "33"=>24, "23"=>25, "13"=>26,
             "94"=>27, "84"=>28, "74"=>29, "64"=>30, "54"=>31, "44"=>32, "34"=>33, "24"=>34, "14"=>35,
             "95"=>36, "85"=>37, "75"=>38, "65"=>39, "55"=>40, "45"=>41, "35"=>42, "25"=>43, "15"=>44,
             "96"=>45, "86"=>46, "76"=>47, "66"=>48, "56"=>49, "46"=>50, "36"=>51, "26"=>52, "16"=>53,
             "97"=>54, "87"=>55, "77"=>56, "67"=>57, "57"=>58, "47"=>59, "37"=>60, "27"=>61, "17"=>62,
             "98"=>63, "88"=>64, "78"=>65, "68"=>66, "58"=>67, "48"=>68, "38"=>69, "28"=>70, "18"=>71,
             "99"=>72, "89"=>73, "79"=>74, "69"=>75, "59"=>76, "49"=>77, "39"=>78, "29"=>79, "19"=>80,
             "00"=>81}
USI_TO_SQ = {"9a"=>1,  "8a"=>2,  "7a"=>3,  "6a"=>4,  "5a"=>5,  "4a"=>6,  "3a"=>7,  "2a"=>8,  "1a"=>9,
             "9b"=>10, "8b"=>11, "7b"=>12, "6b"=>13, "5b"=>14, "4b"=>15, "3b"=>16, "2b"=>17, "1b"=>18,
             "9c"=>19, "8c"=>20, "7c"=>21, "6c"=>22, "5c"=>23, "4c"=>24, "3c"=>25, "2c"=>26, "1c"=>27,
             "9d"=>28, "8d"=>29, "7d"=>30, "6d"=>31, "5d"=>32, "4d"=>33, "3d"=>34, "2d"=>35, "1d"=>36,
             "9e"=>37, "8e"=>38, "7e"=>39, "6e"=>40, "5e"=>41, "4e"=>42, "3e"=>43, "2e"=>44, "1e"=>45,
             "9f"=>46, "8f"=>47, "7f"=>48, "6f"=>49, "5f"=>50, "4f"=>51, "3f"=>52, "2f"=>53, "1f"=>54,
             "9g"=>55, "8g"=>56, "7g"=>57, "6g"=>58, "5g"=>59, "4g"=>60, "3g"=>61, "2g"=>62, "1g"=>63,
             "9h"=>64, "8h"=>65, "7h"=>66, "6h"=>67, "5h"=>68, "4h"=>69, "3h"=>70, "2h"=>71, "1h"=>72,
             "9i"=>73, "8i"=>74, "7i"=>75, "6i"=>76, "5i"=>77, "4i"=>78, "3i"=>79, "2i"=>80, "1i"=>81}
Str_Piece = ["None", "FU", "KY", "KE", "GI", "KI", "KA", "HI", "OU", "TO", "NY", "NK", "NG", "None", "UM", "RY"]
CSA_TO_PC = {"FU"=>Pawn, "KY"=>Lance, "KE"=>Knight, "GI"=>Silver, "KI"=>Gold, "KA"=>Bishop, "HI"=>Rook, "OU"=>King, "TO"=>Pro_Pawn, "NY"=>Pro_Lance, "NK"=>Pro_Knight, "NG"=>Pro_Silver, "UM"=>Horse, "RY"=>Dragon}
BB_Black_Position = 0x7FFFFFF
BB_White_Position = 0x7FFFFFF << 54
BB_Color_Position = [BB_Black_Position, BB_White_Position]
BB_Rev_Color_Position = [ BB_White_Position, BB_Black_Position]
BB_DMZ = 0x7FFFFFF << 27
BB_Full = (1 << 81) - 1
BB_File = [0x100804020100804020100, 
           (0x100804020100804020100 >> 1),
           (0x100804020100804020100 >> 2),
           (0x100804020100804020100 >> 3),
           (0x100804020100804020100 >> 4),
           (0x100804020100804020100 >> 5),
           (0x100804020100804020100 >> 6),
           (0x100804020100804020100 >> 7),
           (0x100804020100804020100 >> 8)]
BB_Rank = [((0x200-1) << 72),
           ((0x200-1) << 63),
           ((0x200-1) << 54),
           ((0x200-1) << 45),
           ((0x200-1) << 36),
           ((0x200-1) << 27),
           ((0x200-1) << 18),
           ((0x200-1) << 9),
           (0x200-1)]
BB_Knight_Must_Promote = [((BB_Rank[0]|BB_Rank[1])), ((BB_Rank[7] | BB_Rank[8]))]
BB_B_Lance_Mask = [0, BB_Rank[0], (BB_Rank[0]|BB_Rank[1]), (BB_Rank[0]|BB_Rank[1]|BB_Rank[2]), (BB_Rank[0]|BB_Rank[1]|BB_Rank[2]|BB_Rank[3]), (BB_Rank[0]|BB_Rank[1]|BB_Rank[2]|BB_Rank[3]|BB_Rank[4]), (BB_Rank[0]|BB_Rank[1]|BB_Rank[2]|BB_Rank[3]|BB_Rank[4]|BB_Rank[5]), (BB_Rank[0]|BB_Rank[1]|BB_Rank[2]|BB_Rank[3]|BB_Rank[4]|BB_Rank[5]|BB_Rank[6]), (BB_Rank[0]|BB_Rank[1]|BB_Rank[2]|BB_Rank[3]|BB_Rank[4]|BB_Rank[5]|BB_Rank[6]|BB_Rank[7])]
BB_W_Lance_Mask = [(BB_Rank[1]|BB_Rank[2]|BB_Rank[3]|BB_Rank[4]|BB_Rank[5]|BB_Rank[6]|BB_Rank[7]|BB_Rank[8]), (BB_Rank[2]|BB_Rank[3]|BB_Rank[4]|BB_Rank[5]|BB_Rank[6]|BB_Rank[7]|BB_Rank[8]), (BB_Rank[3]|BB_Rank[4]|BB_Rank[5]|BB_Rank[6]|BB_Rank[7]|BB_Rank[8]), (BB_Rank[4]|BB_Rank[5]|BB_Rank[6]|BB_Rank[7]|BB_Rank[8]), (BB_Rank[5]|BB_Rank[6]|BB_Rank[7]|BB_Rank[8]), (BB_Rank[6]|BB_Rank[7]|BB_Rank[8]), (BB_Rank[7]|BB_Rank[8]), (BB_Rank[8]), 0]
BB_Lance_Mask = [BB_B_Lance_Mask, BB_W_Lance_Mask]
RandM = 397
RandN = 624
MaskU = 0x80000000
MaskL = 0x7fffffff
Mask32 = 0xffffffff
Pawn_Lance_Can_Drop = [0x00000000000000ffffffffffffffffff, 0x000000000001fffffffffffffffffe00]
Knight_Can_Drop = [0x00000000000000007fffffffffffffff, 0x000000000001fffffffffffffffc0000]
Others_Can_Drop = 0x000000000001ffffffffffffffffffff
Delta_Table = [-9, 9]
Sign_Table = [-1, 1]
Set_Long_Attack_Pieces = [Lance, Bishop, Rook, Horse, Dragon, -Lance, -Bishop, -Rook, -Horse, -Dragon]
Set_Piece_Can_Promote0 = [Pawn, Lance, Knight]
Set_Piece_Can_Promote1 = [Silver, Bishop, Rook]
BB_Pawn_Mask = [(BB_Color_Position[0] | BB_Rank[4] | BB_Rank[5]), (BB_Color_Position[1] | BB_Rank[3] | BB_Rank[4])]
Piece_Table = [{ 10=>[Silver, Gold, Bishop, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                  9=>[Pawn, Lance, Silver, Gold, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                  8=>[Silver, Gold, Bishop, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                  1=>[Gold, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                 -1=>[Gold, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                 -8=>[Silver, Bishop, Horse, Dragon],
                 -9=>[Gold, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                -10=>[Silver, Bishop, Horse, Dragon],
                }, 
               { 10=>[Silver, Bishop, Horse, Dragon],
                  9=>[Gold, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                  8=>[Silver, Bishop, Horse, Dragon],
                  1=>[Gold, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                 -1=>[Gold, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                -10=>[Silver, Gold, Bishop, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                 -9=>[Pawn, Lance, Silver, Gold, Rook, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon],
                 -8=>[Silver, Gold, Bishop, Pro_Pawn, Pro_Lance, Pro_Knight, Pro_Silver, Horse, Dragon]}
               ]
Short_Pieces = [Pawn, Lance]
Long_Pieces = [Bishop, Rook]
Long_Pieces2 = [Bishop, Rook, Lance]
Piece_RD = [Rook, Dragon]
Piece_BH = [Bishop, Horse]
Piece_RDBHL = [Rook, Dragon, Bishop, Horse, Lance]
Usi_Drop_Piece = {"P"=>Pawn, "L"=>Lance, "N"=>Knight, "S"=>Silver, "G"=>Gold, "B"=>Bishop, "R"=>Rook}
