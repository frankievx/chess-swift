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
        init(board: Board, color: String){
            self.board = board 
            self.color = color
        }
        func isBlack() -> Bool {
            if(color == Piece.BLACK){ 
                return true
            }
            return false
        }
        func isWhite() -> Bool {
            return !isBlack()
        }
        // does not treat king
        func validMove(moveTo: Int) -> Bool {
            if(!board.validLocation(location: moveTo)){ return false }            
            if(moveTo == location){ return false }
            if(!board.pieceAtLocation(location: moveTo)){
                if(board.getPieceAt(location: moveTo)!.color == self.color){
                    return false
                }
            }
            return true
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
        var hasMoved = false
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
        
            var oppositeColor = Piece.WHITE
            if(self.color == Piece.WHITE){
                oppositeColor = Piece.BLACK
            }
            if(moveTo == forward && board.validLocation(location: forward) && !board.pieceAtLocation(location: forward)){
                return true
            }
            else if(moveTo == leftDiag && board.validLocation(location: leftDiag) && board.pieceAtLocation(location: leftDiag)){
                return board.getPieceAt(location: leftDiag)!.color == oppositeColor 
            }
            else if(moveTo == rightDiag && board.validLocation(location: rightDiag) && board.pieceAtLocation(location: rightDiag)){
                    return board.getPieceAt(location: rightDiag)!.color == oppositeColor 
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
        override func validMove(moveTo: Int) -> Bool {
            if(!super.validMove(moveTo: moveTo)){ return false }
            let adjustments = [16 - 1, 16 + 1, 8 + 2, 8 - 2]
            for i in 0..<adjustments.count{
                if(location + adjustments[i] == moveTo){
                    return true
                }
                else if(location - adjustments[i] == moveTo){
                    return true
                }
            }
            return false
        }

    }
    class Bishop : Piece {
        override init(board: Board) { 
            super.init(board: board)
            name = "B"
        }
        override func validMove(moveTo: Int) -> Bool {
            if(!super.validMove(moveTo: moveTo)){ return false }
            var tmp = moveTo - location
            // check which diagonal the location is on
            // if it is not on the diag we cannot move there
            // afterwards loop and check spaces in between
            var stepSize = 0
            if(tmp > 0){
                if(tmp % 7 == 0){
                    stepSize = -7
                }
                else if(tmp % 9 == 0){
                    stepSize = -9
                }
                else{
                    return false
                }
            }
            else{
                tmp *= -1
                if(tmp % 7 == 0){
                    stepSize = 7
                }
                else if(tmp % 9 == 0){
                    stepSize = 9
                }
                else{
                    return false
                }
            }
            var loc = location + stepSize
            while(board.validLocation(location: loc)){
                if(loc == moveTo){
                    return true
                }
                else{
                    if(board.pieceAtLocation(location: loc)){
                        return false
                    }
                }
                loc -= stepSize
            } 
        // control should not reach here
        return false
        }
    
    }
    class Rook : Piece {
        override init(board: Board) { 
            super.init(board: board)
            name = "R"
        }

        override func validMove(moveTo: Int) -> Bool {
            if(!super.validMove(moveTo: moveTo)){ return false }
            
            var stepSize: Int
            // either vertically above or below``
            if(moveTo % 8 == location % 8){
                // check if something is in the way
                stepSize = 1
            }


            // horizontal
            else if(moveTo / 8 == location / 8){
                stepSize = 8
            }
            else{
                return false
            }

            if(moveTo < location){
                stepSize *= -1
            }   


            var loc = location + stepSize
            while(board.validLocation(location: loc)){
                if(moveTo == loc){
                    return true
                }
                if(board.pieceAtLocation(location: loc)){
                    return false
                }
            }
            return true
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


        override func validMove(moveTo: Int) -> Bool {
            if(!super.validMove(moveTo: moveTo)){ return false }
            if(moveTo == location - 1){
                return true
            }
            else if(moveTo == location + 1){
                return true
            }
            else if(moveTo == location + 7){
                return true
            }
            else if(moveTo == location + 9){
                return true
            }
            else if(moveTo == location - 7){
                return true
            }
            else if(moveTo == location - 9){
                return true
            }
            return false
        }
    }
    class Square {
        var location: Int = 0
        var piece: Piece? = nil 
        init(loc: Int){
            location = loc
        }
        init(){

        }
    }
    
    var arr = [[Square]]() 

    init(){
        let str = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
        fenReader(input: str)
    }
    init(input: String){
        fenReader(input: input)
    }

    // assume correct format
    func move(from: String, to: String) -> Bool {
        let char: Character = "a"
        var firstChar = from[from.index(from.startIndex, offsetBy: 0)]
        var secondChar = from[from.index(from.startIndex, offsetBy: 1)]
        
        let start = Int(String(secondChar))!*8 + Int(firstChar.asciiValue! - char.asciiValue!) 

        firstChar = to[to.index(to.startIndex, offsetBy: 0)]
        secondChar = to[to.index(to.startIndex, offsetBy: 1)]

        let end = Int(String(secondChar))!*8 + Int(firstChar.asciiValue! - char.asciiValue!)      
        return self.move(from: start, to: end)

    }

    func move(from: Int, to: Int) -> Bool {
        if(!(self.validLocation(location: from) && self.validLocation(location: to))){
            return false
        }      

        if(!self.pieceAtLocation(location: from)){
            return false
        }

        if(!arr[from/8][from%8].piece!.validMove(moveTo: to)){
            return false
        }
        // MARY should i announce a piece taken?
        if(self.pieceAtLocation(location: to)){

        }
        arr[to/8][to%8].piece = arr[from/8][from%8].piece
        arr[from/8][from%8].piece = nil
        return true 

    }

// rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    func fenReader(input: String){
        var state = input.split(separator: " ")
        
        var rows = state[0].split(separator: "/")
        for i in 0...7{
            arr.append([])
            var col: Int = 0
            for j in 0...rows[i].count-1{
                let char = rows[i][rows[i].index(rows[i].startIndex, offsetBy: j)]
                var emptySpaces = Int(String(char))

                if(emptySpaces != nil){
                    for k in 1...emptySpaces!{
                        arr[i].append(Board.Square(loc: i*8 + col))
                        col += 1
                    }
                    continue
                }
                let upperChar = char.uppercased()
                var color = "W"
                if(char.isLowercase){
                    color = "B"
                }
                var sq = Board.Square(loc: i*8 + col)
                col += 1
                switch(upperChar){
                    case "P":
                        sq.piece = Pawn(board: b)
                    case "N":
                        sq.piece = Knight(board: b)
                    case "B":
                        sq.piece = Bishop(board: b)
                    case "Q":
                        sq.piece = Queen(board: b)
                    case "K":
                        sq.piece = King(board: b)
                    case "R":
                        sq.piece = Rook(board: b)
                    default:
                        Swift.print("ERROR")
                }
                sq.piece!.color = color
                arr[i].append(sq)



                    

                    
            }
        }
    }






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
    func getPieceAt(location: Int) -> Piece? {
        if(!self.validLocation(location: location)){
            return nil
        }
        return arr[location/8][location % 8].piece!
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
        for i in (0...arr.count-1).reversed(){
            for j in 0...arr[i].count-1{
                if arr[i][j].piece == nil{
                    str += "|   "
                }
                else{
                    let piece = arr[i][j].piece!
                    if(piece.color == Piece.BLACK){
                        str += "| " + arr[i][j].piece!.name + " "
                    }
                    else{
                        str += "| " + "\u{001B}[0;31m" + piece.name + " " + "\u{001B}[0;30m"
                    }
                }
            }
            str += "|\n"
            str += inBetweenLine + "\n"
        }
        Swift.print(str)
    }


}




let str = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
var b = Board()
b.print()