//
//  ContentView.swift
//  Chess
//
//  Created by Tony on 19/01/2024.
//

import SwiftUI
import ChessLib

typealias Square = ChessLib.Square
typealias PositionDto = ChessLib.PositionDto
typealias Piece = ChessLib.Piece
typealias Notation = ChessLib.Notation

struct ContentView: View {
    let fen1 = "7k/8/6KP/8/8/8/8/8 w"
    let fen2 = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w"
    
    @State private var positionDto: PositionDto
    
    
    init() {
        positionDto = try! Notation.parseFen(fen: fen1)
    }
    
    private func getImage(file: Int, rank: Int) -> Image {
        let square = try! Square.get(file: file, rank: rank)
        var namePrefix: String = "E"
        if let piece = positionDto.pieces[square] {
            namePrefix = {
                switch(piece) {
                case .blackBishop: return "BB"
                case .blackKing: return "BK"
                case .blackKnight: return "BN"
                case .blackPawn: return "BP"
                case .blackQueen: return "BQ"
                case .blackRook: return "BR"
                case .whiteBishop: return "WB"
                case .whiteKing: return "WK"
                case .whiteKnight: return "WN"
                case .whitePawn: return "WP"
                case .whiteQueen: return "WQ"
                case .whiteRook: return "WR"
                }
            }()
        }
        
        var imageName: String
        if (rank + file) % 2 == 0 {
            imageName = namePrefix + "B"
        } else {
            imageName = namePrefix + "W"
        }
        
        return Image(imageName)
    }
    
    var body: some View {
        BoardView().padding()
    }
}

#Preview {
    ContentView()
}
