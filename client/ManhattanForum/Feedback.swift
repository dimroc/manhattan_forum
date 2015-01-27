//
//  Feedback.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/27/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation

class Feedback: PFObject, PFSubclassing {
    @NSManaged var email: String
    @NSManaged var message: String
    @NSManaged var image: PFFile
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Feedback"
    }
}