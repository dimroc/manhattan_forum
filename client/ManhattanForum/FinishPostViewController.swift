//
//  FinishPostViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/22/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import UIKit
import MobileCoreServices

class FinishPostViewController: UIViewController {
    var startedPost: StartedPostDelegate?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        textField.addTarget(self, action: "checkPostability", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        textField.becomeFirstResponder()
        checkPostability()
    }

    func checkPostability() {
        postButton.enabled = countElements(textField.text) > 0
    }
    
    @IBAction func postTopic(sender: AnyObject) {
        DDLogHelper.debug("Posting...")

        func completeCreation(task: BFTask!) -> AnyObject! {
            if(task.success) {
                var post = task.result as Post
                DDLogHelper.debug(post.description)
            } else {
                self.presentViewController(
                    UIAlertControllerFactory.ok("Error Saving Post", message: task.error.description),
                    animated: true,
                    completion: nil)
            }
            
            return nil
        }
        
        let image = startedPost!.image
        let videoUrl = startedPost!.videoUrl
        let location = startedPost!.location
        
        if (videoUrl != nil) {
            PostRepository.createAsync(self.textField.text, color: UIColor.whiteColor(), location: location!, withImage: image, withVideo: videoUrl).continueWithBlock(completeCreation)
        } else {
            PostRepository.createAsync(self.textField.text, color: UIColor.whiteColor(), location: location!, withImage: image).continueWithBlock(completeCreation)
        }
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}