//
//  File.swift
//  
//
//  Created by Tony Jinks on 11/02/2024.
//

import Foundation

struct MoveListItem {
    let move: Move
    var score: Double
}

class MoveList {
    private var items: [MoveListItem]
    
    init() {
        items = []
    }
    
    func add(move: Move, score: Double) {
        items.append(MoveListItem(move: move, score: score))
    }
    
    var count: Int {
        return items.count
    }
    
    func getMoves(position: Position) -> [Move] {
        items.sort() {
            return $0.score > $1.score
        }
        
        var result: [Move] = []
        
        for item in items {
            let newPosition = position.makeMove(item.move)
            if !newPosition.isInCheck(player: position.playerToMove) {
                result.append(item.move)
            }
        }
        
        return result
    }
}

