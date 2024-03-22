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
let b1 = 1
let c1 = 2
let d1 = 3
let e1 = 4
let f1 = 5
let g1 = 6
let h1 = 7

let a2 = 8
let b2 = 9
let c2 = 10
let d2 = 11
let e2 = 12
let f2 = 13
let g2 = 14
let h2 = 15

let a3 = 16
let b3 = 17
let c3 = 18
let d3 = 19
let e3 = 20
let f3 = 21
let g3 = 22
let h3 = 23

let a4 = 24
let b4 = 25
let c4 = 26
let d4 = 27
let e4 = 28
let f4 = 29
let g4 = 30
let h4 = 31

let a5 = 32
let b5 = 33
let c5 = 34
let d5 = 35
let e5 = 36
let f5 = 37
let g5 = 38
let h5 = 39

let a6 = 40
let b6 = 41
let c6 = 42
let d6 = 43
let e6 = 44
let f6 = 45
let g6 = 46
let h6 = 47

let a7 = 48
let b7 = 49
let c7 = 50
let d7 = 51
let e7 = 52
let f7 = 53
let g7 = 54
let h7 = 55

let a8 = 56
let b8 = 57
let c8 = 58
let d8 = 59
let e8 = 60
let f8 = 61
let g8 = 62
let h8 = 63

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
    
    init() {
        let dto = try! Notation.parseFen(fen: Notation.initialPosition)
        try! self.init(dto: dto)
    }
    
    init(fen: String) throws {
        let dto = try! Notation.parseFen(fen: fen)
        try! self.init(dto: dto)
    }
    
    init(dto: GameStateDto) throws {
        self.board = dto.board
        
        var kingSquare: [Int?] = [nil, nil]
        try Square.forAll {
            let piece = dto.board[$0.number]
            if piece.type == .king {
                let index = piece.owner!.index
                if kingSquare[index] != nil {
                    throw ChessError.duplicateKing
                }
                
                kingSquare[index] = $0.number
            }
            
            return true
        }
        
        if (kingSquare[0] == nil || kingSquare[1] == nil) {
            throw ChessError.missingKing
        }
        
        self.kingSquare = [kingSquare[0]!, kingSquare[1]!]
        
        playerToMove = dto.playerToMove
        
        var castlingRights: Int8 = 0
        if dto.whiteCanCastleShort {
            castlingRights |= whiteKingside
        }
        
        if dto.whiteCanCastleLong {
            castlingRights |= whiteQueenside
        }
        
        if dto.blackCanCastleShort {
            castlingRights |= blackKingside
        }
        
        if dto.blackCanCastleLong {
            castlingRights |= blackQueenside
        }
        
        self.castlingRights = castlingRights
        
        if let eps = dto.epSquare {
            epSquare = eps.number
        } else {
            epSquare = nil
        }
    }
    
    func makeMove(_ move: Move) -> Position {
        var board = self.board
        var kingSquare = self.kingSquare
        
        board[move.to] = move.piece
        board[move.from] = Piece.none
        if move.isEpCapture {
            board[move.to1!] = Piece.none
        } else if move.isCastles {
            board[move.to1!] = board[move.from1!]
            board[move.from1!] = Piece.none
        }
        
        if move.piece == Piece(.white, .king) {
            kingSquare[Player.white.index] = move.to
        } else if move.piece == Piece(.black, .king) {
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
