//
//  MoveGeneratorTests.swift
//
//
//  Created by Tony Jinks on 14/02/2024.
//

import XCTest
@testable import ChessLib

extension [Move] {
    func startingFrom(_ square: Int) -> [Move] {
        var result: [Move] = []
        for m in self {
            switch m {
            case .normal(let from, _, _):
                if from == square {
                    result.append(m)
                }
            default:
                break
            }
        }
        
        return result
    }
    
    func containsMove(_ position: Position, to: Int, isCapture: Bool = false, promoteTo: Piece? = nil) -> Bool {
        for m in self {
            switch m {
            case .normal(_, let t, let p):
                if to == t && promoteTo == p {
                    return true
                }
            default:
                break
            }
        }
        return false
    }
    
    func containsCastling(_ position: Position, _ type: Int8) -> Bool {
        for m in self {
            switch type {
            case whiteKingside:
                switch m {
                case .castlesShort:
                    if position.playerToMove == .white {
                        return true
                    }
                default:
                    break
                }
    
            case whiteQueenside:
                switch m {
                case .castlesLong:
                    if position.playerToMove == .white {
                        return true
                    }
                default:
                    break
                }

            case blackKingside:
                switch m {
                case .castlesShort:
                    if position.playerToMove == .black {
                        return true
                    }
                default:
                    break
                }

            case blackQueenside:
                switch m {
                case .castlesLong:
                    if position.playerToMove == .black {
                        return true
                    }
                default:
                    break
                }

            default:
                break
            }
        }
        
        return false
    }
}

final class MoveGeneratorTests: XCTestCase {
    private var position: Position?
    private var moveList: MoveList?
    
    private func parseFen(_ fen: String) -> Position {
        let dto = try! Notation.parseFen(fen: fen)
        return try! Position(dto: dto)
    }
    
    private func getMoves(_ position: Position) -> [Move] {
        let ml = MoveGenerator.run(position: position, player: position.playerToMove)
        return ml.getMoves(position: position)
    }
    
    func testRookMoves() throws {
        let position = parseFen("8/8/3kr3/8/8/8/2K1R3/8 w -")
        var result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        result = result.startingFrom(e2)
        XCTAssertEqual(9, result.count)
        XCTAssertTrue(result.containsMove(position, to: e3))
        XCTAssertTrue(result.containsMove(position, to: e4))
        XCTAssertTrue(result.containsMove(position, to: e5))
        XCTAssertTrue(result.containsMove(position, to: e6, isCapture: true))
        XCTAssertTrue(result.containsMove(position, to: d2))
        XCTAssertTrue(result.containsMove(position, to: f2))
        XCTAssertTrue(result.containsMove(position, to: g2))
        XCTAssertTrue(result.containsMove(position, to: h2))
        XCTAssertTrue(result.containsMove(position, to: e1))
    }
    
    func testBishopMoves() throws {
        let position = parseFen("8/4k3/4b3/8/2B5/4K3/4R3/8 w -")
        var result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        result = result.startingFrom(c4)
        XCTAssertEqual(7, result.count)
        XCTAssertTrue(result.containsMove(position, to: b5))
        XCTAssertTrue(result.containsMove(position, to: a6))
        XCTAssertTrue(result.containsMove(position, to: d5))
        XCTAssertTrue(result.containsMove(position, to: e6, isCapture: true))
        XCTAssertTrue(result.containsMove(position, to: b3))
        XCTAssertTrue(result.containsMove(position, to: a2))
        XCTAssertTrue(result.containsMove(position, to: d3))
    }
    
