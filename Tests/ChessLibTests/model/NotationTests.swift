//
//  NotationTests.swift
//  
//
//  Created by Tony on 18/01/2024.
//

import XCTest
import ChessLib

final class NotationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParseFenInitialPosition() throws {
        let result =
            try Notation.parseFen(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
        XCTAssertEqual(32, result.pieces.count)
        XCTAssertEqual(.whiteRook, result.pieces[try Square.get("a1")])
        XCTAssertEqual(.blackPawn, result.pieces[try Square.get("b7")])
        XCTAssertEqual(.white, result.activePlayer)
        XCTAssertTrue(result.castlingRights.contains(.blackK))
        XCTAssertTrue(result.castlingRights.contains(.whiteK))
        XCTAssertTrue(result.castlingRights.contains(.blackQ))
        XCTAssertTrue(result.castlingRights.contains(.whiteQ))
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(0, result.halfMoveClock)
        XCTAssertEqual(1, result.fullMove)
    }
    
    func testParseFenWithEp() throws {
        let result = try Notation.parseFen(fen: "7k/8/8/8/4P3/K7/8/8 b - e3 0 53")
        XCTAssertEqual(3, result.pieces.count)
        XCTAssertEqual(.whiteKing, result.pieces[try Square.get("a3")])
        XCTAssertEqual(.whitePawn, result.pieces[try Square.get("e4")])
        XCTAssertEqual(.blackKing, result.pieces[try Square.get("h8")])
        XCTAssertEqual(.black, result.activePlayer)
        XCTAssertEqual(0, result.castlingRights.count)
        XCTAssertEqual(try Square.get("e3"), result.epSquare)
        XCTAssertEqual(0, result.halfMoveClock)
        XCTAssertEqual(53, result.fullMove)
    }
}
