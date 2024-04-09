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
            break
        case .afterInitialSquareSelected:
            break
        }
    }
    
    private func getMovesStartingFrom(_ square: Int) -> [Move] {
        let position = gameState!.currentPosition
        let moveList = MoveGenerator.run(position: position, player: position.playerToMove)
        return moveList.getMoves(position: position).filter {
            switch $0 {
            case .whiteCastlesLong, .whiteCastlesShort:
                return square == e1
            case .blackCastlesLong, .blackCastlesShort:
                return square == e8
            case .normal(let from, _, _):
                return square == from
            }
        }
    }
    
    private static func getMovesEndingAt(moves: [Move], square: Int) -> [Move] {
        return moves.filter {
            switch $0 {
            case .whiteCastlesLong:
                return square == c1
            case .whiteCastlesShort:
                return square == g1
            case .blackCastlesLong:
                return square == c8
            case .blackCastlesShort:
                return square == g8
            case .normal(_, let to, _):
                return square == to
            }
        }
    }
}