    func testQueenMoves() throws {
        let position = parseFen("8/4k3/4b3/2r5/2Q1B3/4K3/4R3/8 w -")
        let result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position).startingFrom(c4)
        XCTAssertEqual(14, result.count)
        XCTAssertTrue(result.containsMove(position, to: c5, isCapture: true))
        XCTAssertTrue(result.containsMove(position, to: d5))
        XCTAssertTrue(result.containsMove(position, to: e6, isCapture: true))
        XCTAssertTrue(result.containsMove(position, to: d4))
        XCTAssertTrue(result.containsMove(position, to: d3))
        XCTAssertTrue(result.containsMove(position, to: c3))
        XCTAssertTrue(result.containsMove(position, to: c2))
        XCTAssertTrue(result.containsMove(position, to: c1))
        XCTAssertTrue(result.containsMove(position, to: b3))
        XCTAssertTrue(result.containsMove(position, to: a2))
        XCTAssertTrue(result.containsMove(position, to: b4))
        XCTAssertTrue(result.containsMove(position, to: a4))
        XCTAssertTrue(result.containsMove(position, to: b5))
        XCTAssertTrue(result.containsMove(position, to: a6))
    }
    
    func testKnightMoves() throws {
        let position = parseFen("8/4k3/1r6/8/2N5/4K3/8/8 w -")
        let result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position).startingFrom(c4)
        XCTAssertEqual(7, result.count)
        XCTAssertTrue(result.containsMove(position, to: b6, isCapture: true))
        XCTAssertTrue(result.containsMove(position, to: d6))
        XCTAssertTrue(result.containsMove(position, to: e5))
        XCTAssertTrue(result.containsMove(position, to: d2))
        XCTAssertTrue(result.containsMove(position, to: b2))
        XCTAssertTrue(result.containsMove(position, to: a3))
        XCTAssertTrue(result.containsMove(position, to: a5))
    }
    
    func testKingMoves() throws {
        let position = parseFen("8/8/4k3/8/8/4K3/3p4/8 w -")
        let result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position).startingFrom(e3)
        XCTAssertEqual(8, result.count)
        XCTAssertTrue(result.containsMove(position, to: e4))
        XCTAssertTrue(result.containsMove(position, to: f4))
        XCTAssertTrue(result.containsMove(position, to: f3))
        XCTAssertTrue(result.containsMove(position, to: f2))
        XCTAssertTrue(result.containsMove(position, to: e2))
        XCTAssertTrue(result.containsMove(position, to: d2, isCapture: true))
        XCTAssertTrue(result.containsMove(position, to: d3))
        XCTAssertTrue(result.containsMove(position, to: d4))
    }
    
    func testPawnMoves() throws {
        let position = parseFen("4k3/8/8/8/2p5/p4P2/P1P1P3/4K3 w -")
        let all = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        var result = all.startingFrom(a2)
        XCTAssertEqual(0, result.count)
        
        result = all.startingFrom(c2)
        XCTAssertEqual(1, result.count)
        XCTAssertTrue(result.containsMove(position, to: c3))
        
        result = all.startingFrom(e2)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.containsMove(position, to: e3))
        XCTAssertTrue(result.containsMove(position, to: e4))
        
        result = all.startingFrom(f3)
        XCTAssertEqual(1, result.count)
        XCTAssertTrue(result.containsMove(position, to: f4))
    }
    
    func testPawnCaptures() throws {
        let position = parseFen("4k3/8/8/8/2p5/1P1P4/8/4K3 b -")
        let result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position).startingFrom(c4)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.containsMove(position, to: b3, isCapture: true))
        XCTAssertTrue(result.containsMove(position, to: c3))
        XCTAssertTrue(result.containsMove(position, to: d3, isCapture: true))
    }
    
    func testEpCapture() throws {
        let position = parseFen("4k3/8/8/8/2pP4/8/8/4K3 b - d3")
        let result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position).startingFrom(c4)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.containsMove(position, to: c3))
        XCTAssertTrue(result.containsMove(position, to: d3, isCapture: true))
    }
    
    func testWhitePromotion() throws {
        let position = parseFen("1q2k3/2P5/8/8/8/8/8/4K3 w - -")
        let result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position).startingFrom(c7)
        XCTAssertEqual(8, result.count)
        XCTAssertTrue(result.containsMove(position, to: b8, isCapture: true, promoteTo: Piece(.white, .queen)))
        XCTAssertTrue(result.containsMove(position, to: b8, isCapture: true, promoteTo: Piece(.white, .rook)))
        XCTAssertTrue(result.containsMove(position, to: b8, isCapture: true, promoteTo: Piece(.white, .bishop)))
        XCTAssertTrue(result.containsMove(position, to: b8, isCapture: true, promoteTo: Piece(.white, .knight)))
        
        XCTAssertTrue(result.containsMove(position, to: c8, isCapture: false, promoteTo: Piece(.white, .queen)))
        XCTAssertTrue(result.containsMove(position, to: c8, isCapture: false, promoteTo: Piece(.white, .rook)))
        XCTAssertTrue(result.containsMove(position, to: c8, isCapture: false, promoteTo: Piece(.white, .bishop)))
        XCTAssertTrue(result.containsMove(position, to: c8, isCapture: false, promoteTo: Piece(.white, .knight)))
    }
    
    func testBlackPromotion() throws {
        let position = parseFen("4k3/8/8/8/8/8/2p5/1R2K3 b - -")
        let result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position).startingFrom(c2)
        XCTAssertEqual(8, result.count)
        XCTAssertTrue(result.containsMove(position, to: b1, isCapture: true, promoteTo: Piece(.black, .queen)))
        XCTAssertTrue(result.containsMove(position, to: b1, isCapture: true, promoteTo: Piece(.black, .rook)))
        XCTAssertTrue(result.containsMove(position, to: b1, isCapture: true, promoteTo: Piece(.black, .bishop)))
        XCTAssertTrue(result.containsMove(position, to: b1, isCapture: true, promoteTo: Piece(.black, .knight)))
        
        XCTAssertTrue(result.containsMove(position, to: c1, isCapture: false, promoteTo: Piece(.black, .queen)))
        XCTAssertTrue(result.containsMove(position, to: c1, isCapture: false, promoteTo: Piece(.black, .rook)))
        XCTAssertTrue(result.containsMove(position, to: c1, isCapture: false, promoteTo: Piece(.black, .bishop)))
        XCTAssertTrue(result.containsMove(position, to: c1, isCapture: false, promoteTo: Piece(.black, .knight)))
    }
    
    func testWhiteCastlingRights() {
        var position = parseFen("r3k2r/8/8/8/8/8/8/R3K2R w kq")
        var result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertFalse(result.containsCastling(position, whiteKingside))
        XCTAssertFalse(result.containsCastling(position, whiteQueenside))
        
        position = parseFen("r3k2r/8/8/8/8/8/8/R3K2R w Kkq")
        result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertTrue(result.containsCastling(position, whiteKingside))
        XCTAssertFalse(result.containsCastling(position, whiteQueenside))
        
        position = parseFen("r3k2r/8/8/8/8/8/8/R3K2R w Qkq")
        result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertFalse(result.containsCastling(position, whiteKingside))
        XCTAssertTrue(result.containsCastling(position, whiteQueenside))
        
        position = parseFen("r3k2r/8/8/8/8/8/8/R3K2R w KQkq")
        result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertTrue(result.containsCastling(position, whiteKingside))
        XCTAssertTrue(result.containsCastling(position, whiteQueenside))
    }
    
    func testBlackCastlingRights() {
        var position = parseFen("r3k2r/8/8/8/8/8/8/R3K2R b KQ")
        var result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertFalse(result.containsCastling(position, blackKingside))
        XCTAssertFalse(result.containsCastling(position, blackQueenside))
        
        position = parseFen("r3k2r/8/8/8/8/8/8/R3K2R b KQk")
        result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertTrue(result.containsCastling(position, blackKingside))
        XCTAssertFalse(result.containsCastling(position, blackQueenside))
        
        position = parseFen("r3k2r/8/8/8/8/8/8/R3K2R b KQq")
        result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertFalse(result.containsCastling(position, blackKingside))
        XCTAssertTrue(result.containsCastling(position, blackQueenside))
        
        position = parseFen("r3k2r/8/8/8/8/8/8/R3K2R b KQkq")
        result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertTrue(result.containsCastling(position, blackKingside))
        XCTAssertTrue(result.containsCastling(position, blackQueenside))
    }
    
    func testCastlingPreventedBySelf() {
        var position = parseFen("r3k2r/8/8/8/8/8/8/RN2KB1R w KQ")
        var result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertFalse(result.containsCastling(position, whiteKingside))
        XCTAssertFalse(result.containsCastling(position, whiteQueenside))
        
        position = parseFen("r3k2r/8/8/8/8/8/8/RN2K2R w KQ")
        result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertTrue(result.containsCastling(position, whiteKingside))
        XCTAssertFalse(result.containsCastling(position, whiteQueenside))
        
        position = parseFen("r3k2r/8/8/8/8/8/8/R3KB1R w KQ")
        result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertFalse(result.containsCastling(position, whiteKingside))
        XCTAssertTrue(result.containsCastling(position, whiteQueenside))
    }
    
    func testCastlingPreventedByOpponent() {
        let position = parseFen("r3k2r/8/8/8/2q5/8/8/R3K2R w KQ")
        let result = MoveGenerator.run(position: position, player: position.playerToMove).getMoves(position: position)
        XCTAssertFalse(result.containsCastling(position, whiteKingside))
        XCTAssertFalse(result.containsCastling(position, whiteQueenside))
    }
    
    private func getMoves(_ fen: String) -> [Move] {
        let dto = try! Notation.parseFen(fen: fen)
        let position = try! Position(dto: dto)
        let moveList = MoveGenerator.run(position: position, player: position.playerToMove)
        return moveList.getMoves(position: position)
    }
}
