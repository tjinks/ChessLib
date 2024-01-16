//
//  File.swift
//  
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public class SquareFactory {
    static let instance: SquareFactory = SquareFactory()
    
    public let allSquares: [Square]
    
    private init() {
        var tmp:[Square] = []
        for i in 0...63 {
            let file = i % 8
            let rank = i / 8
            tmp.append(Square(rank: rank, file:file))
        }
        
        allSquares = tmp
    }
    
    public static func get(file: Int, rank: Int) -> Square {
        return instance.allSquares[rank * 8 + file]
    }
    
    public static func getAll() -> [Square] {
        return instance.allSquares
    }
    
    public static func get(_ name: String) throws -> Square {
        if name.count != 2 {
            throw ChessError.invalidSquare
        }
        
        let fileChar = name[name.startIndex]
        let rankChar = name[name.index(after: name.startIndex)]
        var file = -1
        var rank = -1
        if fileChar.isASCII {
            file = Int(fileChar.asciiValue!) - Int(Character("a").asciiValue!)
        }
        
        if rankChar.isASCII {
            rank = Int(rankChar.asciiValue!) - Int(Character("1").asciiValue!)
        }
        
        if rank < 0 || rank >= 8 || file < 0 || file >= 8 {
            throw ChessError.invalidSquare
        }
        
        return get(file: file, rank: rank)
    }
}
