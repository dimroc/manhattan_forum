//
//  PostCell.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/3/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation

class PostCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageViewLink: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func populateFromPost(post: Post!) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.timeZone = NSTimeZone(name: "EST")
        
        self.messageLabel.text = post.message
        //self.messageLabel.textColor = safeColor(post)
        self.dateLabel.text = "\(post.createdAt.timeAgo()) \(timeFormatter.stringFromDate(post.createdAt))"
        self.locationLabel.text = post.neighborhoodDescription
        self.imageViewLink.image = UIImage(named: "imageLoadingPlaceholder")

        self.selectionStyle = UITableViewCellSelectionStyle.None;

        // self.performSelector("populate\(post.type)") // Doesn't work in Swift!
        switch(post.type) {
        case "video":
            populateImage(post)
        case "image":
            populateImage(post)
        default:
            break;
        }
    }
    
    func populateImage(post: Post!) {
        post.image.getDataInBackground().continueWithBlockOnMain { (task: BFTask!) -> AnyObject! in
            if(task.success) {
                self.imageViewLink.image = UIImage(data: task.result as NSData!)
            } else {
                DDLogHelper.debug("Failed to retrieve image for post: \(post.description)")
            }
            
            return nil
        }
    }
    
    func safeColor(post: Post!) -> UIColor {
        if let colorString: String = post.color {
            return UIColor(CSS: colorString)
        }
        
        return UIColor.whiteColor()
    }
}