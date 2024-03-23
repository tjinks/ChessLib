//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

enum Move {
    case castlesLong
    case castlesShort
    case normal(from: Square, to: Square, promoteTo: Piece?)
}

extension Move {
    func isCapture(_ position: Position) -> Bool {
        switch self {
        case .normal(_, let to, _):
            return position[to] != .none || isEpCapture(position)
        default:
            return false
        }
    }
    
    func isEpCapture(_ position: Position) -> Bool {
        switch self {
        case .normal(_, let to, _):
            return to.number == position.epSquare
        default:
            return false
        }
    }
    
    func score(position: Position) -> Double {
        switch self {
        case .castlesLong:
            return 0.4
        case .castlesShort:
            return 0.5
        case .normal(_, _, let promoteTo):
            if promoteTo != nil {
                return 2.0
            } else if isCapture(position) {
                return 1.0
            } else {
                return 0.0
            }
        }
    }
}

/*
struct Move {
    let from: Int
    let to: Int
    let from1: Int?
    let to1: Int?
    let isCapture: Bool
    let isPawnMove: Bool
    let isPromotion: Bool
    let piece: Piece

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
            piece = Piece(.white, .king)
        case whiteQueenside:
            from = e1
            to = c1
            from1 = a1
            to1 = d1
            piece = Piece(.white, .king)
        case blackKingside:
            from = e8
            to = g8
            from1 = h8
            to1 = f8
            piece = Piece(.black, .king)
        case blackQueenside:
            from = e8
            to = c8
            from1 = a8
            to1 = d8
            piece = Piece(.black, .king)
        default:
            assertionFailure("Invalid castling flag \(castles)")
            from = -1
            to = -1
            from1 = -1
            to1 = -1
            piece = Piece.none
        }
        	
        isCapture = false
        isPawnMove = false
        isPromotion = false
    }
    
    init(from: Int, to: Int, piece: Piece, isCapture: Bool = false, isPromotion: Bool = false) {
        self.from = from
        self.to = to
        from1 = nil
        to1 = nil
        self.isCapture = isCapture
        self.isPromotion = isPromotion
        isPawnMove = piece.type == .pawn || isPromotion
        self.piece = piece
    }
    
    init(from: Int, epSquare: Int) {
        self.from = from
        to = epSquare
        from1 = nil
        let fromFile = from % 8
        let toFile = to % 8
        to1 = from + toFile - fromFile
        isCapture = true
        isPawnMove = true
        isPromotion = false
        self.piece = (epSquare / 8) == 2 ? Piece(.black, .pawn) : Piece(.white, .pawn)
    }
}
*/
