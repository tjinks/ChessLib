//
//  SquareFactoryTests.swift
//
//
//  Created by Tony on 14/01/2024.
//

import XCTest
import ChessLib

final class SquareTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetByRankAndFile() throws {
        let result = try Square.get(file: 1, rank: 2)
        XCTAssertEqual(1, result.file)
        XCTAssertEqual(2, result.rank)
    }
    
    func testGetByName() throws {
        let result = try Square.get("b4");
        XCTAssertEqual(1, result.file)
        XCTAssertEqual(3, result.rank)
    }
    
    func testDescription() throws {
        let result = try Square.get("h6").description
        XCTAssertEqual("h6", result)
    }
}
