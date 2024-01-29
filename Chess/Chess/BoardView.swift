//
//  BoardView.swift
//  Chess
//
//  Created by Tony on 21/01/2024.
//

import SwiftUI
import ChessLib

public struct BoardView: View {
    @State private var positionDto: PositionDto =
    try! ChessLib.Notation.parseFen(fen: ChessLib.Notation.initialPosition)
    
    private let onSquareTapped: (_ square: Square) -> ()
    
    public init(onSquareTapped: @escaping (_ square: ChessLib.Square) -> ()) {
        self.onSquareTapped = onSquareTapped
    }
    
    public init() {
        onSquareTapped = { square in return }
    }
    
    public func setPosition(_ p: ChessLib.PositionDto) {
        positionDto = p
    }
           
    public func getPosition() -> ChessLib.PositionDto {
        return positionDto
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

    public var body: some View {
        VStack(spacing: -1) {
            ForEach(0..<8) {tmp in
                let rank = 7 - tmp
                HStack(spacing: -1) {
                    ForEach(0..<8) {file in
                        getImage(file: file, rank: rank).onTapGesture {
                            let square = try! ChessLib.Square.get(file: file, rank: rank)
                            onSquareTapped(square)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BoardView()
}
