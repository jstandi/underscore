//
//  NewCommentViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/30/22.
//

import UIKit

class NewCommentViewController: UIViewController {

    @IBOutlet weak var postBarButton: UIBarButtonItem!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    var currentUser: ScoreUser!
    var originalPoster: ScoreUser!
    var comment: Comment!
    var originalPost: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = "Replying to: \(currentUser.username)"
        
        comment = Comment()
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        comment.text = commentTextView.text
        comment.originalPostID = originalPost.documentID
        comment.posterID = currentUser.userID
        comment.saveData(post: originalPost) { success in
            if success {
                print("comment saved")
            } else {
                print("could not save comment")
            }
        }
        leaveViewController()
    }
    
}
