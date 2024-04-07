//
//  File.swift
//  
//
//  Created by Tony on 03/02/2024.
//

import Foundation

class GameState {
    struct HistoryItem {
        let position: Position
        let isRepetitionBoundary: Bool
        let halfMoveClock: Int
        let positionHash: Int
    }

    let initialFullMove: Int

    private var history: [HistoryItem]
    
    init(initialPosition: Position, initialHalfMoveClock: Int, initialFullMove: Int) {
        let startOfHistory = HistoryItem(
            position: initialPosition,
            isRepetitionBoundary: true,
            halfMoveClock: initialHalfMoveClock,
            positionHash: initialPosition.hashValue
        )
        
        history = [startOfHistory]
        self.initialFullMove = initialFullMove
    }
    
    convenience init(dto: GameStateDto) throws {
        let position = try Position(dto: dto)
        self.init(initialPosition: position, initialHalfMoveClock: dto.halfMoveClock, initialFullMove: dto.fullMove)
    }
    
    func getHistory() -> [HistoryItem] {
        return history
    }
    
    @discardableResult func makeMove(_ move: Move) -> Position {
        let newPosition = currentPosition.makeMove(move)
        let restartsClock = move.isCapture(currentPosition) || move.isPawnMove(currentPosition)
        let halfMoveClock = restartsClock ? 0 : halfMoveClock + 1
        let isRepetionBoundary = restartsClock || newPosition.castlingRights != currentPosition.castlingRights
        let historyItem = HistoryItem(position: newPosition,
                                      isRepetitionBoundary: isRepetionBoundary,
                                      halfMoveClock: halfMoveClock,
                                      positionHash: newPosition.hashValue)
        history.append(historyItem)
        return newPosition
    }
    
    @discardableResult func retractLastMove() -> Position? {
        if history.count > 1 {
            history.removeLast()
            return currentPosition
        } else {
            return nil
        }
    }
    
    func getRepetitionCount() -> Int {
        var result = 1
        let hash = currentPosition.hashValue
        var historyIndex = history.count - 2
        while historyIndex >= 0 {
            let historyItem = history[historyIndex]
            if historyItem.positionHash == hash {
                if historyItem.position == currentPosition {
                    result += 1
                }
            }
            
            if historyItem.isRepetitionBoundary {
                break
            }
            
            historyIndex -= 1
        }
        
        return result
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
        let incr = {
            if initialPosition.playerToMove == .white {
                return (history.count - 1) / 2
            } else {
                return history.count / 2
            }
        }()
        
        return initialFullMove + incr
    }
}
