//
//  File.swift
//  
//
//  Created by Tony on 09/02/2024.
//

import Foundation

extension Position {
    func generateMoves(player: Player) -> [Move] {
        for squareNum in 0...63 {
            let piece = self.board[squareNum]
            if piece.owner != player {
                continue
            }
            
            switch piece.type {
            case .king:
                break
            case .queen:
                break
            case .rook:
                break
            case .bishop:
                break
            case .knight:
                break
            case .pawn:
                break
            case .none:
                break
            }
        }
        
        return []
    }
}
