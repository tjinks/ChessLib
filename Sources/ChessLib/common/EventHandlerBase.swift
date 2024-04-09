//
//  File.swift
//  
//
//  Created by Tony on 29/03/2024.
//

import Foundation

open class EventHandlerBase: EventHandler {
    private let dispatcher: EventDispatcher
    
    public init(dispatcher: EventDispatcher) {
        self.dispatcher = dispatcher
        dispatcher.register(self)
    }
    
    open func processEvent(_ event: Any) {
    }
    
    public func raiseEvent(_ event: Any) {
        dispatcher.dispatch(event)
    }
}
