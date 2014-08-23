//
//  CreateTopicViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/21/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit

class CreateTopicViewController: UIViewController, UIActionSheetDelegate {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        textView.becomeFirstResponder()
    }
    
    @IBAction func showCameraActionSheet(AnyObject) {
        println("button tapped!")
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take photo", "Take video", "Choose from library")
        actionSheet.showInView(view)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            println("Take photo")
        case 2:
            println("Take video")
        case 3:
            println("Choose from library")
        default:
            println("Missed option in camera sheet:\(buttonIndex)")
        }
    }
}