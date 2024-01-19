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

    func testParseFen() throws {
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
}
