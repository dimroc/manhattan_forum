//
//  FeedbackViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/26/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import UIKit

class FeedbackViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var selectPictureButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendFeedbackButton: UIButton!
    
    var isSendable: Bool {
        get { return countElements(messageTextView.text) > 0 && messageTextView.text != "Enter Message" }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendFeedbackButton.enabled = self.isSendable
    }
    
    @IBAction func sendFeedback(sender: AnyObject) {
        let feedback = Feedback()
        feedback.email = emailTextField.text
        feedback.message = messageTextView.text
        
        DDLogHelper.debug("Sending Feedback: \(feedback)")
        feedback.saveEventually()
        self.dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(PostsViewController.ThankFeedbackNotificationKey, object: nil)
    }

    func textViewDidChange(textView: UITextView) {
        self.sendFeedbackButton.enabled = self.isSendable
    }
}