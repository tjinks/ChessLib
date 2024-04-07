//
//  File.swift
//  
//
//  Created by Tony on 29/03/2024.
//

import Foundation

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
        setGameState(Notation.initialPosition)
    }
    
    override public func processEvent(_ event: Event) {
        switch event {
        case .setGameState(let fen):
            setGameState(fen)
        default:
            return
        }
    }
    
    private func setGameState(_ fen: String) {
        do {
            let dto = try Notation.parseFen(fen: fen)
            gameState = try GameState(dto: dto)
            raiseEvent(.showGameState(state: dto))
        } catch ChessError.invalidFen, ChessError.missingKing, ChessError.duplicateKing {
            raiseEvent(.showError(message: "Invalid FEN"))
        } catch {
            raiseEvent(.showError(message: "An unexpected error has occurred"))
        }
    }
}
