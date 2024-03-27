//
//  File.swift
//
//
//  Created by Tony on 19/03/2024.
//

import Foundation

public extension Int {
    init(file: Int, rank: Int) throws {
        let result = file + 8 * rank
        if result >= 0 && result < 64 {
            self = result
        } else {
            throw ChessError.invalidSquare
        }
    }
    
    init(name: String) throws {
        self = try Notation.parseSquareName(name: name)
    }
    
    var file: Int {
        get {
            return self % 8
        }
    }
    
    var rank: Int {
        get {
            return self / 8
        }
    }
    
    var description: String {
        get {
            return Notation.getSquareName(self)
        }
    }
}

func squareNum(file: Int, rank: Int) -> Int {
    return file + 8 * rank
}

func squareNum(name: String) throws -> Int {
    return try Notation.parseSquareName(name: name)
}

func forAllSquares(callback: (Int) throws -> Bool) throws {
    for i in 0...63 {
        if !(try callback(i)) {
            return
        }
    }
}



