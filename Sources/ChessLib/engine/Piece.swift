//
//  File.swift
//  
//
//  Created by Tony on 01/02/2024.
//

import Foundation

enum Player: Int8 {
    case white = 0
    case black = 1
    case none = 2
}

extension Player {
    var other: Player {
        switch self {
        case .black: return .white
        case .white: return .black
        case .none: return .none
        }
    }
}

enum PieceType: Int8 {
    case none = 0
    case king = 1
    case queen = 2
    case rook = 3
    case bishop = 4
    case knight = 5
    case pawn = 6
}

struct Piece: Equatable, Hashable {
    static let none = Piece(.none, .none)
    let owner: Player
    let type: PieceType
    
    init(_ owner: Player, _ type: PieceType) {
        self.owner = owner
        self.type = type
    }
    
    init(_ piece: Dto.Piece) {
        switch (piece) {
        case .king(let owner):
            type = .king
            self.owner = Piece.convert(owner)
        case .queen(let owner):
            type = .queen
            self.owner = Piece.convert(owner)
        case .rook(let owner):
            type = .rook
            self.owner = Piece.convert(owner)
        case .bishop(let owner):
            type = .bishop
            self.owner = Piece.convert(owner)
        case .knight(let owner):
            type = .knight
            self.owner = Piece.convert(owner)
        case .pawn(let owner):
            type = .pawn
            self.owner = Piece.convert(owner)
        case .none:
            type = .none
            owner = .none
        }
    }
    
    private static func convert(_ dtoPlayer: Dto.Player) -> Player {
        switch (dtoPlayer) {
        case .black: return .black
        case .white: return .white
        }
    }
}

