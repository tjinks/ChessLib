//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

struct Move {
    let from: Int
    let to: Int
    let from1: Int?
    let to1: Int?
    let isCapture: Bool
    let promoteTo: Piece?
    let isPawnMove: Bool

    var isEpCapture: Bool {
        return isCapture && to1 != nil
    }
    
    var isCastles: Bool {
        return from1 != nil && to1 != nil
    }
    
    init(castles: Int8) {
        switch castles {
        case whiteKingside:
            from = e1
            to = g1
            from1 = h1
            to1 = f1
        case whiteQueenside:
            from = e1
            to = c1
            from1 = a1
            to1 = d1
        case blackKingside:
            from = e8
            to = g8
            from1 = h8
            to1 = f8
        case blackQueenside:
            from = e8
            to = c8
            from1 = a8
            to1 = d8
        default:
            assertionFailure("Invalid castling flag \(castles)")
            from = -1
            to = -1
            from1 = -1
            to1 = -1
        }
        	
        isCapture = false
        isPawnMove = false
        promoteTo = nil
    }
    
    init(position: Position, from: Int, to: Int, promoteTo: Piece? = nil) {
        self.from = from
        self.to = to
        from1 = nil
        to1 = nil
        isCapture = position.board[to].type != .none
        self.promoteTo = promoteTo
        isPawnMove = position.board[from].type == .pawn
    }
    
    init(position: Position, epCaptureFrom: Int) {
        from = epCaptureFrom
        to = position.epSquare!
        from1 = nil
        let fromFile = from % 8
        let toFile = to % 8
        to1 = from + toFile - fromFile
        isCapture = true
        promoteTo = nil
        isPawnMove = true
    }
}
