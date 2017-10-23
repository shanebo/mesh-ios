//
//  Controllers.swift
//  mesh-ios
//
//  Created by Joe Osburn on 10/22/17.
//  Copyright © 2017 Mesh. All rights reserved.
//

import Foundation

struct Action {
    var call: (_ arguments: [Any]) -> Void
}

class Controllers: NSObject {
    static var manager = Controllers()
    
    private var controllers = [String: [String: Action]]()
    
    func register(_ controllerName: String, _ actionName: String, caller: @escaping (_ arguments: [Any]) -> Void) {
        let action = Action(call: caller)
        
        if controllers[controllerName] == nil {
            controllers[controllerName] = [String: Action]()
        }
        
        controllers[controllerName]![actionName] = action
    }
    
    func has(_ controller: String, _ action: String) -> Bool {
        return controllers[controller]?[action] != nil
    }
    
    func run(_ controller: String, _ action: String, with arguments: [Any]) {
        controllers[controller]?[action]?.call(arguments)
    }
}
