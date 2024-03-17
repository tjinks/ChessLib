//
//  File.swift
//
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public class Notation {
    public static let initialPosition = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

    private static let fileChars:[Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
    private static let rankChars:[Character] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    public static func getSquareName(_ square: Dto.Square) -> String {
        let fileChar = fileChars[square.file]
        let rankChar = rankChars[square.rank]
        return String(fileChar) + String(rankChar)
    }
    
    public static func parseSquareName(name: String) throws -> Dto.Square {
        if name.count != 2 {
            throw ChessError.invalidSquare
        }
        
        let fileChar = name[name.startIndex]
        let rankChar = name[name.index(after: name.startIndex)]
        if let file = fileChars.firstIndex(of: fileChar) {
            if let rank = rankChars.firstIndex(of: rankChar) {
                return try Dto.Square(file: file, rank: rank)
            }
        }

        throw ChessError.invalidSquare
    }
    
    public static func parseFen(fen: String) throws -> Dto.Position {
        let boardIndex = 0
        let playerIndex = 1
        let castlingRightsIndex = 2
        let epSquareIndex = 3
        let halfMoveClockIndex = 4
        let fullMoveIndex = 5
        
        var rank: Int = 7
        var file: Int = 0
        var pieces:Dictionary<Dto.Square, Dto.Piece> = [:]
        var playerToMove = Player.white
        var castlingRights: Dto.CastlingRights = []
        var epSquare: Dto.Square? = nil
        var halfMoveClock = 100
        var fullMove = 0
        
        let parts = split()
        if parts.count < playerIndex + 1 {
            throw ChessError.invalidFen
        }
        
        try parseBoard(parts[boardIndex])
        try parsePlayer(parts[playerIndex])
        if parts.count >= castlingRightsIndex + 1 {
            try parseCastlingRights(parts[2])
        }
        
        if parts.count >= epSquareIndex + 1 {
            try parseEpSquare(parts[epSquareIndex])
        }
        
        if parts.count >= halfMoveClockIndex + 1 {
            try parseHalfMoveClock(parts[halfMoveClockIndex])
        }
        
        if parts.count >= fullMoveIndex + 1 {
            try parseFullMove(parts[fullMoveIndex])
        }
        
        return Dto.Position(pieces: pieces,
                            playerToMove: playerToMove,
                            castlingRights: castlingRights,
                            epSquare: epSquare,
                            halfMoveClock: halfMoveClock,
                            fullMove: fullMove)
        
        func split() -> [String] {
            var result: [String] = []
            for part in fen.components(separatedBy: .whitespaces) {
                if part.count > 0 {
                    result.append(part)
                }
            }
            
            return result
        }
        
        func parseBoard(_ s: String) throws {
            for c in s {
                if try addPiece(c) {
                    continue;
                }
                
                if updateCurrentSquare(c) {
                    continue;
                }
                
                throw ChessError.invalidFen
            }
        }
        
        func parsePlayer(_ s: String) throws {
            switch (s) {
            case "w":
                playerToMove = .white
                return
            case "b":
                playerToMove = .black
                return
            default:
                throw ChessError.invalidFen
            }
        }
        
        func parseCastlingRights(_ s: String) throws {
            if s == "-" {
                return
            }
            
            for c in s {
                switch (c) {
                case "K": castlingRights.insert(.whiteKingside)
                case "k": castlingRights.insert(.blackKingside)
                case "Q": castlingRights.insert(.whiteQueenside)
                case "q": castlingRights.insert(.blackQueenside)
                default: throw ChessError.invalidFen
                }
            }
        }
        
        func parseEpSquare(_ s: String) throws {
            if s == "-" {
                return
            }
            
            do {
                epSquare = try Dto.Square(name: s)
            } catch ChessError.invalidSquare {
                throw ChessError.invalidFen
            }
        }
        
        func parseHalfMoveClock(_ s: String) throws {
            guard let result = Int(s) else {
                throw ChessError.invalidFen
            }
            
            halfMoveClock = result
        }
        
        func parseFullMove(_ s: String) throws {
            guard let result = Int(s) else {
                throw ChessError.invalidFen
            }
            
            fullMove = result
        }
        
        func addPiece(_ c: Character) throws -> Bool {
            guard let piece = charToPiece(c) else {
                return false
            }
            
            do {
                let square = try Dto.Square(file: file, rank: rank)
                pieces[square] = piece
                file += 1
                
                return true
            } catch ChessError.invalidSquare {
                throw ChessError.invalidFen
            }
        }
        
        func updateCurrentSquare(_ c: Character) -> Bool {
            if !c.isASCII {
                return false
            }
            
            if c == "/" {
                file = 0
                rank -= 1
                return rank >= 0
            }
            
            let fileIncr = (Int)(c.asciiValue!) - (Int)(Character("0").asciiValue!)
            if (fileIncr < 1) {
                return false
            }
            
            file += fileIncr
            return file <= 8
        }
    }
    
    private static func charToPiece(_ c: Character) -> Dto.Piece? {
        switch (c) {
        case "K": return .king(owner: .white)
        case "k": return .king(owner: .black)
        case "Q": return .queen(owner: .white)
        case "q": return .queen(owner: .black)
        case "R": return .rook(owner: .white)
        case "r": return .rook(owner: .black)
        case "B": return .bishop(owner: .white)
        case "b": return .bishop(owner: .black)
        case "N": return .knight(owner: .white)
        case "n": return .knight(owner: .black)
        case "P": return .pawn(owner: .white)
        case "p": return .pawn(owner: .black)
        default: return nil
        }
    }
}

