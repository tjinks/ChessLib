//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

public class EventHandler {
    private let dispatcher: EventDispatcher
    
    public init(dispatcher: EventDispatcher) {
        self.dispatcher = dispatcher
        self.dispatcher.register(self)
    }
    
    deinit {
        self.dispatcher.deregister(self)
    }
    
    public func processEvent(_ event: Any) -> Bool {
        return false
    }

    public func raiseEvent(_ event: Any) {
        dispatcher.dispatch(event)
    }
}
