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
    class func create(message: String, location: MFLocation) -> BFTask {
        return create(message, location: location, withImage: nil)
    }
    
    class func create(message: String, location: MFLocation, withImage: UIImage?) -> BFTask {
        var post = preparePost(message, location: location)
        if let image = withImage {
            let imageData = UIImageJPEGRepresentation(image, 1)
            let file = PFFile(data: imageData, contentType: "image/jpg")
        
            return file.saveInBackground().continueWithSuccessBlock({ (task: BFTask!) -> AnyObject! in
                post["type"] = "image"
                post["image"] = file
                return post.saveEventuallyAsTask()
            })
        } else {
            post["type"] = "message"
            return post.saveEventuallyAsTask()
        }
    }
    
    class func create(message: String, location: MFLocation, withVideo: NSURL!) -> BFTask! {
        var post = preparePost(message, location: location)
        let videoAsset = MFVideoAsset(withVideo)
        return videoAsset.fixOrientation().continueWithSuccessBlock { (task) -> AnyObject! in
            let response: MFVideoAssetResponse! = task.result as MFVideoAssetResponse;
            println("## Video Orientation Fixed to \(response.url)")

            let imageData = UIImageJPEGRepresentation(response.thumbnail, 1)
            let imageFile = PFFile(data: imageData, contentType: "image/jpg")
            
            let videoData = NSData.dataWithContentsOfMappedFile(response.url.path!) as NSData
            let videoFile = PFFile(data: videoData, contentType: "video/quicktime")
            
            let parallelTasks: NSMutableArray = [imageFile.saveInBackground(), videoFile.saveInBackground()]
            return BFTask(forCompletionOfAllTasks: parallelTasks).continueWithSuccessBlock({ (task) -> AnyObject! in
                post["type"] = "video"
                post["image"] = imageFile
                post["video"] = videoFile
                return post.saveEventuallyAsTask()
            })
        }
    }
    
    private class func preparePost(message: String, location: MFLocation) -> PFObject! {
        var post = PFObject(className: "Post")
        post["message"] = message
        post["location"] = PFGeoPoint(latitude: location.coordinate!.latitude, longitude: location.coordinate!.longitude)
        post["neighborhood"] = location.neighborhood
        post["locality"] = location.locality
        post["sublocality"] = location.sublocality
        return post;
    }
}