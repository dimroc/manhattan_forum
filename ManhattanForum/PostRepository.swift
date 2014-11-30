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
    
    // TODO: Switch to Bolts: https://github.com/BoltsFramework/Bolts-iOS
    class func create(message: String, location: MFLocation, withImage: UIImage?) -> BFTask {
        var post = PFObject(className: "Post")
        post["message"] = message
        post["location"] = PFGeoPoint(latitude: location.coordinate!.latitude, longitude: location.coordinate!.longitude)
        post["neighborhood"] = location.neighborhood
        post["locality"] = location.locality
        post["sublocality"] = location.sublocality
        
        var deferred = BFTaskCompletionSource()
        if let image = withImage {
            let imageData = UIImageJPEGRepresentation(image, 0.7)
            let file = PFFile(data: imageData, contentType: "image/jpg")
            
            file.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                if(succeeded) {
                    post["type"] = "image"
                    post["image"] = file
                    post.saveEventually({ (success, error) -> Void in
                        if(success) {
                            deferred.setResult(post)
                        } else {
                            deferred.setError(error)
                        }
                    })
                } else {
                    println("## IMAGE POST ERROR")
                    println("## \(error.description)")
                    deferred.setError(error)
                }
            })
        } else {
            post["type"] = "message"
            post.saveEventually({ (success, error) -> Void in
                if(success) {
                    deferred.setResult(post)
                } else {
                    deferred.setError(error)
                }
            })
        }
        
        return deferred.task
    }
    
    class func create(message: String, location: MFLocation, withVideo: NSURL!) {
        var post = PFObject(className: "Post")
        post["message"] = message
        post["location"] = PFGeoPoint(latitude: location.coordinate!.latitude, longitude: location.coordinate!.longitude)
        post["neighborhood"] = location.neighborhood
        post["locality"] = location.locality
        post["sublocality"] = location.sublocality
        
        let videoAsset = MFVideoAsset(withVideo)
        videoAsset.fixOrientation({ (response: MFVideoAssetResponse!) -> Void in
            if(response.success) {
                let imageData = UIImageJPEGRepresentation(response.thumbnail, 1)
                let imageFile = PFFile(data: imageData, contentType: "image/jpg")
                
                imageFile.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                    if(succeeded) {
                        println("## Video Orientation Fixed to \(response.url)")
                        let videoData = NSData.dataWithContentsOfMappedFile(response.url.path!) as NSData
                        let videoFile = PFFile(data: videoData, contentType: "video/quicktime")
                        
                        videoFile.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                            if(succeeded) {
                                post["type"] = "video"
                                post["image"] = imageFile
                                post["video"] = videoFile
                                post.saveEventually()
                            } else {
                                println("## VIDEO POST ERROR")
                                println("## \(error.description)")
                            }
                        })
                    }
                })
            } else {
                println("## Video Orientation Fixed FAILED \(response.error.description)")
            }
        })
    }
}