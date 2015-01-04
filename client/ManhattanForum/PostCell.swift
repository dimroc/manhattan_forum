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
    
    func populateFromPost(post: Post) {
        self.messageLabel.text = post.message
    }
}
