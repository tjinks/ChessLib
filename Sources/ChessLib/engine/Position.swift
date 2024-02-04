//
//  File.swift
//
//
//  Created by Tony on 24/01/2024.
//

import Foundation

let whiteKingside: Int8 = 1
let whiteQueenside: Int8 = 2
let blackKingside: Int8 = 4
let blackQueenside: Int8 = 8

let a1 = 0
let c1 = 2
let d1 = 3
let e1 = 4
let f1 = 5
let g1 = 6
let h1 = 7
let a8 = a1 + 56
let c8 = c1 + 56
let d8 = d1 + 56
let e8 = e1 + 56
let f8 = f1 + 56
let g8 = g1 + 56
let h8 = h1 + 56

struct Position: Equatable, Hashable {
    
    let board: [Piece]
    let playerToMove: Player	
    let castlingRights: Int8
    let epSquare: Int?
    let kingSquare: [Int]
    
    private init(board: [Piece], playerToMove: Player, castlingRights: Int8, epSquare: Int?, kingSquare: [Int]) {
        self.board = board
        self.playerToMove = playerToMove
        self.castlingRights = castlingRights
        self.epSquare = epSquare
        self.kingSquare = kingSquare
    }
    
    /*
    init(currentPosition: Position, move: Move) {
        var board = currentPosition.board
        var epSquare: Int? = nil
        var kingSquare = currentPosition.kingSquare
        let playerToMove = currentPosition.playerToMove
        switch move {
        case .normal(let from, let to):
            board[to] = board[from]
            board[from] = .none
            if board[to] == Piece(.white, .pawn) && to - from == 16 {
                epSquare = to - 8
            }
            
            if board[to] == Piece(.black, .pawn) && from - to == 16 {
                epSquare = to + 8
            }
            
            if board[to].owner == playerToMove {
                kingSquare[playerToMove.index] = to
            }
        case .epCapture(let from):
            board[currentPosition.epSquare!] = board[from]
            board[from] = .none
        case .promotion(let from, let to, let promoteTo):
            board[to] = promoteTo
            board[from] = .none
        case .castleK:
            if playerToMove == .white {
                board[Position.e1] = .none
                board[Position.f1] = Piece(.white, .rook)
                board[Position.g1] = Piece(.white, .king)
                board[Position.h1] = .none
                kingSquare[playerToMove.index] = Position.g1
            } else {
                board[Position.e8] = .none
                board[Position.f8] = Piece(.black, .rook)
                board[Position.g8] = Piece(.black, .king)
                board[Position.h8] = .none
                kingSquare[playerToMove.index] = Position.g8
            }
        case .castleQ:
            if playerToMove == .white {
                board[Position.e1] = .none
                board[Position.d1] = Piece(.white, .rook)
                board[Position.c1] = Piece(.white, .king)
                board[Position.a1] = .none
                kingSquare[playerToMove.index] = Position.c1
            } else {
                board[Position.e8] = .none
                board[Position.d8] = Piece(.black, .rook)
                board[Position.c8] = Piece(.black, .king)
                board[Position.a8] = .none
                kingSquare[playerToMove.index] = Position.c8
            }
        }
        
        self.playerToMove = playerToMove.other
        self.epSquare = epSquare
        self.castlingRights = getNewCastlingRights()
        self.kingSquare = kingSquare
        self.board = board
        
        func getNewCastlingRights() -> Int8 {
            let castlingRights = currentPosition.castlingRights
            if castlingRights == 0 {
                return 0
            }
            
            var rightsToRemove: Int8 = 0
            switch move {
            case .castleK, .castleQ:
                switch playerToMove {
                case .white: rightsToRemove = whiteCanCastleK | whiteCanCastleQ
                case .black: rightsToRemove = blackCanCastleK | blackCanCastleQ
                }
            case .normal(let from, _):
                switch from {
                case Position.a1: rightsToRemove = whiteCanCastleQ
                case Position.e1: rightsToRemove = whiteCanCastleK | whiteCanCastleQ
                case Position.h1: rightsToRemove = whiteCanCastleK
                case Position.a8: rightsToRemove = blackCanCastleQ
                case Position.e8: rightsToRemove = blackCanCastleK | blackCanCastleQ
                case Position.h8: rightsToRemove = blackCanCastleK
                default: break
                }
            default: break
            }
            
            return castlingRights & ~rightsToRemove			
        }
    }
     */
    
    init(positionDto: Dto.Position) throws {
        var board: [Piece] = []
        var kingSquare: [Int?] = [nil, nil]
        for squareNumber in 0...63 {
            let piece = Piece(positionDto.getPiece(at: try! Dto.Square(number: squareNumber)))
            if piece.type == .king {
                let index = piece.owner!.index
                if kingSquare[index] != nil {
                    throw ChessError.duplicateKing
                }
                
                kingSquare[index] = squareNumber
            }
            
            board.append(piece)
        }
        
        if (kingSquare[0] == nil || kingSquare[1] == nil) {
            throw ChessError.missingKing
        }
        
        self.kingSquare = [kingSquare[0]!, kingSquare[1]!]
        
        self.board = board
        
        switch positionDto.playerToMove {
        case .white:
            playerToMove = .white
        case .black:
            playerToMove = .black
        }
        
        var castlingRights: Int8 = 0
        if positionDto.castlingRights.contains(.whiteKingside) {
            castlingRights |= whiteKingside
        }
        
        if positionDto.castlingRights.contains(.whiteQueenside) {
            castlingRights |= whiteQueenside
        }
        
        if positionDto.castlingRights.contains(.blackKingside) {
            castlingRights |= blackKingside
        }
        
        if positionDto.castlingRights.contains(.blackQueenside) {
            castlingRights |= blackQueenside
        }
        
        self.castlingRights = castlingRights
        
        if let eps = positionDto.epSquare {
            epSquare = eps.file + 8 * eps.rank
        } else {
            epSquare = nil
        }
    }
    
    func makeMove(_ move: Move) -> Position {
        var board = self.board
        var kingSquare = self.kingSquare
        let piece = board[move.from]
        if let promoteTo = move.promoteTo {
            board[move.to] = promoteTo
        } else {
            board[move.to] = piece
        }
        
        board[move.from] = Piece.none
        if move.isEpCapture {
            board[move.to1!] = Piece.none
        } else if move.isCastles {
            board[move.to1!] = board[move.from1!]
            board[move.from1!] = Piece.none
        }
        
        if piece == Piece(.white, .king) {
            kingSquare[Player.white.index] = move.to
        } else if piece == Piece(.black, .king) {
            kingSquare[Player.black.index] = move.to
        }
        
        var castlingRights = self.castlingRights
        if castlingRights != 0 {
            var rightsToRemove: Int8 = 0
            switch move.from {
            case e1: rightsToRemove = whiteKingside | whiteQueenside
            case e8: rightsToRemove = blackKingside | blackQueenside
            case a1: rightsToRemove = whiteQueenside
            case a8: rightsToRemove = blackQueenside
            case h1: rightsToRemove = whiteKingside
            case h8: rightsToRemove = blackKingside
            default: break
            }
            
            castlingRights &= ~rightsToRemove
        }
        
        var epSquare: Int? = nil
        if move.isPawnMove {
            switch move.to - move.from {
            case 16: epSquare = move.from + 8
            case -16: epSquare = move.from - 8
            default: break
            }
        }
        
        return Position(
            board: board,
            playerToMove: playerToMove.other,
            castlingRights: castlingRights,
            epSquare: epSquare,
            kingSquare: kingSquare)
    }
}
