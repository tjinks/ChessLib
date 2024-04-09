//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

public struct ShutdownRequested {
    
}

public struct ShutdownInProgress {
    
}

public enum UiEvent {
    case showGameState(state: GameStateDto)
    case gameOver(result: Result)
    case showError(message: String)
    case confirm(message: String, callback: (Bool) -> ())
    case showPromotionDialog(callback: (Piece) -> ())
}
