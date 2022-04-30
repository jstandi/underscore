//
//  CommentTableViewCell.swift
//  finalProject
//
//  Created by Jack Standefer on 4/14/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    var comment: Comment!
    var hasLiked = false
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
    }
}
