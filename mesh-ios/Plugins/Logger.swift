//
//  Logger.swift
//  mesh-ios
//
//  Created by Joe Osburn on 10/22/17.
//  Copyright © 2017 Mesh. All rights reserved.
//

import Foundation

class Logger: NSObject {
    static var sharedInstance = Logger()
    
    func log(_ arguments: [Any]) {
        print("\(arguments.map { "\($0)" }.joined(separator: " "))")
    }
    
}
