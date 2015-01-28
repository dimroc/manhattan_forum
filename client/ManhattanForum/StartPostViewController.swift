//
//  CreateTopicViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/21/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol StartedPostDelegate {
    var videoUrl: NSURL? { get }
    var image: UIImage? { get }
    var location: MFLocation? { get }
}

class StartPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, StartedPostDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textPlaceHolder: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var locationManager: LocationManager? = nil
    var location: MFLocation? = nil
    var videoUrl: NSURL? = nil
    var image: UIImage? {
        get { return self.imageView.image }
    }
    
    var isNextable: Bool {
        get { return self.location != nil && imageView.image != nil }
    }
    
    override func viewDidLoad() {
        nextButton.enabled = isNextable;
        
        locationManager = LocationManager()
        
        locationManager!.startAsync().continueWithBlockOnMain({ (task: BFTask!) -> AnyObject! in
            if(task.success) {
                let location = task.result as MFLocation!
                self.textPlaceHolder.text = "Share \(location.description)"
                self.nextButton.enabled = self.isNextable
                self.location = location
                self.showCameraActionSheet(self)
            } else {
                DDLogHelper.debug(task.error.description)

                self.presentViewController(
                    UIAlertControllerFactory.ok("Error with Location", message: "Unable to get neighborhood!\n\(task.error.localizedDescription)\nPlease close post and try again later."),
                    animated: true,
                    completion: nil)
            }
            
            return nil
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier? == "FinishPostSegue") {
            let viewController: FinishPostViewController = segue.destinationViewController as FinishPostViewController
            viewController.startedPost = self
        }
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
        #if DEBUG
            alertController.addAction(chooseFromLibraryAction)
        #endif
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func showVideoCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let picker = UIImagePickerController()
            picker.delegate = self;
            picker.allowsEditing = true;
            picker.videoMaximumDuration = 20.0;
            picker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
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
            self.nextButton.enabled = false;
            
            let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL
            let videoStart = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let videoEnd = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            
            let videoAsset = MFVideoAsset(videoUrl)
            
            videoAsset.prepare(videoStart, until: videoEnd).continueWithBlockOnMain({ (task:BFTask!) -> AnyObject! in
                if task.success {
                    let finalAsset: MFVideoAsset! = task.result as MFVideoAsset
                    self.videoUrl = finalAsset.url
                    self.imageView.image = finalAsset.thumbnail
                    self.nextButton.enabled = self.isNextable
                } else { // Final all encapsulating error handler
                    DDLogHelper.debug("## ERROR: Failed Video Recording: \(task.error.debugDescription)")
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
            self.nextButton.enabled = self.isNextable
        default:
            DDLogHelper.debug("## ERROR: Unsupported Media Type: \(mediaType)")
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}