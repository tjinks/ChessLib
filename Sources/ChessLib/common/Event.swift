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
    
    // Events from UI to controller
    case setPosition(initialState: GameStateDto)
    case squareClicked(file: Int, rank: Int)
    
    // Events from controller to UI
    case moveMade(stateBefore: GameStateDto, stateAfter: GameStateDto)
    case gameOver(result: Result)
    case showError(message: String)
    case confirm(message: String, callback: (Bool) -> ())
    case showPromotionDialog(callback: (Piece) -> ())
}
