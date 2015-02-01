//
//  FeedbackViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/26/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import UIKit

class FeedbackViewController: UITableViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var selectPictureButton: UIButton!
    @IBOutlet weak var messageTextView: SZTextView!
    @IBOutlet weak var sendFeedbackButton: UIButton!

    var currentImage: UIImage? = nil

    var isSendable: Bool {
        get { return countElements(messageTextView.text) > 0 }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendFeedbackButton.enabled = self.isSendable

        messageTextView.placeholder = "Enter feedback here"
        messageTextView.placeholderTextColor = UIColor.grayColor()
    }
    
    @IBAction func sendFeedback(sender: AnyObject) {
        let feedback = Feedback()
        feedback.email = emailTextField.text
        feedback.message = messageTextView.text

        self.dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(PostsViewController.ThankFeedbackNotificationKey, object: nil)
        
        saveImageIfNecessary(feedback, image: self.currentImage).continueWithBlockOnMain { (task: BFTask!) -> AnyObject! in
            if (task.success) {
                var newFeedback = task.result as Feedback
                DDLogHelper.debug("Sending Feedback: \(newFeedback)")
                newFeedback.saveEventually()
            } else {
                DDLogHelper.debug("## ERROR: Failed to save feedback: \(feedback)")
            }

            return nil
        }
    }

    func textViewDidChange(textView: UITextView) {
        self.sendFeedbackButton.enabled = self.isSendable
    }
    
    private func saveImageIfNecessary(feedback: Feedback, image: UIImage?) -> BFTask! {
        if (self.currentImage != nil) {
            let imageData = UIImageJPEGRepresentation(image, 1)
            let file = PFFile(data: imageData, contentType: "image/jpg")
            return file.saveInBackground().continueWithSuccessBlock({ (task) -> AnyObject! in
                feedback.image = file
                return feedback
            })
        }
        
        return BFTask(result: feedback)
    }
    
    @IBAction func showImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        let mediaType = info[UIImagePickerControllerMediaType]! as String
        
        switch mediaType {
        case kUTTypeImage:
            var chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
            if(chosenImage == nil) {
                chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            self.currentImage = chosenImage
            self.selectPictureButton.setTitle("Change", forState: UIControlState.Normal)
        default:
            DDLogHelper.debug("## ERROR: Unsupported Media Type: \(mediaType)")
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}