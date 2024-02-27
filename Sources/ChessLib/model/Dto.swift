//
//  File.swift
//  
//
//  Created by Tony on 30/01/2024.
//

import Foundation

public enum Dto {

    public enum Player {
        case white, black
    }
    
    public enum Piece: Equatable, Hashable {
        case none
        case king(owner: Player)
        case queen(owner: Player)
        case rook(owner: Player)
        case bishop(owner: Player)
        case knight(owner: Player)
        case pawn(owner: Player)
    }
    
    public enum CastlingOption {
        case whiteKingside
        case whiteQueenside
        case blackKingside
        case blackQueenside
    }
    
    public enum Result {
        case none, whiteWin, blackWin, draw
    }
    
    public typealias CastlingRights = Set<CastlingOption>
    
    public struct Square: CustomStringConvertible, Equatable, Hashable {
        public let rank: Int
        public let file: Int
        
        public var number: Int {
            return 8 * rank + file
        }
        
        public var description: String {
            return Notation.getSquareName(self)
        }
         
        public init(file: Int, rank: Int) throws {
            try Square.validateRankOrFile(file)
            try Square.validateRankOrFile(rank)
            self.file = file
            self.rank = rank
        }
        
        public init(number: Int) throws {
            let file = number % 8
            let rank = number / 8
            try self.init(file: file, rank: rank)
        }
        
        public init(name: String) throws {
            let square = try Notation.parseSquareName(name: name)
            try self.init(file: square.file, rank: square.rank)
        }
        
        public static func all() -> [Square] {
            var result: [Square] = []
            for rank in 0..<8 {
                for file in 0..<8 {
                    result.append(try! Square(file: file, rank: rank))
                }
            }
            
            return result
        }
        
        private static func validateRankOrFile(_ n: Int) throws {
            if (n < 0) || (n >= 8) {
                throw ChessError.invalidSquare
            }
        }
    }
    
    public struct Position {
        public let pieces: Dictionary<Square, Piece>
        public let playerToMove: Player
        public let castlingRights: CastlingRights
        public let epSquare: Square?
        public let halfMoveClock: Int
        public let fullMove: Int
        
        public init(pieces: Dictionary<Square, Piece>,
             playerToMove: Player,
             castlingRights: CastlingRights,
             epSquare: Square?,
             halfMoveClock: Int,
             fullMove: Int) {
            self.pieces = pieces
            self.playerToMove = playerToMove
            self.castlingRights = castlingRights
            self.epSquare = epSquare
            self.halfMoveClock = halfMoveClock
            self.fullMove = fullMove
        }
        
        public init(pieces: Dictionary<Square, Piece>, playerToMove: Player) {
            self.init(pieces: pieces, playerToMove: playerToMove, castlingRights: [], epSquare: nil, halfMoveClock: 100, fullMove: 0)
        }
        
        public func getPiece(at: Square) -> Piece {
            if let piece = pieces[at] {
                return piece
            } else {
                return .none
            }
        }
    }
    
}
