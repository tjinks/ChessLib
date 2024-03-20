//
//  File.swift
//  
//
//  Created by Tony on 19/03/2024.
//

import Foundation

public struct GameStateDto {
    public var board: [Piece]
    
    public var playerToMove: Player
    
    public var whiteCanCastleShort: Bool
    
    public var whiteCanCastleLong: Bool
    
    public var blackCanCastleShort: Bool
    
    public var blackCanCastleLong: Bool
    
    public var epSquare: Square?
    
    public var halfMoveClock: Int
    
    public var fullMove: Int
}
