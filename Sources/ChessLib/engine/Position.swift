//
//  File.swift
//
//
//  Created by Tony on 24/01/2024.
//

import Foundation

let whiteCanCastleK: Int8 = 1
let whiteCanCastleQ: Int8 = 2
let blackCanCastleK: Int8 = 4
let blackCanCastleQ: Int8 = 8

struct Position: Equatable, Hashable {
    private static let a1 = 0
    private static let c1 = 2
    private static let d1 = 3
    private static let e1 = 4
    private static let f1 = 5
    private static let g1 = 6
    private static let h1 = 7
    private static let a8 = a1 + 56
    private static let c8 = c1 + 56
    private static let d8 = d1 + 56
    private static let e8 = e1 + 56
    private static let f8 = f1 + 56
    private static let g8 = g1 + 56
    private static let h8 = h1 + 56
    
    
    let board: [Piece]
    let playerToMove: Player
    let castlingRights: Int8
    let epSquare: Int?
    
    init(currentPosition: Position, move: Move) {
        var board = currentPosition.board
        var epSquare: Int? = nil
        switch move {
        case .normal(let from, let to):
            board[to] = board[from]
            board[from] = .none
            if board[to] == .whitePawn && to - from == 16 {
                epSquare = to - 8
            }
            
            if board[to] == .blackPawn && from - to == 16 {
                epSquare = to + 8
            }
        case .epCapture(let from):
            board[currentPosition.epSquare!] = board[from]
            board[from] = .none
        case .promotion(let from, let to, let promoteTo):
            board[to] = promoteTo
            board[from] = .none
        case .castleK:
            if currentPosition.playerToMove == .white {
                board[Position.e1] = .none
                board[Position.f1] = .whiteRook
                board[Position.g1] = .whiteKing
                board[Position.h1] = .none
            } else {
                board[Position.e8] = .none
                board[Position.f8] = .blackRook
                board[Position.g8] = .blackKing
                board[Position.h8] = .none
            }
        case .castleQ:
            if currentPosition.playerToMove == .white {
                board[Position.e1] = .none
                board[Position.d1] = .whiteRook
                board[Position.c1] = .whiteKing
                board[Position.a1] = .none
            } else {
                board[Position.e8] = .none
                board[Position.d8] = .blackRook
                board[Position.c8] = .blackKing
                board[Position.a8] = .none
            }
        }
        
        self.playerToMove = currentPosition.playerToMove.other
        self.epSquare = epSquare
        self.castlingRights = getNewCastlingRights()
        self.board = board
        
        func getNewCastlingRights() -> Int8 {
            let castlingRights = currentPosition.castlingRights
            if castlingRights == 0 {
                return 0
            }
            
            let player = currentPosition.playerToMove
            var rightsToRemove: Int8 = 0
            switch move {
            case .castleK, .castleQ:
                switch player {
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
    
    init(positionDto: PositionDto) {
        var board: [Piece] = []
        for square in Square.getAll() {
            if let p = positionDto.pieces[square] {
                board.append(p)
            } else {
                board.append(.none)
            }
        }
        
        self.board = board
        
        playerToMove = positionDto.activePlayer
        
        var castlingRights: Int8 = 0
        if positionDto.castlingRights.contains(.whiteK) {
            castlingRights |= whiteCanCastleK
        }
        
        if positionDto.castlingRights.contains(.whiteQ) {
            castlingRights |= whiteCanCastleQ
        }
        
        if positionDto.castlingRights.contains(.blackK) {
            castlingRights |= blackCanCastleK
        }
        
        if positionDto.castlingRights.contains(.blackQ) {
            castlingRights |= blackCanCastleQ
        }
        
        self.castlingRights = castlingRights
        
        if let eps = positionDto.epSquare {
            epSquare = eps.file + 8 * eps.rank
        } else {
            epSquare = nil
        }
    }
}
