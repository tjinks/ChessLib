//
//  File.swift
//  
//
//  Created by Tony on 25/04/2024.
//

import Foundation

let majorPieceAndKingVsKingEvaluator = MajorPieceAndKingVsKingEvaluator()

struct Progress {
    var currentMove: Move?
    var numberOfPositionsAnalysed: Int
    var depth: Int
    
    init() {
        currentMove = nil
        numberOfPositionsAnalysed = 0
        depth = 1
    }
}

class Aba {
    private let maxPlySupported = 10
    
    private var maxPly = 1
    private var ply = 0
    private var bestScore: [Double]
    private var killer: [Move?]
    private var progress: Progress = Progress()
    private var bestMove: Move?
    
    init() {
        bestScore = [Double](repeating: 0, count: maxPlySupported)
        killer = [Move?](repeating: nil, count: maxPlySupported)
    }
    
    private func analyse(gameState: GameState) -> Double {
        let position = gameState.currentPosition
        let moves = MoveGenerator.run(position: position, player: position.playerToMove)
        if let terminalScore = checkTerminal(gameState: gameState, moves: moves) {
            return terminalScore
        }
        
        let movesToTry = getMovesToTry(position: position, moves: moves)
        for i in 0..<movesToTry.count {
            let move = movesToTry[i]
            bestScore[ply] = -Double.greatestFiniteMagnitude

            gameState.makeMove(move)
            ply += 1
            let score = -analyse(gameState: gameState)
            ply -= 1
            gameState.retractLastMove()

            if score > bestScore[ply] {
                bestScore[ply] = score
                if ply == 0 {
                    bestMove = move
                } else {
                    if score > -bestScore[ply - 1] {
                        killer[ply] = move
                        return score
                    }
                }
            }
        }
        
        return bestScore[ply]
    }
    
    private func getMovesToTry(position: Position, moves: [Move]) -> MoveList {
        var result = MoveList()
        for m in moves {
            var score = 0.0
            if m == killer[ply] {
                score = 3.0
            } else if m.isCapture(position) {
                score = 2.0
            } else if m.isCastles {
                score = 1.0
            }
            
            result.add(move: m, score: score)
        }
        
        result.sort()
        return result
    }
    
    private func checkTerminal(gameState: GameState, moves: [Move]) -> Double? {
        if gameState.getRepetitionCount() == 3 {
            return drawEvaluation
        }
        
        if gameState.halfMoveClock == 0 {
            return drawEvaluation
        }
        
        let position = gameState.currentPosition
        if moves.isEmpty {
            if position.isInCheck(player: position.playerToMove) {
                return lossEvaluation + Double(ply)
            } else {
                return drawEvaluation
            }
        }
        
        if ply == maxPly {
            return evaluatePosition(position)
        }
        
        return nil
    }
    
    private func evaluatePosition(_ position: Position) -> Double {
        let evaluationFunc = selectEvaluationFunc(position: position)
        return evaluationFunc(position)
    }
    
    private func selectEvaluationFunc(position: Position) -> EvaluationFunc {
        if majorPieceAndKingVsKingEvaluator.isApplicable(position: position) {
            return majorPieceAndKingVsKingEvaluator.evaluate
        }
        
        return { _ in return 0.0 }
    }
}
