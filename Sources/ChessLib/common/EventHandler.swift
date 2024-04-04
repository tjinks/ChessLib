//
//  File.swift
//  
//
//  Created by Tony on 29/03/2024.
//

import Foundation

public protocol EventHandler: AnyObject {
    func processEvent(_ event: Event)
}
