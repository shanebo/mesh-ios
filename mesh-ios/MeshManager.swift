//
//  MeshManager.swift
//  mesh-ios
//
//  Created by Joe Osburn on 10/22/17.
//  Copyright © 2017 Mesh. All rights reserved.
//

import Foundation

public class MeshManager: NSObject {
    public static var sharedManager = MeshManager()

    public var controller = MeshController()
    var reachability = Reachability()!
    var online = true
    
    public override init() {
        super.init()
        
        reachability.whenReachable = { reachability in
            if !self.online {
                self.emit("online")
                self.online = true
            }
        }
        reachability.whenUnreachable = { _ in
            if self.online {
                self.emit("offline")
                self.online = false
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            NSLog("Unable to start Reachability notifier")
        }
    }
    
    public func emit(_ action: String) {
        mesh(event: "_emit", type: "\"\(action)\"")
    }
    
    func callback(_ callback: Int, with params: Dictionary<String,AnyObject> = [:]) {
        mesh(event: "_callback", type: "\(callback)", with: params)
    }
    
    func mesh(event: String, type: String, with params: Dictionary<String,AnyObject> = [:]) {
        controller.sendResponse(aResponse: params, callback: "mesh.\(event)(\(type)")
    }
}

