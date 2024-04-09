//
//  File.swift
//  
//
//  Created by Tony on 29/03/2024.
//

import Foundation

public struct SetGameState {
    public let fen: String
    
    public init(fen: String) {
        self.fen = fen
    }
}

struct MoveSelected {
    let move: Move
}

public class GameController: EventHandlerBase {
    private enum State {
        case notPlaying
        case humanMoveSelectionInProgress
        case computerMoveSelectionInProgress
    }
    
    private var state = State.notPlaying
    private var mode = RunMode.humanVsHuman
    private var gameState: GameState?
    
    override public init(dispatcher: EventDispatcher) {
        super.init(dispatcher: dispatcher)
        processSetGameState(Notation.initialPosition)
    }
    
    override public func processEvent(_ event: Any) {
        if let setGameState = event as? SetGameState {
            processSetGameState(setGameState.fen)
        }
    }
    
    private func processSetGameState(_ fen: String) {
        do {
            let dto = try Notation.parseFen(fen: fen)
            gameState = try GameState(dto: dto)
            raiseEvent(UiEvent.showGameState(state: dto))
        } catch ChessError.invalidFen, ChessError.missingKing, ChessError.duplicateKing {
            raiseEvent(UiEvent.showError(message: "Invalid FEN"))
        } catch {
            raiseEvent(UiEvent.showError(message: "An unexpected error has occurred"))
        }
    }
}
