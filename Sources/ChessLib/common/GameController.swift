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

public class GameController {
    private let dispatcher: EventDispatcher
    private var mode = RunMode.humanVsHuman
    private var gameState: GameState? = nil
    private var state = noopEventHandler
    
    public init(dispatcher: EventDispatcher) {
        self.dispatcher = dispatcher
        dispatcher.register(processEvent)
        _ = MoveSelectionController(dispatcher: dispatcher)
        state = notPlaying
        processEvent(GlobalEvent.setGameState(fen: Notation.initialPosition))
    }
    
    private func processEvent(_ event: Any) {
        state(event)
        /*
        if let setGameState = event as? SetGameState {
            processSetGameState(setGameState.fen)
        } else if let moveSelected = event as? MoveSelected {
            let move = moveSelected.move
            gameState!.makeMove(move)
            dispatcher.dispatch(GlobalEvent.showGameState(state: gameState!.toDto()))
        } else if let setRunMode = event as? SetRunMode {
            
        }
        */
        
    }
    
    private func notPlaying(event: Any) {
        if let event = event as? GlobalEvent {
            switch event {
            case .setGameState(let fen):
                processSetGameState(fen)
            case .setRunMode(let runMode):
                mode = runMode
            case .startGame:
                state = playingHumanVsHuman
                dispatcher.dispatch(InternalEvent.startHumanMoveSelection(gameState: gameState!))
            default:
                break
            }
        }
    }
    
    private func playingHumanVsHuman(event: Any) {
        let gameState = gameState!
        if let event = event as? InternalEvent {
            switch event {
            case .moveSelected(let move):
                gameState.makeMove(move)
                dispatcher.dispatch(GlobalEvent.showGameState(state: gameState.toDto()))
                let result = gameState.getResult()
                if result != .none {
                    dispatcher.dispatch(GlobalEvent.gameOver(result: result))
                    state = notPlaying
                } else {
                    dispatcher.dispatch(InternalEvent.startHumanMoveSelection(gameState: gameState))
                }
            default:
                break
            }
        }
    }
    
    private func processMoveSelected(move: Move) {
        switch state {
        default:
            // TODO
            break
        }
    }
    
    private func processSetGameState(_ fen: String) {
        do {
            let dto = try Notation.parseFen(fen: fen)
            gameState = try GameState(dto: dto)
            dispatcher.dispatch(GlobalEvent.showGameState(state: dto))
        } catch ChessError.invalidFen, ChessError.missingKing, ChessError.duplicateKing {
            dispatcher.dispatch(GlobalEvent.showError(message: "Invalid FEN"))
        } catch {
            dispatcher.dispatch(GlobalEvent.showError(message: "An unexpected error has occurred"))
        }
    }
}
