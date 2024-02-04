//
//  PositionTests.swift
//  
//
//  Created by Tony on 01/02/2024.
//

import XCTest
@testable import ChessLib

typealias Position = ChessLib.Position
typealias Player = ChessLib.Player
typealias Piece = ChessLib.Piece
typealias PieceType = ChessLib.PieceType

final class PositionTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNormalMove() throws {
        
    }
    
    func testEpCapture() throws {
        
    }
    
    func testPromotion() throws {
        
    }
    
    func testCastling() throws {
        
    }

    func testInitFromDto() throws {
        let fen = "3qk3/r7/1n2b3/2p5/4P3/2B5/3N4/3QK2R w K c6 180 20"
        let dto = try ChessLib.Notation.parseFen(fen: fen)
        let position = try Position(positionDto: dto)
        XCTAssertEqual(Player.white, position.playerToMove)
        XCTAssertEqual(whiteKingside, position.castlingRights)
        XCTAssertEqual(42, position.epSquare)
        for sqNum in 0...63 {
            let piece = position.board[sqNum]
            switch sqNum {
            case 3:
                XCTAssertEqual(Piece(.white, .queen), piece)
            case 4:
                XCTAssertEqual(Piece(.white, .king), piece)
            case 7:
                XCTAssertEqual(Piece(.white, .rook), piece)
            case 11:
                XCTAssertEqual(Piece(.white, .knight), piece)
            case 18:
                XCTAssertEqual(Piece(.white, .bishop), piece)
            case 28:
                XCTAssertEqual(Piece(.white, .pawn), piece)
            case 34:
                XCTAssertEqual(Piece(.black, .pawn), piece)
            case 41:
                XCTAssertEqual(Piece(.black, .knight), piece)
            case 44:
                XCTAssertEqual(Piece(.black, .bishop), piece)
            case 48:
                XCTAssertEqual(Piece(.black, .rook), piece)
            case 59:
                XCTAssertEqual(Piece(.black, .queen), piece)
            case 60:
                XCTAssertEqual(Piece(.black, .king), piece)
            default:
                XCTAssertEqual(Piece(nil, .none), piece)
            }
        }
    }
}
