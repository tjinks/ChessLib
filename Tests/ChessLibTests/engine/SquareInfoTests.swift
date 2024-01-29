//
//  SquareInfoTest.swift
//  
//
//  Created by Tony on 28/01/2024.
//

import XCTest
@testable import ChessLib

typealias SquareInfo = ChessLib.SquareInfo

final class SquareInfoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSecondRankPawnMoves() throws {
        let whitePawnMoves = getSquares(SquareInfo(square: 12).pawnMoves[Int(Player.white.rawValue)])
        XCTAssertEqual(2, whitePawnMoves.count)
        XCTAssertEqual(20, whitePawnMoves[0])
        XCTAssertEqual(28, whitePawnMoves[1])

        let blackPawnMoves = getSquares(SquareInfo(square: 52).pawnMoves[Int(Player.black.rawValue)])
        XCTAssertEqual(2, blackPawnMoves.count)
        XCTAssertEqual(44, blackPawnMoves[0])
        XCTAssertEqual(36, blackPawnMoves[1])
    }
    
    func testPawnCaptures() throws {
        let whitePawnCaptures = getSquares(SquareInfo(square: 17).pawnCaptures[Int(Player.white.rawValue)])
        XCTAssertEqual(2, whitePawnCaptures.count)
        XCTAssertTrue(whitePawnCaptures.contains(24))
        XCTAssertTrue(whitePawnCaptures.contains(26))

        let blackPawnCaptures = getSquares(SquareInfo(square: 17).pawnCaptures[Int(Player.black.rawValue)])
        XCTAssertEqual(2, blackPawnCaptures.count)
        XCTAssertTrue(blackPawnCaptures.contains(8))
        XCTAssertTrue(blackPawnCaptures.contains(10))
    }

    func testKingMoves() throws {
        var result = getSquares(SquareInfo(square: 0).kingMoves)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(1))
        XCTAssertTrue(result.contains(8))
        XCTAssertTrue(result.contains(9))

        result = getSquares(SquareInfo(square: 7).kingMoves)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(6))
        XCTAssertTrue(result.contains(14))
        XCTAssertTrue(result.contains(15))
        
        result = getSquares(SquareInfo(square: 56).kingMoves)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(57))
        XCTAssertTrue(result.contains(48))
        XCTAssertTrue(result.contains(49))
        
        result = getSquares(SquareInfo(square: 63).kingMoves)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(62))
        XCTAssertTrue(result.contains(54))
        XCTAssertTrue(result.contains(55))
    }

    func testKnightMoves() throws {
        var result = getSquares(SquareInfo(square: 0).knightMoves)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(17))
        XCTAssertTrue(result.contains(10))

        result = getSquares(SquareInfo(square: 7).knightMoves)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(13))
        XCTAssertTrue(result.contains(22))
        
        result = getSquares(SquareInfo(square: 56).knightMoves)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(50))
        XCTAssertTrue(result.contains(41))
        
        result = getSquares(SquareInfo(square: 63).knightMoves)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(53))
        XCTAssertTrue(result.contains(46))
    }

    private func getSquares(_ squareSet: Int64) -> [Int] {
        var result: [Int] = []
        SquareInfo.foreach(squareSet: squareSet) {
            result.append($0)
            return true
        }
        
        return result
    }
}
