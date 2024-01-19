//
//  File.swift
//
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public class Notation {
    
    public static func parseFen(fen: String) throws -> PositionDto {
        let boardIndex = 0
        let playerIndex = 1
        let castlingRightsIndex = 2
        let epSquareIndex = 3
        let halfMoveClockIndex = 4
        let fullMoveIndex = 5
        
        var rank: Int = 7
        var file: Int = 0
        var positionDto = PositionDto()
        
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
        
        return positionDto
        
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
                positionDto.activePlayer = .white
                return
            case "b":
                positionDto.activePlayer = .black
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
                case "K": positionDto.castlingRights.insert(.whiteK)
                case "k": positionDto.castlingRights.insert(.blackK)
                case "Q": positionDto.castlingRights.insert(.whiteQ)
                case "q": positionDto.castlingRights.insert(.blackQ)
                default: throw ChessError.invalidFen
                }
            }
        }
        
        func parseEpSquare(_ s: String) throws {
            if s == "-" {
                return
            }
            
            do {
                positionDto.epSquare = try Square.get(s)
            } catch ChessError.invalidSquare {
                throw ChessError.invalidFen
            }
        }
        
        func parseHalfMoveClock(_ s: String) throws {
            guard let result = Int(s) else {
                throw ChessError.invalidFen
            }
            
            positionDto.halfMoveClock = result
        }
        
        func parseFullMove(_ s: String) throws {
            guard let result = Int(s) else {
                throw ChessError.invalidFen
            }
            
            positionDto.fullMove = result
        }
        
        func addPiece(_ c: Character) throws -> Bool {
            guard let piece = charToPiece(c) else {
                return false
            }
            
            do {
                let square = try Square.get(file: file, rank: rank)
                positionDto.pieces[square] = piece
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
    
    private static func charToPiece(_ c: Character) -> Piece? {
        switch (c) {
        case "K": return .whiteKing
        case "k": return .blackKing
        case "Q": return .whiteQueen
        case "q": return .blackQueen
        case "R": return .whiteRook
        case "r": return .blackRook
        case "B": return .whiteBishop
        case "b": return .blackBishop
        case "N": return .whiteKnight
        case "n": return .blackKnight
        case "P": return .whitePawn
        case "p": return .blackPawn
        default: return nil
        }
    }
}

