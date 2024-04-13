//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

public class EventDispatcher {
    private var handlers: [EventHandler] = []
    private var shuttingDown = false
    
    public init() {
        
    }
    
    public func register(_ handler: EventHandler) {
        if Thread.isMainThread {
            if shuttingDown {
                return
            }
            
            for h in handlers {
                if h === handler {
                    return
                }
            }
            
            handlers.append(handler)
        } else {
            DispatchQueue.main.sync {
                register(handler)
            }
        }
    }
    
    public func deregister(_ handler: EventHandler) {
        if Thread.isMainThread {
            var tmp: [EventHandler] = []
            for h in handlers {
                if h !== handler {
                    tmp.append(h)
                }
            }
            
            handlers = tmp
        } else {
            DispatchQueue.main.sync {
                deregister(handler)
            }
        }
    }
    
    public func dispatch(_ event: Any) {
        if Thread.isMainThread {
            if shuttingDown {
                return
            }
            
            for h in handlers {
                h.processEvent(event)
            }
            
            if event is ShutdownInProgress {
                handlers = []
                shuttingDown = true
            }
        } else {
            DispatchQueue.main.async {
                self.dispatch(event)
            }
        }
    }
}
