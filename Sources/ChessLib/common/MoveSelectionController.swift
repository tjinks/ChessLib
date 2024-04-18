//
//  File.swift
//  
//
//  Created by Tony on 04/04/2024.
//

import Foundation

class MoveSelectionController {
    private enum State {
        case inactive
        case beforeInitialSquareSelected, afterInitialSquareSelected
    }
    
    private var gameState: GameState?
    private var potentialMoves: [Move]?
    
    private var state = State.inactive
    private var initialSquare: Int = -1
    
    private let dispatcher: EventDispatcher
    
    init(dispatcher: EventDispatcher) {
        self.dispatcher = dispatcher
        dispatcher.register(processEvent)
    }
    
    private func processEvent(_ event: Any) {
        if let event = event as? GlobalEvent {
            switch event {
            case .squareClicked(let square):
                processClick(square: square)
            default:
                break
            }
        } else if let event = event as? InternalEvent {
            if state == .inactive {
                switch event {
                case .startHumanMoveSelection(let gameState):
                    self.gameState = gameState
                    state = .beforeInitialSquareSelected
                default:
                    break
                }
            }
        }
    }
 
    private func processClick(square: Int) {
        switch state {
        case .inactive:
            break
        case .beforeInitialSquareSelected:
            let potentialMoves = getMovesStartingFrom(square)
            if potentialMoves.count > 0 {
                var highlights = potentialMoves.map { return $0.to }
                highlights.append(square)
                self.potentialMoves = potentialMoves
                state = .afterInitialSquareSelected
                dispatcher.dispatch(GlobalEvent.showHighlights(highlights: highlights))
            } else {
                dispatcher.dispatch(GlobalEvent.showHighlights(highlights: []))
            }
        case .afterInitialSquareSelected:
            if let move = getMoveEndingAt(square) {
                state = .inactive
                dispatcher.dispatch(InternalEvent.moveSelected(move: move))
            } else {
                state = .beforeInitialSquareSelected
                processClick(square: square)
            }
        }
    }
    
    private func getMovesStartingFrom(_ square: Int) -> [Move] {
        let position = gameState!.currentPosition
        let moveList = MoveGenerator.run(position: position, player: position.playerToMove)
        return moveList.getMoves(position: position).filter {
            return $0.from == square
        }
    }
    
    private func getMoveEndingAt(_ square: Int) -> Move? {
        let m = potentialMoves!.filter {
            return $0.to == square
        }
        
        return m.count > 0 ? m[0] : nil
    }
}
