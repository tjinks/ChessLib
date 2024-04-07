//
//  File.swift
//  
//
//  Created by Tony on 04/04/2024.
//

import Foundation

class MoveController : EventHandlerBase {
    private enum State {
        case inactive, beforeInitialSquareSelected, afterInitialSquareSelected
    }
    
    private var state = State.inactive
    
    /*
    override func processEvent(_ event: Event) {
        switch event {
        case .startHumanMoveSelection:
            if state == .inactive {
                state = .beforeInitialSquareSelected
            }
            
            return
        
        case .squareClicked(let square):
            if state == .inactive {
                return
            }
            
            
        }
    }
    */
}
