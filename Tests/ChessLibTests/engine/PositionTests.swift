//
//  PositionTests.swift
//  
//
//  Created by Tony on 01/02/2024.
//

import XCTest
@testable import ChessLib

final class PositionTests: XCTestCase {
    private let positionForNormalMoveTest = "r3k2r/2P5/8/8/3pP3/8/5P2/R3K2R w kKqQ - 0 1"
    private let positionForEpCaptureTest = "r3k2r/2P5/8/8/3pP3/8/5P2/R3K2R b kKqQ e3 0 1"
    private let all = whiteKingside | blackKingside | whiteQueenside | blackQueenside
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    private func createPosition(_ fen: String) -> Position {
        let positionDto = try! Notation.parseFen(fen: fen)
        return try! Position(positionDto: positionDto)
    }
    
    func testNormalMove() throws {
        let initialPosition = createPosition(positionForNormalMoveTest)
        let move = Move(from: 13, to: 21, piece: Piece(.white, .pawn))
        let result = initialPosition.makeMove(move)
        for sqNum in 0...63 {
            switch sqNum {
            case 13:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            case 21:
                XCTAssertEqual(Piece(.white, .pawn), result.board[sqNum])
            default:
                XCTAssertTrue(result.board[sqNum] == initialPosition.board[sqNum])
            }
        }
        
        XCTAssertEqual(all, result.castlingRights)
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(4, result.kingSquare[Player.white.index])
        XCTAssertEqual(60, result.kingSquare[Player.black.index])
    }
    
    func testEpCapture() throws {
        let initialPosition = createPosition(positionForEpCaptureTest)
        let move = Move(from: 27, epSquare: 20)
        let result = initialPosition.makeMove(move)
        for sqNum in 0...63 {
            switch sqNum {
            case 27, 28:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            case 20:
                XCTAssertEqual(Piece(.black, .pawn), result.board[sqNum])
            default:
                XCTAssertTrue(result.board[sqNum] == initialPosition.board[sqNum])
            }
        }
        
        XCTAssertEqual(all, result.castlingRights)
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(4, result.kingSquare[Player.white.index])
        XCTAssertEqual(60, result.kingSquare[Player.black.index])
    }
    
    func testPromotion() throws {
        let initialPosition = createPosition(positionForNormalMoveTest)
        let move = Move(from: 50, to: 58, piece: Piece(.white, .queen))
        let result = initialPosition.makeMove(move)
        for sqNum in 0...63 {
            switch sqNum {
            case 50:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            case 58:
                XCTAssertEqual(Piece(.white, .queen), result.board[sqNum])
            default:
                XCTAssertTrue(result.board[sqNum] == initialPosition.board[sqNum])
            }
        }
        
        XCTAssertEqual(all, result.castlingRights)
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(4, result.kingSquare[Player.white.index])
        XCTAssertEqual(60, result.kingSquare[Player.black.index])
    }
    
    func testSetEpSquare() throws {
        let initialPosition = createPosition(positionForNormalMoveTest)
        let move = Move(from: 13, to: 29, piece: Piece(.white, .pawn))
        let result = initialPosition.makeMove(move)
        for sqNum in 0...63 {
            switch sqNum {
            case 13:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            case 29:
                XCTAssertEqual(Piece(.white, .pawn), result.board[sqNum])
            default:
                XCTAssertTrue(result.board[sqNum] == initialPosition.board[sqNum])
            }
        }
        
        XCTAssertEqual(all, result.castlingRights)
        XCTAssertEqual(21, result.epSquare)
        XCTAssertEqual(4, result.kingSquare[Player.white.index])
        XCTAssertEqual(60, result.kingSquare[Player.black.index])
    }
    
