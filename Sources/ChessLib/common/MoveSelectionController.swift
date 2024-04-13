//
//  File.swift
//  
//
//  Created by Tony on 04/04/2024.
//

import Foundation

public struct SquareClicked {
    public let square: Int
    
    public init(square: Int) {
        self.square = square
    }
}

struct StartHumanMoveSelection {
    let gameState: GameState
}

class MoveSelectionController : EventHandlerBase {
    private enum State {
        case inactive
        case beforeInitialSquareSelected, afterInitialSquareSelected
    }
    
    private var gameState: GameState?
    private var potentialMoves: [Move]?
    
    private var state = State.inactive
    private var initialSquare: Int = -1
    
    override func processEvent(_ event: Any) {
        if let squareClicked = event as? SquareClicked {
            processClick(square: squareClicked.square)
        } else if let startHumanMoveSelection = event as? StartHumanMoveSelection {
            if state == .inactive {
                self.gameState = startHumanMoveSelection.gameState
                state = .beforeInitialSquareSelected
            }
        }
    }
 
    private func processClick(square: Int) {
        switch state {
        case .inactive:
            break
        case .beforeInitialSquareSelected:
            potentialMoves = getMovesStartingFrom(square)
            if potentialMoves!.count > 0 {
                var highlights = potentialMoves!.map { return $0.to }
                highlights.append(square)
                state = .afterInitialSquareSelected
                raiseEvent(UiEvent.showHighlights(highlights: highlights))
            }
        case .afterInitialSquareSelected:
            if let move = getMoveEndingAt(square) {
                //TODO - show highlights
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
