//
//  MoveListTests.swift
//  
//
//  Created by Tony Jinks on 12/02/2024.
//

import XCTest
@testable import ChessLib

final class MoveListTests: XCTestCase {
    func testGetMoves() throws {
        let positionDto = try Notation.parseFen(fen: "8/8/8/K7/8/k1r1R3/8/8 b")
        let position = try Position(dto: positionDto)
        let moveList = MoveList()
        moveList.add(move: .normal(from: a3, to: a4, promoteTo: nil), score: 1.0)
        moveList.add(move: .normal(from: a3, to: b2, promoteTo: nil), score: 2.0)
        moveList.add(move: .normal(from: c3, to: c2, promoteTo: nil), score: 3.0)
        moveList.add(move: .normal(from: c3, to: e3, promoteTo: nil), score: 4.0)
        let result = moveList.getMoves(position: position)
        XCTAssertEqual(2, result.count)
        switch result[0] {
        case .normal(_, let to, _):
            XCTAssertEqual(e3, to)
        default:
            XCTFail()
        }

        switch result[1] {
        case .normal(_, let to, _):
            XCTAssertEqual(b2, to)
        default:
            XCTFail()
        }
    }
}
