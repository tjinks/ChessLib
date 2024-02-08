//
//  File.swift
//  
//
//  Created by Tony on 01/02/2024.
//

import Foundation

extension Position {
    func isInCheck(player: Player) -> Bool {
        let kingSquare = self.kingSquare[player.index]
        let kingSquareInfo = SquareInfo[kingSquare]
        let opponent = player.other
        
        if checkForNonSlidingAttack(from: kingSquareInfo.pawnCaptures[player.index], by: Piece(opponent, .pawn)) {
            return true
        }
        
        if checkForNonSlidingAttack(from: kingSquareInfo.knightMoves, by: Piece(opponent, .knight)) {
            return true
        }

        if checkForNonSlidingAttack(from: kingSquareInfo.kingMoves, by: Piece(opponent, .king)) {
            return true
        }

        if checkForSlidingAttack(from: kingSquareInfo.nw, by: bishopOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: kingSquareInfo.ne, by: bishopOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: kingSquareInfo.sw, by: bishopOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: kingSquareInfo.se, by: bishopOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: kingSquareInfo.north, by: rookOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: kingSquareInfo.south, by: rookOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: kingSquareInfo.east, by: rookOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: kingSquareInfo.west, by: rookOrQueen) {
            return true
        }
        
        return false

        func rookOrQueen(p: PieceType) -> Bool {
            return p.movesOrthogonally()
        }

        func bishopOrQueen(p: PieceType) -> Bool {
            return p.movesDiagonally()
        }
        
        func checkForSlidingAttack(from: Int64, by: (PieceType) -> Bool) -> Bool {
            var result = false
            from.foreach() {
                let piece = self.board[$0]
                if piece.owner == opponent {
                    result = by(piece.type)
                    return false
                } else if piece.owner == player {
                    result = false
                    return false
                }
                
                return true
            }
            
            return result
        }
        
        func checkForNonSlidingAttack(from: Int64, by: Piece) -> Bool {
            var result = false
            from.foreach() {
                let piece = self.board[$0]
                if piece == by {
                    result = true
                    return false
                }
                
                return true
            }
            
            return result
        }
    }
}
