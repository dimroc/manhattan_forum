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
    // Color
    // Location
    // Locality
    // Image
    // Video
    // Timestamp (included with PFObject)
    class func createAsync(message: String, color: UIColor, location: MFLocation) -> BFTask {
        var post = preparePost(message, color: color, location: location)
        post.type = "message"
        return post.saveEventuallyAsTask()
    }
    
    class func createAsync(message: String, color: UIColor, location: MFLocation, withImage: UIImage?) -> BFTask {
        if let image = withImage {
            var post = preparePost(message, color: color, location: location)
            let imageData = UIImageJPEGRepresentation(image, 1)
            let file = PFFile(data: imageData, contentType: "image/jpg")
        
            return file.saveInBackground().continueWithSuccessBlock({ (task: BFTask!) -> AnyObject! in
                post.type = "image"
                post.image = file
                return post.saveEventuallyAsTask()
            })
        } else {
            return createAsync(message, color: color, location: location)
        }
    }
    
    class func createAsync(message: String, color: UIColor, location: MFLocation, withImage: UIImage!, withVideo: NSURL!) -> BFTask! {
        var post = preparePost(message, color: color, location: location)
        
        let imageData = UIImageJPEGRepresentation(withImage, 1)
        let imageFile = PFFile(data: imageData, contentType: "image/jpg")
        
        let videoData = NSData.dataWithContentsOfMappedFile(withVideo.path!) as NSData
        let videoFile = PFFile(data: videoData, contentType: "video/quicktime")
        
        let parallelTasks: NSMutableArray = [imageFile.saveInBackground(), videoFile.saveInBackground()]
        return BFTask(forCompletionOfAllTasks: parallelTasks).continueWithSuccessBlock({ (task) -> AnyObject! in
            post.type = "video"
            post.image = imageFile
            post.video = videoFile
            return post.saveEventuallyAsTask()
        })
    }
    
    private class func preparePost(message: String, color: UIColor, location: MFLocation) -> Post! {
        var post = Post()
        post.message = message
        post.color = color.hexString()
        post.location = PFGeoPoint(latitude: location.coordinate!.latitude, longitude: location.coordinate!.longitude)
        post.neighborhood = location.neighborhood!
        post.locality = location.locality!
        post.sublocality = location.sublocality!
        return post;
    }
}