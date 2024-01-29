//
//  File.swift
//  
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public enum Piece: Int8 {
    case none = 0
    case whiteKing = 1
    case blackKing = -1
    case whiteQueen = 2
    case blackQueen = -2
    case whiteRook = 3
    case blackRook = -3
    case whiteBishop = 4
    case blackBishop = -4
    case whiteKnight = 5
    case blackKnight = -5
    case whitePawn = 6
    case blackPawn = -6
}

public extension Piece {
    var isWhite: Bool {
        return self.rawValue > 0
    }
    
    var isBlack: Bool {
        return self.rawValue < 0
    }
}
