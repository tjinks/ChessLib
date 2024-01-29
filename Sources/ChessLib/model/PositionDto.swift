//
//  File.swift
//  
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public typealias Pieces = Dictionary<Square, Piece>

public class PositionDto {
    public var pieces: Pieces = [:]
    
    public var activePlayer: Player = .white
    
    public var castlingRights: Set<CastlingRight> = []
    
    public var epSquare: Square? = nil
    
    public var halfMoveClock: Int = 0
    
    public var fullMove: Int = 0
    
    public init() {
    }
    
    public static let initialPosition = try! Notation.parseFen(fen: Notation.initialPosition)
}
