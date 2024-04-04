//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

public enum Event {
    // General events
    case startUp
    case shutdownRequested
    
    // Events from UI to game controller
    case setGameState(fen: String)
    
    // Events from UI to human move selection controller
    case squareClicked(square: Int)
    
    // Events from move selection controller to game controller
    case moveSelected(move: Move)
    
    // Events from controller to UI
    case showGameState(state: GameStateDto)
    case moveMade(stateBefore: GameStateDto, stateAfter: GameStateDto)
    case gameOver(result: Result)
    case showError(message: String)
    case confirm(message: String, callback: (Bool) -> ())
    case showPromotionDialog(callback: (Piece) -> ())
}
