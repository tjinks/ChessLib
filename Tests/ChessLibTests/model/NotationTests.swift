//
//  NotationTests.swift
//  
//
//  Created by Tony on 18/01/2024.
//

import XCTest
import ChessLib

final class NotationTests: XCTestCase {
    private typealias Piece = Dto.Piece
    private typealias Square = Dto.Square
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testParseFenInitialPosition() throws {
        let result =
        try Notation.parseFen(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
        for sqnum in 0...63 {
            let square = try Square(number: sqnum)
            let piece = result.getPiece(at: square)
            switch (sqnum) {
            case 0, 7:
                XCTAssertEqual(Piece.rook(owner: .white), piece)
            case 1, 6:
                XCTAssertEqual(Piece.knight(owner: .white), piece)
            case 2, 5:
                XCTAssertEqual(Piece.bishop(owner: .white), piece)
            case 3:
                XCTAssertEqual(Piece.queen(owner: .white), piece)
            case 4:
                XCTAssertEqual(Piece.king(owner: .white), piece)
            case 8...15:
                XCTAssertEqual(Piece.pawn(owner: .white), piece)
            case 16...47:
                XCTAssertEqual(Piece.none, piece)
            case 48...55:
                XCTAssertEqual(Piece.pawn(owner: .black), piece)
            case 56, 63:
                XCTAssertEqual(Piece.rook(owner: .black), piece)
            case 57, 62:
                XCTAssertEqual(Piece.knight(owner: .black), piece)
            case 58, 61:
                XCTAssertEqual(Piece.bishop(owner: .black), piece)
            case 59:
                XCTAssertEqual(Piece.queen(owner: .black), piece)
            case 60:
                XCTAssertEqual(Piece.king(owner: .black), piece)
            default:
                break
            }
        }
        
        XCTAssertEqual(.white, result.playerToMove)
        XCTAssertTrue(result.castlingRights.contains(.blackKingside))
        XCTAssertTrue(result.castlingRights.contains(.whiteKingside))
        XCTAssertTrue(result.castlingRights.contains(.blackQueenside))
        XCTAssertTrue(result.castlingRights.contains(.whiteQueenside))
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(0, result.halfMoveClock)
        XCTAssertEqual(1, result.fullMove)
    }
    
    func testParseFenWithEp() throws {
        let result = try Notation.parseFen(fen: "7k/8/8/8/4P3/K7/8/8 b - e3 0 53")
        for sqnum in 0...63 {
            let square = try Square(number: sqnum)
            let piece = result.getPiece(at: square)
            switch (sqnum) {
            case 16:
                XCTAssertEqual(Piece.king(owner: .white), piece)
            case 28:
                XCTAssertEqual(Piece.pawn(owner: .white), piece)
            case 63:
                XCTAssertEqual(Piece.king(owner: .black), piece)
            default:
                XCTAssertEqual(Piece.none, piece)
            }
            XCTAssertEqual(.black, result.playerToMove)
            XCTAssertEqual(0, result.castlingRights.count)
            XCTAssertEqual(try Square(name: "e3"), result.epSquare)
            XCTAssertEqual(0, result.halfMoveClock)
            XCTAssertEqual(53, result.fullMove)
        }
    }
}
