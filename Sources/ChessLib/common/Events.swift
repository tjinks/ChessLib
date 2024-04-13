//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

public struct ShutdownRequested {
    public init() {}
}

public struct ShutdownInProgress {
    public init() {}
}

public enum UiEvent {
    case showGameState(state: GameStateDto)
    case showHighlights(highlights: [Int])
    case gameOver(result: Result)
    case showError(message: String)
    case confirm(message: String, callback: (Bool) -> ())
    case showPromotionDialog(callback: (Piece) -> ())
}