    func testCastlingWhiteKingside() throws {
        let initialPosition = createPosition(positionForNormalMoveTest)
        let move = Move(castles: whiteKingside)
        let result = initialPosition.makeMove(move)
        for sqNum in 0...63 {
            switch sqNum {
            case 4:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            case 5:
                XCTAssertEqual(Piece(.white, .rook), result.board[sqNum])
            case 6:
                XCTAssertEqual(Piece(.white, .king), result.board[sqNum])
            case 7:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            default:
                XCTAssertTrue(result.board[sqNum] == initialPosition.board[sqNum])
            }
        }
        
        XCTAssertEqual(blackKingside | blackQueenside, result.castlingRights)
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(6, result.kingSquare[Player.white.index])
        XCTAssertEqual(60, result.kingSquare[Player.black.index])
    }

    func testCastlingWhiteQueenside() throws {
        let initialPosition = createPosition(positionForNormalMoveTest)
        let move = Move(castles: whiteQueenside)
        let result = initialPosition.makeMove(move)
        for sqNum in 0...63 {
            switch sqNum {
            case 0:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            case 2:
                XCTAssertEqual(Piece(.white, .king), result.board[sqNum])
            case 3:
                XCTAssertEqual(Piece(.white, .rook), result.board[sqNum])
            case 4:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            default:
                XCTAssertTrue(result.board[sqNum] == initialPosition.board[sqNum])
            }
        }
        
        XCTAssertEqual(blackKingside | blackQueenside, result.castlingRights)
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(2, result.kingSquare[Player.white.index])
        XCTAssertEqual(60, result.kingSquare[Player.black.index])
    }

    func testCastlingBlackKingside() throws {
        let initialPosition = createPosition(positionForEpCaptureTest)
        let move = Move(castles: blackKingside)
        let result = initialPosition.makeMove(move)
        for sqNum in 0...63 {
            switch sqNum {
            case 60:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            case 61:
                XCTAssertEqual(Piece(.black, .rook), result.board[sqNum])
            case 62:
                XCTAssertEqual(Piece(.black, .king), result.board[sqNum])
            case 63:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            default:
                XCTAssertTrue(result.board[sqNum] == initialPosition.board[sqNum])
            }
        }
        
        XCTAssertEqual(whiteKingside | whiteQueenside, result.castlingRights)
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(4, result.kingSquare[Player.white.index])
        XCTAssertEqual(62, result.kingSquare[Player.black.index])
    }

    func testCastlingBlackQueenside() throws {
        let initialPosition = createPosition(positionForEpCaptureTest)
        let move = Move(castles: blackQueenside)
        let result = initialPosition.makeMove(move)
        for sqNum in 0...63 {
            switch sqNum {
            case 56:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            case 58:
                XCTAssertEqual(Piece(.black, .king), result.board[sqNum])
            case 59:
                XCTAssertEqual(Piece(.black, .rook), result.board[sqNum])
            case 60:
                XCTAssertEqual(Piece.none, result.board[sqNum])
            default:
                XCTAssertTrue(result.board[sqNum] == initialPosition.board[sqNum])
            }
        }
        
        XCTAssertEqual(whiteKingside | whiteQueenside, result.castlingRights)
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(4, result.kingSquare[Player.white.index])
        XCTAssertEqual(58, result.kingSquare[Player.black.index])
    }

    func testRookMoves() {
        var position = createPosition(positionForNormalMoveTest)
        var move = Move(from: 0, to: 1, piece: Piece(.white, .rook))
        position = position.makeMove(move)
        XCTAssertEqual(whiteKingside | blackKingside | blackQueenside, position.castlingRights)
        
        move = Move(from: 56, to: 57, piece: Piece(.black, .rook))
        position = position.makeMove(move)
        XCTAssertEqual(whiteKingside | blackKingside, position.castlingRights)

        move = Move(from: 7, to: 6, piece: Piece(.white, .rook))
        position = position.makeMove(move)
        XCTAssertEqual(blackKingside, position.castlingRights)

        move = Move(from: 63, to: 62, piece: Piece(.black, .rook))
        position = position.makeMove(move)
        XCTAssertEqual(0, position.castlingRights)
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
