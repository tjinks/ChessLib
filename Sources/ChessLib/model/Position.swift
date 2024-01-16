//
//  File.swift
//  
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public struct Position {
    public private(set) var pieces: Dictionary<Square, Piece> = [:]
    
    public private(set) var activePlayer: Player = .white
    
    public private(set) var castlingRights: Set<CastlingRight> = []
    
    public private(set) var epSquare: Square? = nil
    
    public private(set) var halfMoveClock: Int = 0
    
    public private(set) var fullMove: Int = 0
}
