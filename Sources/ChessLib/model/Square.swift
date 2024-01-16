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
    
    init(rank: Int, file: Int) {
        self.rank = rank
        self.file = file
    }
    
    public var description: String {
        let fileChars = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let rankChars = ["1", "2", "3", "4", "5", "6", "7", "8"]
        return fileChars[file] + rankChars[rank]
    }
}
