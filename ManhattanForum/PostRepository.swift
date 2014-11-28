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
    // Author
    // Message
    // Location
    // Locality
    // State
    // Image (Optional)
    // Video or PFFile (Optional)
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
            
            file.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                if(succeeded) {
                    post["image"] = file
                    post.saveEventually()
                } else {
                    println("## IMAGE ERROR")
                    println("## \(error.description)")
                }
            })
        } else {
            post.saveEventually()
        }
    }
}