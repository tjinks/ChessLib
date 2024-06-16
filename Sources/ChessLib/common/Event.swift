//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation


enum Event {
    case shutdownRequested
    case shutdownInProgress
    case setGameState(fen: String)
    case startGame
    case setRunMode(runMode: RunMode)
    case showGameState(game: EngGame)
    case showHighlights(highlights: [Int])
    case gameOver(result: EngGameResult)
    case showError(message: String)
    case confirm(message: String, callback: (Bool) -> ())
    case showPromotionDialog
    case promoteTo(piece: EngPieceType)
    case squareClicked(square: Int)
    case moveSelected(move: EngMove)
    case startHumanMoveSelection(game: EngGame)
}
