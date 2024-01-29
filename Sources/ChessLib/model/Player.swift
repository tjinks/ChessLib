//
//  File.swift
//  
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public enum Player: Int8 {
    case white = 0, black = 1
}

public extension Player {
    var other: Player {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }
}
