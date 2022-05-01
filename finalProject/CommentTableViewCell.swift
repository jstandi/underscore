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
    var currentUser: ScoreUser!
    var originalPost: Post!
    var hasLiked = false
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        if self.comment.usersWhoLiked.contains(self.currentUser.userID) {
            self.comment.likes -= 1
            if let index = self.comment.usersWhoLiked.firstIndex(of: self.currentUser.userID) {
                self.comment.usersWhoLiked.remove(at: index)
            }
            self.comment.saveData(post: originalPost) { success in
                if success {
                    print("data saved")
                } else {
                    print("could not save data")
                }
            }
        } else {
            self.comment.likes += 1
            self.comment.usersWhoLiked.append(self.currentUser.userID)
            self.comment.saveData(post: originalPost) { success in
                if success {
                    print("data saved")
                } else {
                    print("could not save data")
                }
            }
        }
    }
}
