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

public struct SetRunMode {
    public let runMode: RunMode
    
    public init(_ runMode: RunMode) {
        self.runMode = runMode
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
        _ = MoveSelectionController(dispatcher: dispatcher)
        processSetGameState(Notation.initialPosition)
    }
    
    override public func processEvent(_ event: Any) {
        if let setGameState = event as? SetGameState {
            processSetGameState(setGameState.fen)
        } else if let moveSelected = event as? MoveSelected {
            let move = moveSelected.move
            gameState!.makeMove(move)
            raiseEvent(UiEvent.showGameState(state: gameState!.toDto()))
        } else if let setRunMode = event as? SetRunMode {
            
        }
        
        
    }
    
    private func processSetRunMode(runMode: RunMode) {
        switch state {
        default:
            return
        }
    }
    
    private func processMoveSelected(move: Move) {
        switch state {
        case .humanMoveSelectionInProgress:
            gameState!.makeMove(move)
            // TODO - check for end of game here
            
            raiseEvent(UiEvent.showGameState(state: gameState!.toDto()))
            if mode == .humanVsHuman {
                raiseEvent(StartHumanMoveSelection(gameState: gameState!))
            } else {
                // TODO
            }
        default:
            // TODO
            break
        }
    }
    
    private func processSetGameState(_ fen: String) {
        // TODO - need to put up warning dialog here if not in notPlaying state?)
        do {
            let dto = try Notation.parseFen(fen: fen)
            gameState = try GameState(dto: dto)
            raiseEvent(UiEvent.showGameState(state: dto))
            raiseEvent(StartHumanMoveSelection(gameState: gameState!))
        } catch ChessError.invalidFen, ChessError.missingKing, ChessError.duplicateKing {
            raiseEvent(UiEvent.showError(message: "Invalid FEN"))
        } catch {
            raiseEvent(UiEvent.showError(message: "An unexpected error has occurred"))
        }
    }
}
