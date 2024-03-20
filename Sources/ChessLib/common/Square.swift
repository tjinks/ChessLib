//
//  File.swift
//  
//
//  Created by Tony on 19/03/2024.
//

import Foundation

public struct Square: Equatable, Hashable {
    public let number: Int
    
    public init(_ number: Int) throws {
        if number < 0 || number >= 64 {
            throw ChessError.invalidSquare
        }
        
        self.number = number
    }
    
    public init(file: Int, rank: Int) throws {
        try self.init(file + 8 * rank)
    }
    
    public init(name: String) throws {
        self = try Notation.parseSquareName(name: name)
    }
    
    public var file: Int {
        get {
            return number % 8
        }
    }
    
    public var rank: Int {
        get {
            return number / 8
        }
    }
    
    public var description: String {
        get {
            return Notation.getSquareName(self)
        }
    }
    
    public static func forAll(callback: (Square) throws -> Bool) throws {
        for i in 0...63 {
            if !(try callback(try! Square(i))) {
                return
            }
        }
    }
 }
