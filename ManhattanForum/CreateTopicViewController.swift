//
//  CreateTopicViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/21/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit

class CreateTopicViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textPlaceHolder: UILabel!
    
    override func viewDidLoad() {
        textView.becomeFirstResponder()
    }
    
    @IBAction func showCameraActionSheet(AnyObject) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take photo", "Take video", "Choose from library")
        actionSheet.showInView(view)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1: showImagePicker(UIImagePickerControllerSourceType.Camera)
        case 2: showVideoCamera()
        case 3: showImagePicker(UIImagePickerControllerSourceType.SavedPhotosAlbum)
        default:
            println("Missed option in camera sheet:\(buttonIndex)")
        }
    }
    
    private func showVideoCamera() {
        println("Take video")
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