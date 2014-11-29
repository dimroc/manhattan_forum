//
//  PostRepository.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 11/28/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

class PostRepository {
    // Items needed for post:
    // Author (TODO)
    // Message
    // Location
    // Locality
    // State
    // Image
    // Video
    // Timestamp (included with PFObject)
    class func create(message: String, location: MFLocation) {
        create(message, location: location, withImage: nil)
    }
    
    class func create(message: String, location: MFLocation, withImage: UIImage?) {
        var post = PFObject(className: "Post")
        post["message"] = message
        post["location"] = PFGeoPoint(latitude: location.coordinate!.latitude, longitude: location.coordinate!.longitude)
        post["neighborhood"] = location.neighborhood
        post["locality"] = location.locality
        post["sublocality"] = location.sublocality
        
        if let image = withImage {
            let imageData = UIImageJPEGRepresentation(image, 0.7)
            let file = PFFile(data: imageData, contentType: "image/jpg")
            // video/quicktime for video
            
            file.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                if(succeeded) {
                    post["type"] = "image"
                    post["image"] = file
                    post.saveEventually()
                } else {
                    println("## IMAGE POST ERROR")
                    println("## \(error.description)")
                }
            })
        } else {
            post["type"] = "message"
            post.saveEventually()
        }
    }
    
    class func create(message: String, location: MFLocation, withVideo: NSURL!) {
        var post = PFObject(className: "Post")
        post["message"] = message
        post["location"] = PFGeoPoint(latitude: location.coordinate!.latitude, longitude: location.coordinate!.longitude)
        post["neighborhood"] = location.neighborhood
        post["locality"] = location.locality
        post["sublocality"] = location.sublocality
        
        let videoAsset = VideoAsset(url: withVideo)
        videoAsset.fixOrientation()
        let videoData = videoAsset.getData()
        let file = PFFile(data: videoData, contentType: "video/quicktime")
        
        file.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
            if(succeeded) {
                post["type"] = "video"
                post["video"] = file
                post.saveEventually()
            } else {
                println("## VIDEO POST ERROR")
                println("## \(error.description)")
            }
        })
    }
}