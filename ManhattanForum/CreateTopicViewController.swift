//
//  CreateTopicViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/21/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateTopicViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textPlaceHolder: UILabel!
    
    var locationManager: LocationManager? = nil
    
    override func viewDidLoad() {
        textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Must hold on to ivar in memory otherwise ARC GC will clean up instance prematurely and stop prompting for user location
        self.locationManager = LocationManager.start({ (response) -> Void in
            switch response {
            case .Error(let error):
                // TODO: Show popup
                NSLog(error.description)
            case .Response(let location):
                self.textPlaceHolder.text = "Share \(location.description)"
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        println("Removing location manager")
        locationManager = nil
    }
    
    @IBAction func postTopic(sender: AnyObject) {
        NSLog("Posting...")
    }
    
    @IBAction func showCameraActionSheet(AnyObject) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take photo", "Take video", "Choose from library")
        actionSheet.showInView(view)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1: showPhotoCamera()
        case 2: showVideoCamera()
        case 3: showImagePicker(UIImagePickerControllerSourceType.SavedPhotosAlbum)
        default:
            println("Missed option in camera sheet:\(buttonIndex)")
        }
    }
    
    private func showVideoCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let picker = UIImagePickerController()
            picker.delegate = self;
            picker.allowsEditing = true;
            picker.videoMaximumDuration = 15.0;
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeMovie]
            presentViewController(picker, animated: true) { () -> Void in
            }
        } else {
            UIAlertView(title: "No Camera", message: "No Camera Available", delegate: self, cancelButtonTitle: "Ok").show()
        }
    }
    
    private func showPhotoCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            showImagePicker(UIImagePickerControllerSourceType.Camera)
        } else {
            UIAlertView(title: "No Camera", message: "No Camera Available", delegate: self, cancelButtonTitle: "Ok").show()
        }
    }
    
    private func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self;
        picker.sourceType = sourceType
        presentViewController(picker, animated: true) { () -> Void in
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        var chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
        if(chosenImage == nil) {
            chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        imageView.image = chosenImage
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
}