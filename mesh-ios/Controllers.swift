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

public class Controllers: NSObject {
    private static var _manager: Controllers?
    static var manager: Controllers {
        get {
            if _manager == nil {
                _manager = Controllers()
                _manager!.register("Logger", "log") { Logger.sharedInstance.log($0) }
            }
            
            return _manager!
        }
    }
    
    private var controllers = [String: [String: Action]]()
    
    override init() {
        super.init()
    }
    
    public func register(_ controllerName: String, _ actionName: String, caller: @escaping (_ arguments: [Any]) -> Void) {
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
