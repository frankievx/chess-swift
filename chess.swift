class Board {
    class Piece {
        // defaults
        static let WHITE = "W"
        static let BLACK = "B"
        var name: String = "Piece"
        var location: Int = 0
        var color: String = WHITE
        // belong to what board
        // board must be initialized
        let board: Board        
        init(board: Board){
            self.board = board
        }
        func validMove(moveTo: Int, boardArr: [[Square]]) -> Bool {
            return false
        }
        // expects certain format
        // [a-hA-H][1-8]
        func validMove(moveTo: String, boardArr: [[Square]]) -> Bool{
            var charStart: Character = "A"
            let char: Character = Array(moveTo)[1]
            var val: Int = char.wholeNumberValue!*8
            if moveTo[moveTo.startIndex].isLowercase{
                charStart = "a"

            }
            val += Int(moveTo[moveTo.startIndex].asciiValue! - charStart.asciiValue!)
            return validMove(moveTo: val, boardArr: boardArr)

        }

        
    }

    class Pawn : Piece {
        override init(board: Board) { 
            super.init(board: board)
            name = "P"
        }
        override func validMove(moveTo: Int) -> Bool {
            // Pawns always have a direction. once they reach the end of the board
            // they are no longer pawns
            // moving up
            let forward: Int
            if(color == Piece.WHITE){
                forward = location + 8
            }
            else{
                forward = location - 8
            } 
            let leftDiag = forward-1
            let rightDiag = forward+1
        
            if(moveTo == forward && board.validLocation(location: forward) && !board.pieceAtLocation(location: forward)){
                return true
            }
            else if(moveTo == leftDiag && board.validLocation(location: leftDiag) && board.pieceAtLocation(location: leftDiag)){
                return true
            }
            else if(moveTo == rightDiag && board.validLocation(location: rightDiag) && board.pieceAtLocation(location: rightDiag)){
                    return true
            }
            else{
                return false
            } 

        }
    }

    class Knight: Piece {
        override init(board: Board) { 
            super.init(board: board)
            name = "K"
        }

    }
    class Bishop : Piece {
        override init(board: Board) { 
            super.init(board: board)
            name = "B"
        }
        override func validMove(moveTo: Int) -> Bool {
           //left upper diag
           var loc = location + 7
           while(board.validLocation(location: loc)){
                if(moveTo == loc){
                    return true
                }
                loc += 7
           }
           // right upper diag
           loc = location + 9
           while(board.validLocation(location: loc)){
                if(moveTo == loc){
                    return true
                }
                loc += 9
           }
           // lower left diag
           loc = location - 9
           while(board.validLocation(location: loc)){
                if(moveTo == loc){
                    return true
                }
                loc -= 9
           }
           // lower right diag
           loc = location - 7
           while(board.validLocation(location: loc)){
                if(moveTo == loc){
                    return true
                }
                loc -= 7
           }
           return false 
        }
    }
    class Rook : Piece {
        override init(board: Board) { 
            super.init(board: board)
            name = "R"
        }

        override func validMove(moveTo: Int) -> Bool {
            if(!board.validLocation(location: moveTo)){
                return false
            }
            // either vertically above or below``
            if(moveTo % 8 == location % 8){
                // check if something is in the way
                
                return true
            }
            if(moveTo / 8 == location / 8){

            }
        }

    }

    class Queen : Piece {
        override init(board: Board) { 
            super.init(board: board)
            name = "Q"
        }


    }


    class King : Piece {
        override init(board: Board) { 
            super.init(board: board)
            name = "K"
        }


    }
    class Square {
        var location: Int = 0
        var piece: Piece? = nil 
    }
    
    var arr = [[Square]]() 
    // might want to put this in the initializaiton of square
    func generateSquareForLocation(location: Int) -> Square{
       var sq: Square = Square()
       sq.location = location
       if(location < 16 && location > 7){
            sq.piece = Pawn(board: self)
       } 
       if(location < 56 && location >= 48){
            sq.piece = Pawn(board: self)
            sq.piece!.color = Piece.BLACK 
       }
       if(location >= 56 || location < 8){
            let val = location % 8
            let white: Bool = if(location < 8) { true } else { false}
            switch(val){
                case 0, 7:
                    sq.piece = Rook(board: self)
                case 1, 6:
                    sq.piece = Knight(board: self)
                case 2, 5:
                    sq.piece = Bishop(board: self)
                case 3:
                    sq.piece = Queen(board: self)
                default:
                    sq.piece = King(board: self)
            }
            if(!white){
               sq.piece!.color = Piece.BLACK 
            }
       }
       return sq
    }

    func validLocation(location: Int) -> Bool {
        if location < 0 || location > 63 { 
            return false
        }
        return true
    }
    // assume valid index
    func pieceAtLocation(location: Int) -> Bool {
        return arr[location/8][location%8].piece != nil
    }
    // for debugging purposes
    func print(){
        var str = ""
        var inBetweenLine = ""
        for i in 0...7 {
            inBetweenLine += "----"
        }
        inBetweenLine += "-"
        str += inBetweenLine + "\n"
        for i in 0...arr.count-1{
            for j in 0...arr[i].count-1{
                if arr[i][j].piece == nil{
                    str += "|   "
                }
                else{
                    str += "| " + arr[i][j].piece!.name + " "
                }
            }
            str += "|\n"
            str += inBetweenLine + "\n"
        }
        Swift.print(str)
    }
    init(){
        for i in 0...7{
            arr.append([])
            for j: Int in 0...7{
                arr[i].append(generateSquareForLocation(location: i*8 + j))
            }

        }

    }

}

var b = Board()
b.print()