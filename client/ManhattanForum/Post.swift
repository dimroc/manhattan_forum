//
//  Post.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/4/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation

class Post: PFObject, PFSubclassing {
    @NSManaged var author: String
    @NSManaged var type: String
    @NSManaged var message: String
    @NSManaged var color: String?
    @NSManaged var location: PFGeoPoint
    @NSManaged var locality: String
    @NSManaged var sublocality: String
    @NSManaged var neighborhood: String
    @NSManaged var image: PFFile
    @NSManaged var video: PFFile

    override class func load() {
        self.registerSubclass()
    }

    class func parseClassName() -> String! {
        return "Post"
    }

    var neighborhoodDescription: String! {
        get { return "\(neighborhood), \(sublocality)" }
    }
}