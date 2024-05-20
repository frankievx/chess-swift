class Piece {
    var name: String = "Piece"
    var location: Int = 0
    var color: String = "W"
    func validMove(moveTo: Int) -> Bool {
        return false
    }
    // expects certain format
    // [a-hA-H][1-8]
    func validMove(moveTo: String) -> Bool{
        var charStart: Character = "A"
        let char: Character = Array(moveTo)[1]
        var val: Int = char.wholeNumberValue!*8
        if moveTo[moveTo.startIndex].isLowercase{
            charStart = "a"

        }
        val += Int(moveTo[moveTo.startIndex].asciiValue! - charStart.asciiValue!)
        return validMove(moveTo: val)

    }
}

class Pawn : Piece {

}

class Knight: Piece {

}
class Bishop : Piece {

}

class Rook : Piece {

}

class Queen : Piece {

}


class King : Piece {

}
class Square {
   var location: Int = 0
   var piece: Piece? = nil 
}
class Board {
    
    var arr = [[Square]]() 
    // might want to put this in the initializaiton of square
    func generateSquareForLocation(location: Int){
       var sq: Square = Square()
       sq.location = location
       if(location < 16 && location > 7){
            sq.piece = Pawn()
       } 
       if(location < 56 && location >= 48){
            sq.piece = Pawn()
            sq.piece!.color = "B"
       }
       if(location >= 56 || location < 8){
            var val = location % 8
            let white: Bool = if(location < 8) { true } else { false}
            switch(val){
                case 0, 7:
                    sq.piece = Rook()
                case 1, 6:
                    sq.piece = Knight()
                case 2, 5:
                    sq.piece = Bishop()
                case 3:
                    sq.piece = Queen()
                default:
                    sq.piece = King()
            }
            if(!white){
               sq.piece!.color = "B" 
            }
       }
    }
    init(){
        for i in 0...7{
            arr.append([])
            for j: Int in 0...7{
                var sq: Square = Square()
                sq.location = i*8 + j
                arr[i].append(sq)
            }

        }

    }

}

let pawn1 = Piece()
print(pawn1.validMove(moveTo: "A4"))