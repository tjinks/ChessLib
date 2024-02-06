//
//  GameStateTests.swift
//  
//
//  Created by Tony on 06/02/2024.
//

import XCTest
@testable import ChessLib

final class GameStateTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeMove() throws {
        var position = Position()
        var gameState = GameState(initialPosition: position, initialHalfMoveClock: 0, initialFullMove: 1)
        position = gameState.makeMove(Move(from: 6, to: 21, piece: Piece(.white, .knight)))
        XCTAssertEqual(Player.black, position.playerToMove)
        XCTAssert(position == gameState.currentPosition)
    }
    
    func testRetractLastMove() throws {
        var position = Position()
        var gameState = GameState(initialPosition: position, initialHalfMoveClock: 0, initialFullMove: 1)
        gameState.makeMove(Move(from: 6, to: 21, piece: Piece(.white, .knight)))
        position = gameState.retractLastMove()!
        XCTAssert(position == Position())
        XCTAssertNil(gameState.retractLastMove())
    }
    
    func testGetRepetitionCount() throws {
        var position = Position()
        var gameState = GameState(initialPosition: position, initialHalfMoveClock: 0, initialFullMove: 1)
        gameState.makeMove(Move(from: 12, to: 20, piece: Piece(.white, .pawn)))
        
    }
}
