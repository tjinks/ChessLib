//
//  File.swift
//  
//
//  Created by Tony on 26/04/2024.
//

import Foundation

struct MajorPieceAndKingVsKingEvaluator : Evaluator {
    func isApplicable(position: Position) -> Bool {
        var majorPieceCount = 0
        var otherPieceCount = 0
        try! forAllSquares(){
            switch position[$0].type {
            case .rook, .queen:
                majorPieceCount += 1
                return majorPieceCount < 2
            case .none, .king:
                return true
            default:
                otherPieceCount += 1
                return false
            }
        }
        
        return majorPieceCount == 1 && otherPieceCount == 0
    }
    
    func evaluate(position: Position) -> Double {
        let playerToMove = position.playerToMove
        let attacker = {
            if evaluateMaterial(position) > drawEvaluation {
                return playerToMove
            } else {
                return playerToMove.other
            }
        }()
        
        let attackingKingSquare = position.kingSquare[attacker.index]
        let defendingKingSquare = position.kingSquare[attacker.other.index]
        let edScore = 8.0 - edgeDistance(defendingKingSquare)
        let kdScore = 8.0 - distanceBetween(from: attackingKingSquare, to: defendingKingSquare)
        let result = 10.0 * edScore + kdScore
        return playerToMove == attacker ? result : -result
    }
}
