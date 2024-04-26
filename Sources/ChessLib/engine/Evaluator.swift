//
//  File.swift
//
//
//  Created by Tony on 25/04/2024.
//

import Foundation

let winEvaluation = 1e6
let lossEvaluation = -winEvaluation
let drawEvaluation = 0.0

let queenValue = 9.0
let rookValue = 5.0
let bishopValue = 3.1
let knightValue = 3.0
let pawnValue = 1.0

typealias EvaluationFunc = (Position) -> Double

protocol Evaluator {
    func isApplicable(position: Position) -> Bool
    func evaluate(position: Position) -> Double
}

func distanceBetween(from: Int, to: Int) -> Double {
    let dx = abs(from.file - to.file)
    let dy = abs(from.rank - to.rank)
    return Double(max(dx, dy))
}

func edgeDistance(_ square: Int) -> Double {
    var result = 7 - square.rank
    result = min(result, square.rank)
    result = min(result, 7 - square.file)
    result = min(result, square.file)
    return Double(result)
}

func evaluateMaterial(_ position: Position) -> Double {
    var result = 0.0
    try! forAllSquares() {
        var inc = 0.0
        let piece = position[$0]
        switch piece.type {
        case .none:
            break
        case .king:
            break
        case .queen:
            inc = queenValue
        case .rook:
            inc = rookValue
        case .bishop:
            inc = bishopValue
        case .knight:
            inc = knightValue
        case .pawn:
            inc = pawnValue
        }
        
        if position.playerToMove == piece.owner {
            result += inc
        } else {
            result -= inc
        }
        
        return true
    }
    
    return result
}
