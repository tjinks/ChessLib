//
//  File.swift
//  
//
//  Created by Tony on 29/03/2024.
//

import Foundation

open class EventHandlerBase: EventHandler {
    weak var dispatcher: EventDispatcher?
    
    public init(dispatcher: EventDispatcher) {
        self.dispatcher = dispatcher
        dispatcher.register(self)
    }
    
    open func processEvent(_ event: Event) {
    }
    
    public func raiseEvent(_ event: Event) {
        dispatcher?.dispatch(event)
    }
    
    deinit {
        dispatcher?.deregister(self)
    }
}
