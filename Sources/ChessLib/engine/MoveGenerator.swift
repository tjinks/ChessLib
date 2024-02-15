//
//  File.swift
//  
//
//  Created by Tony on 09/02/2024.
//

import Foundation


struct MoveGenerator {
    private let position: Position
    private let moveList: MoveList
    private let player: Player
    private let opponent: Player
    
    static func run(position: Position, player: Player) -> MoveList {
        MoveGenerator(position: position, player: player).moveList
    }
    
    private init(position: Position, player: Player) {
        self.position = position
        self.player = player
        opponent = player.other
        moveList = MoveList()
        
        for from in 0..<64 {
            if (position.board[from].owner == player) {
                addMoves(from: from)
            }
        }
        
        if position.castlingRights != 0 {
            addCastlingMoves()
        }
    }
    
    private func addMoves(from: Int) {
        switch (position.board[from].type) {
        case .king:
            addKingMoves(from: from)
        case .queen:
            addQueenMoves(from: from)
        case .rook:
            addRookMoves(from: from)
        case .bishop:
            addBishopMoves(from: from)
        case .knight:
            addKnightMoves(from: from)
        case .pawn:
            addPawnMoves(from: from)
            addPawnCaptures(from: from)
        case .none:
            break
        }
    }
    
    private func addKingMoves(from: Int) {
        SquareInfo[from].kingMoves.foreach() {
            addIfPossible(from: from, to: $0)
            return true
        }
    }
    
    private func addKnightMoves(from: Int) {
        SquareInfo[from].knightMoves.foreach() {
            addIfPossible(from: from, to: $0)
            return true
        }
    }
    
    private func addBishopMoves(from: Int) {
        let squareInfo = SquareInfo[from]

        squareInfo.ne.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        squareInfo.nw.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.se.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.sw.foreach() {
            return addIfPossible(from: from, to: $0)
        }
    }
    
    private func addRookMoves(from: Int) {
        let squareInfo = SquareInfo[from]

        squareInfo.north.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.south.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.east.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.west.foreach() {
            return addIfPossible(from: from, to: $0)
        }
    }
    
    private func addQueenMoves(from: Int) {
        addRookMoves(from: from)
        addBishopMoves(from: from)
    }
    
    private func addPawnMoves(from: Int) {
        let squareInfo = SquareInfo[from]
        squareInfo.pawnMoves[player.index].foreach() {
            if position.board[$0].owner != nil {
                return false
            }
            
            addPawnMove(from: from, to: $0, isCapture: false)
            return true
        }
    }
    
    private func addPawnCaptures(from: Int) {
        SquareInfo[from].pawnCaptures[player.index].foreach() {
            if position.board[$0].owner == opponent {
                addPawnMove(from: from, to: $0, isCapture: true)
            } else if $0 == position.epSquare {
                let move = Move(from: from, epSquare: $0)
                moveList.add(move: move, score: 1.0)
            }
            
            return true
        }
    }
    
    private func addPawnMove(from: Int, to: Int, isCapture: Bool) {
        let isPromotion = (to >= 56 && player == .white) || (to < 8 && player == .black)
        if isPromotion {
            let options = [Piece(player, .queen), Piece(player, .rook), Piece(player, .bishop), Piece(player, .knight)]
            for p in options {
                let move = Move(from: from, to: to, piece: p, isCapture: isCapture, isPromotion: true)
                moveList.add(move: move, score: 1.0)
            }
        } else {
            let score = isCapture ? 1.0 : 0.0
            moveList.add(move: Move(from: from, to: to, piece: Piece(player, .pawn), isCapture: isCapture), score: score)
        }
    }
    
    private func addCastlingMoves() {
        switch player {
        case .white:
            tryAdd(castlingType: whiteKingside, intermediateSquares: [f1, g1])
            tryAdd(castlingType: whiteQueenside, intermediateSquares: [d1, c1, b1])
        case .black:
            tryAdd(castlingType: blackKingside, intermediateSquares: [f8, g8])
            tryAdd(castlingType: blackQueenside, intermediateSquares: [d8, c8, b8])
        }
        
        func tryAdd(castlingType: Int8, intermediateSquares: [Int]) {
            if (position.castlingRights & castlingType) == 0 {
                return
            }
            
            for i in intermediateSquares {
                if position.board[i] != Piece.none {
                    return
                }
            }
            
            if position.isAttacked(square: intermediateSquares[0], by: opponent) {
                return
            }
            
            moveList.add(move: Move(castles: castlingType), score: 0.5)
        }
    }
    
    @discardableResult private func addIfPossible(from: Int, to: Int) -> Bool {
        let piece = position.board[to]
        if piece.owner == player {
            return false
        } else if piece.owner == opponent {
            moveList.add(move: Move(from: from, to: to, piece: position.board[from], isCapture: true), score: 1.0)
            return false
        } else {
            moveList.add(move: Move(from: from, to: to, piece: position.board[from], isCapture: false), score: 0.0)
            return true
        }
    }
}
