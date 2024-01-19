//
//  File.swift
//
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public struct Square: CustomStringConvertible, Equatable, Hashable {
    public let  rank: Int
    public let file: Int
    
    private init(file: Int, rank: Int) {
        self.rank = rank
        self.file = file
    }
    
    public static func get(file: Int, rank: Int) throws -> Square {
        return try SquareFactory.get(file: file, rank: rank)
    }
    
    public static func get(_ name: String) throws -> Square {
        return try SquareFactory.get(name)
    }
    
    public static func getAll() -> [Square] {
        return SquareFactory.getAll()
    }
    
    public var description: String {
        let fileChars = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let rankChars = ["1", "2", "3", "4", "5", "6", "7", "8"]
        return fileChars[file] + rankChars[rank]
    }
    
    private class SquareFactory {
        static let instance: SquareFactory = SquareFactory()
        
        public let allSquares: [Square]
        
        private init() {
            var tmp:[Square] = []
            for i in 0...63 {
                let file = i % 8
                let rank = i / 8
                tmp.append(Square(file: file, rank: rank))
            }
            
            allSquares = tmp
        }
        
        static func get(file: Int, rank: Int) throws -> Square {
            if rank < 0 || rank >= 8 || file < 0 || file >= 8 {
                throw ChessError.invalidSquare
            }
            
            return instance.allSquares[rank * 8 + file]
        }
        
        static func getAll() -> [Square] {
            return instance.allSquares
        }
        
        static func get(_ name: String) throws -> Square {
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
            
            return try get(file: file, rank: rank)
        }
    }

}
