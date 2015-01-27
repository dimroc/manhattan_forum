//
//  FeedbackViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/26/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import UIKit

class FeedbackViewController: UITableViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var selectPictureButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendFeedbackButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendFeedback(sender: AnyObject) {
        DDLogHelper.debug("Sending Feedback!")
    }
}