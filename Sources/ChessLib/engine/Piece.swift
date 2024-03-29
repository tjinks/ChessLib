//
//  File.swift
//  
//
//  Created by Tony on 01/02/2024.
//

import Foundation

extension Player {
    var other: Player {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }
    
    var index: Int {
        return Int(self.rawValue)
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

extension PieceType {
    func movesOrthogonally() -> Bool {
        return self == .rook || self == .queen
    }
    
    func movesDiagonally() -> Bool {
        return self == .bishop || self == .queen
    }
}

struct Piece: Equatable, Hashable {
    static let none = Piece(nil, .none)
    let owner: Player?
    let type: PieceType
    
    init(_ owner: Player?, _ type: PieceType) {
        self.owner = owner
        self.type = type
    }
    
    init(_ piece: Dto.Piece) {
        switch (piece) {
        case .king(let owner):
            type = .king
            self.owner = owner
        case .queen(let owner):
            type = .queen
            self.owner = owner
        case .rook(let owner):
            type = .rook
            self.owner = owner
        case .bishop(let owner):
            type = .bishop
            self.owner = owner
        case .knight(let owner):
            type = .knight
            self.owner = owner
        case .pawn(let owner):
            type = .pawn
            self.owner = owner
        case .none:
            type = .none
            owner = .none
        }
    }
}

