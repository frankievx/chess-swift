class Piece {
    var name: String
}

class Square {
   var location: String 
   var piece: Piece
}
class Board {
    var arr = [[Square]] 
}
