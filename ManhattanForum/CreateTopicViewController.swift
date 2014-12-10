//
//  CreateTopicViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/21/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateTopicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textPlaceHolder: UILabel!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    var locationManager: LocationManager? = nil
    var location: MFLocation? = nil
    var videoUrl: NSURL? = nil
    
    override func viewDidLoad() {
        textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.postButton.enabled = false;
        
        // Must hold on to ivar in memory otherwise ARC GC will clean up instance prematurely and stop prompting for user location
        self.locationManager = LocationManager.start({ (response) -> Void in
            switch response {
            case .Error(let error):
                NSLog(error.description)
                self.presentViewController(
                    UIAlertControllerFactory.ok("Error with Location", message: "Unable to get neighborhood!\nPlease close post and try again later."),
                    animated: true,
                    completion: nil
                )
            case .Response(let location):
                self.textPlaceHolder.text = "Share \(location.description)"
                self.postButton.enabled = true
                self.location = location
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        println("Removing location manager")
        locationManager = nil
    }
    
    @IBAction func postTopic(sender: AnyObject) {
        NSLog("Posting...")
        
        func completeCreation(task: BFTask!) -> AnyObject! {
            if(task.success) {
                var post = task.result as PFObject
                println(post)
            } else {
                self.presentViewController(
                    UIAlertControllerFactory.ok("Error Saving Post", message: task.error.description),
                    animated: true,
                    completion: nil)
            }
            
            return nil
        }
        
        if (self.videoUrl != nil) {
            PostRepository.createAsync(self.textView.text, location: self.location!, withImage: self.imageView.image, withVideo: self.videoUrl!).continueWithBlock(completeCreation)
        } else {
            PostRepository.createAsync(self.textView.text, location: self.location!, withImage: self.imageView.image).continueWithBlock(completeCreation)
        }
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showCameraActionSheet(AnyObject) {
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        var takePhotoAction = UIAlertAction(title: "Take photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.showPhotoCamera()
        }

        var takeVideoAction = UIAlertAction(title: "Take video", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.showVideoCamera()
        }

        var chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.showImagePicker(UIImagePickerControllerSourceType.SavedPhotosAlbum)
        }

        alertController.addAction(takePhotoAction)
        alertController.addAction(takeVideoAction)
        alertController.addAction(chooseFromLibraryAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func showVideoCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let picker = UIImagePickerController()
            picker.delegate = self;
            picker.allowsEditing = true;
            picker.videoMaximumDuration = 15.0;
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeMovie]
            presentViewController(picker, animated: true, completion: nil)
        } else {
            self.presentViewController(UIAlertControllerFactory.ok("No Camera", message: "No Camera Available"), animated: true, completion: nil)
        }
    }
    
    private func showPhotoCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            showImagePicker(UIImagePickerControllerSourceType.Camera)
        } else {
            self.presentViewController(UIAlertControllerFactory.ok("No Camera", message: "No Camera Available"), animated: true, completion: nil)
        }
    }
    
    private func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self;
        picker.sourceType = sourceType
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        let mediaType = info[UIImagePickerControllerMediaType]! as String
        
        switch mediaType {
        case kUTTypeVideo, kUTTypeMovie:
            // TODO: fix orientation here so that we can grab thumbnail and splice out ommitted entries.
            self.postButton.enabled = false;
            
            // Create a BFExecutor that uses the main thread.
            let mainExecutor = BFExecutor(dispatchQueue: dispatch_get_main_queue())
            let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL
            let videoStart = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let videoEnd = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            
            let videoAsset = MFVideoAsset(videoUrl)
            
            videoAsset.prepare(videoStart, until: videoEnd).continueWithExecutor(mainExecutor, withBlock: { (task:BFTask!) -> AnyObject! in
                if task.success {
                    let finalAsset: MFVideoAsset! = task.result as MFVideoAsset
                    self.videoUrl = finalAsset.url
                    self.imageView.image = finalAsset.thumbnail
                } else { // Final all encapsulating error handler
                    println("## ERROR: Failed Video Recording: %@", task.error.debugDescription)
                    self.presentViewController(
                        UIAlertControllerFactory.ok("Error recording video", message: task.error.description),
                        animated: true,
                        completion: nil
                    )
                }
                
                return nil
            })
        case kUTTypeImage:
            var chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
            if(chosenImage == nil) {
                chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            }

            self.imageView.image = chosenImage
            self.videoUrl = nil
        default:
            println("## ERROR: Unsupported Media Type: \(mediaType)")
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}