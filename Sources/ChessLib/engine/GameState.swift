//
//  File.swift
//  
//
//  Created by Tony on 03/02/2024.
//

import Foundation

struct GameState {
    struct HistoryItem {
        let position: Position
        let restartsClock: Bool
        let halfMoveClock: Int
        let positionHash: Int
    }

    let initialFullMove: Int

    private var history: [HistoryItem]
    
    init(initialPosition: Position, initialHalfMoveClock: Int, initialFullMove: Int) {
        let startOfHistory = HistoryItem(
            position: initialPosition,
            restartsClock: true,
            halfMoveClock: initialHalfMoveClock,
            positionHash: initialPosition.hashValue,
        )
        
        history = [startOfHistory]
        self.initialFullMove = initialFullMove
    }
    
    mutating func makeMove(move: Move) -> Position {
        let newPosition = currentPosition.makeMove(move)
        let restartsClock = move.isCapture || move.isPawnMove
        let halfMoveClock = restartsClock ? 100 : halfMoveClock - 1
        let historyItem = HistoryItem(position: newPosition,
                                      restartsClock: move.isCapture || move.isPawnMove,
                                      halfMoveClock: halfMoveClock,
                                      positionHash: newPosition.hashValue)
        history.append(historyItem)
        return newPosition
    }
    
    mutating func retractLastMove() -> Position? {
        if history.count > 0 {
            history.removeLast()
            return currentPosition
        } else {
            return nil
        }
    }
    
    var currentPosition: Position {
        return history[history.count - 1].position
    }
    
    var halfMoveClock: Int {
        return history[history.count - 1].halfMoveClock
    }
    
    var initialPosition: Position {
        return history[0].position
    }
    
    var fullMove: Int {
        var incr = {
            if initialPosition.playerToMove == .white {
                return (history.count - 1) / 2
            } else {
                return history.count / 2
            }
        }()
        
        return initialFullMove + incr
    }
}
