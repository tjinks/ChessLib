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
        let position = try Position(positionDto: positionDto)
        let moveList = MoveList()
        moveList.add(move: Move(from: a3, to: a4, piece: Piece(.black, .king)), score: 1.0)
        moveList.add(move: Move(from: a3, to: b2, piece: Piece(.black, .king)), score: 2.0)
        moveList.add(move: Move(from: c3, to: c2, piece: Piece(.black, .rook)), score: 3.0)
        moveList.add(move: Move(from: c3, to: e3, piece: Piece(.black, .king), isCapture: true), score: 4.0)
        let result = moveList.getMoves(position: position)
        XCTAssertEqual(2, result.count)
        XCTAssertEqual(e3, result[0].to)
        XCTAssertEqual(b2, result[1].to)
    }
}
