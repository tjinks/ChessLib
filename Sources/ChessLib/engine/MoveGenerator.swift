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
    
    init(position: Position, player: Player) {
        self.position = position
        self.player = player
        opponent = player.other
        moveList = MoveList()
        
        for from in 0..<64 {
            if (position.board[from].owner == player) {
                addMoves(from: from)
            }
        }
    }
    
    var moves: MoveList {
        return moveList
    }
    
    func addMoves(from: Int) {
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
            break
        case .none:
            break
        }
    }
    
    func addKingMoves(from: Int) {
        SquareInfo[from].kingMoves.foreach() {
            addIfPossible(from: from, to: $0)
        }
    }
    
    func addKnightMoves(from: Int) {
        SquareInfo[from].knightMoves.foreach() {
            addIfPossible(from: from, to: $0)
        }
    }
    
    func addBishopMoves(from: Int) {
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
    
    func addRookMoves(from: Int) {
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
    
    func addQueenMoves(from: Int) {
        addRookMoves(from: from)
        addBishopMoves(from: from)
    }
    
    @discardableResult func addIfPossible(from: Int, to: Int) -> Bool {
        let piece = position.board[to]
        if piece.owner == player {
            return false
        } else if piece.owner == opponent {
            moveList.add(move: Move(from: from, to: to, piece: piece, isCapture: true), score: 1.0)
            return false
        } else {
            moveList.add(move: Move(from: from, to: to, piece: piece, isCapture: false), score: 0.0)
            return true
        }
    }
}
