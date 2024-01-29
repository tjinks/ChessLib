//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

enum Move {
    case normal(from: Int, to: Int)
    case epCapture(from: Int)
    case promotion(from: Int, to: Int, promoteTo: Piece)
    case castleK
    case castleQ
}
