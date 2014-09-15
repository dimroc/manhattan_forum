//
//  MFLocation.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/15/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

class MFLocation: Printable, DebugPrintable {
    var payload: AnyObject
    var description: String {
        return payload.description
    }
    
    var debugDescription: String {
        return payload.description
    }
    
    init(response: AnyObject) {
        payload = response
    }
}