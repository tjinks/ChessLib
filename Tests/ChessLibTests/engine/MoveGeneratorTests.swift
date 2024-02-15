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
            if m.from == square {
                result.append(m)
            }
        }
        
        return result
    }
    
    func contains(to: Int, isCapture: Bool = false) -> Bool {
        for m in self {
            if m.to == to {
                return m.isCapture == isCapture
            }
        }
        
        return false
    }
    
    func containsCastling(_ type: Int8) -> Bool {
        for m in self {
            switch type {
            case whiteKingside:
                if m.from == e1 && m.to == g1 && m.from1 == h1 && m.to1 == f1 {
                    return true
                }
            case whiteQueenside:
                if m.from == e1 && m.to == c1 && m.from1 == a1 && m.to1 == d1 {
                    return true
                }
            case blackKingside:
                if m.from == e8 && m.to == g8 && m.from1 == h8 && m.to1 == f8 {
                    return true
                }
            case blackQueenside:
                if m.from == e8 && m.to == c8 && m.from1 == a8 && m.to1 == d8 {
                    return true
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

    func testRookMoves() throws {
        let result = getMoves("8/8/3kr3/8/8/8/2K1R3/8 w -").startingFrom(e2)
        XCTAssertEqual(9, result.count)
        XCTAssertTrue(result.contains(to: e3))
        XCTAssertTrue(result.contains(to: e4))
        XCTAssertTrue(result.contains(to: e5))
        XCTAssertTrue(result.contains(to: e6, isCapture: true))
        XCTAssertTrue(result.contains(to: d2))
        XCTAssertTrue(result.contains(to: f2))
        XCTAssertTrue(result.contains(to: g2))
        XCTAssertTrue(result.contains(to: h2))
        XCTAssertTrue(result.contains(to: e1))
        
        for m in result {
            XCTAssertEqual(Piece(.white, .rook), m.piece)
        }
    }
    
    func testBishopMoves() throws {
        let result = getMoves("8/4k3/4b3/8/2B5/4K3/4R3/8 w -").startingFrom(c4)
        XCTAssertEqual(7, result.count)
        XCTAssertTrue(result.contains(to: b5))
        XCTAssertTrue(result.contains(to: a6))
        XCTAssertTrue(result.contains(to: d5))
        XCTAssertTrue(result.contains(to: e6, isCapture: true))
        XCTAssertTrue(result.contains(to: b3))
        XCTAssertTrue(result.contains(to: a2))
        XCTAssertTrue(result.contains(to: d3))
        
        for m in result {
            XCTAssertEqual(Piece(.white, .bishop), m.piece)
        }
    }
    
    func testQueenMoves() throws {
        let result = getMoves("8/4k3/4b3/2r5/2Q1B3/4K3/4R3/8 w -").startingFrom(c4)
        XCTAssertEqual(14, result.count)
        XCTAssertTrue(result.contains(to: c5, isCapture: true))
        XCTAssertTrue(result.contains(to: d5))
        XCTAssertTrue(result.contains(to: e6, isCapture: true))
        XCTAssertTrue(result.contains(to: d4))
        XCTAssertTrue(result.contains(to: d3))
        XCTAssertTrue(result.contains(to: c3))
        XCTAssertTrue(result.contains(to: c2))
        XCTAssertTrue(result.contains(to: c1))
        XCTAssertTrue(result.contains(to: b3))
        XCTAssertTrue(result.contains(to: a2))
        XCTAssertTrue(result.contains(to: b4))
        XCTAssertTrue(result.contains(to: a4))
        XCTAssertTrue(result.contains(to: b5))
        XCTAssertTrue(result.contains(to: a6))
        
        for m in result {
            XCTAssertEqual(Piece(.white, .queen), m.piece)
        }
    }
    
    func testKnightMoves() throws {
        let result = getMoves("8/4k3/1r6/8/2N5/4K3/8/8 w -").startingFrom(c4)
        XCTAssertEqual(7, result.count)
        XCTAssertTrue(result.contains(to: b6, isCapture: true))
        XCTAssertTrue(result.contains(to: d6))
        XCTAssertTrue(result.contains(to: e5))
        XCTAssertTrue(result.contains(to: d2))
        XCTAssertTrue(result.contains(to: b2))
        XCTAssertTrue(result.contains(to: a3))
        XCTAssertTrue(result.contains(to: a5))
        
        for m in result {
            XCTAssertEqual(Piece(.white, .knight), m.piece)
        }
    }
    
    func testKingMoves() throws {
        let result = getMoves("8/8/4k3/8/8/4K3/3p4/8 w -").startingFrom(e3)
        XCTAssertEqual(8, result.count)
        XCTAssertTrue(result.contains(to: e4))
        XCTAssertTrue(result.contains(to: f4))
        XCTAssertTrue(result.contains(to: f3))
        XCTAssertTrue(result.contains(to: f2))
        XCTAssertTrue(result.contains(to: e2))
        XCTAssertTrue(result.contains(to: d2, isCapture: true))
        XCTAssertTrue(result.contains(to: d3))
        XCTAssertTrue(result.contains(to: d4))

        for m in result {
            XCTAssertEqual(Piece(.white, .king), m.piece)
        }
    }

    func testPawnMoves() throws {
        let all = getMoves("4k3/8/8/8/2p5/p4P2/P1P1P3/4K3 w -")
        var result = all.startingFrom(a2)
        XCTAssertEqual(0, result.count)
        
        result = all.startingFrom(c2)
        XCTAssertEqual(1, result.count)
        XCTAssertTrue(result.contains(to: c3))
        
        result = all.startingFrom(e2)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(to: e3))
        XCTAssertTrue(result.contains(to: e4))
        
        result = all.startingFrom(f3)
        XCTAssertEqual(1, result.count)
        XCTAssertTrue(result.contains(to: f4))
        XCTAssertEqual(Piece(.white, .pawn), result[0].piece)
    }

    func testPawnCaptures() throws {
        let result = getMoves("4k3/8/8/8/2p5/1P1P4/8/4K3 b -").startingFrom(c4)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(to: b3, isCapture: true))
        XCTAssertTrue(result.contains(to: c3))
        XCTAssertTrue(result.contains(to: d3, isCapture: true))

        for m in result {
            XCTAssertEqual(Piece(.black, .pawn), m.piece)
        }
    }
    
    func testEpCapture() throws {
        let result = getMoves("4k3/8/8/8/2pP4/8/8/4K3 b - d3").startingFrom(c4)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(to: c3))
        XCTAssertTrue(result.contains(to: d3, isCapture: true))

        for m in result {
            XCTAssertEqual(Piece(.black, .pawn), m.piece)
            if m.to == d3 {
                XCTAssertEqual(d4, m.to1)
            }
        }
    }
    
    func testWhiteCastlingRights() {
        var result = getMoves("r3k2r/8/8/8/8/8/8/R3K2R w kq")
        XCTAssertFalse(result.containsCastling(whiteKingside))
        XCTAssertFalse(result.containsCastling(whiteQueenside))

        result = getMoves("r3k2r/8/8/8/8/8/8/R3K2R w Kkq")
        XCTAssertTrue(result.containsCastling(whiteKingside))
        XCTAssertFalse(result.containsCastling(whiteQueenside))

        result = getMoves("r3k2r/8/8/8/8/8/8/R3K2R w Qkq")
        XCTAssertFalse(result.containsCastling(whiteKingside))
        XCTAssertTrue(result.containsCastling(whiteQueenside))

        result = getMoves("r3k2r/8/8/8/8/8/8/R3K2R w KQkq")
        XCTAssertTrue(result.containsCastling(whiteKingside))
        XCTAssertTrue(result.containsCastling(whiteQueenside))
    }
    
    func testBlackCastlingRights() {
        var result = getMoves("r3k2r/8/8/8/8/8/8/R3K2R b KQ")
        XCTAssertFalse(result.containsCastling(blackKingside))
        XCTAssertFalse(result.containsCastling(blackQueenside))

        result = getMoves("r3k2r/8/8/8/8/8/8/R3K2R b KQk")
        XCTAssertTrue(result.containsCastling(blackKingside))
        XCTAssertFalse(result.containsCastling(blackQueenside))

        result = getMoves("r3k2r/8/8/8/8/8/8/R3K2R b KQq")
        XCTAssertFalse(result.containsCastling(blackKingside))
        XCTAssertTrue(result.containsCastling(blackQueenside))

        result = getMoves("r3k2r/8/8/8/8/8/8/R3K2R b KQkq")
        XCTAssertTrue(result.containsCastling(blackKingside))
        XCTAssertTrue(result.containsCastling(blackQueenside))
    }
    
    func testCastlingPreventedBySelf() {
        var result = getMoves("r3k2r/8/8/8/8/8/8/RN2KB1R w KQ")
        XCTAssertFalse(result.containsCastling(whiteKingside))
        XCTAssertFalse(result.containsCastling(whiteQueenside))

        result = getMoves("r3k2r/8/8/8/8/8/8/RN2K2R w KQ")
        XCTAssertTrue(result.containsCastling(whiteKingside))
        XCTAssertFalse(result.containsCastling(whiteQueenside))

        result = getMoves("r3k2r/8/8/8/8/8/8/R3KB1R w KQ")
        XCTAssertFalse(result.containsCastling(whiteKingside))
        XCTAssertTrue(result.containsCastling(whiteQueenside))
    }
    
    
    
    private func getMoves(_ fen: String) -> [Move] {
        let positionDto = try! Notation.parseFen(fen: fen)
        let position = try! Position(positionDto: positionDto)
        let moveList = MoveGenerator.run(position: position, player: position.playerToMove)
        return moveList.getMoves(position: position)
    }
    
    private func contains(_ from: Int, _ to: Int) -> Bool {
        for m in moveList!.getMoves(position: position!) {
            if m.from == from && m.to == to {
                return true
            }
        }
        
        return false
    }
}
