//
//  PostViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/6/22.
//

import UIKit
import SystemConfiguration

class PostViewController: UIViewController {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet var authorLabelTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    
    var post: Post!
    var comments: [Comment] = []
    var hasLiked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if post == nil {
            post = Post(author: User(), text: "")
        }
        updateUserInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAuthorProfile" {
            let navVC = segue.destination as! UINavigationController
            let destination = navVC.viewControllers.first as! ProfileViewController
            destination.user = post.author
        }
    }
    
    func updateUserInterface() {
        postTitleLabel.text = post.author.username
        postTextLabel.text = post.text
        likesLabel.text = "\(post.likes) likes"
    }
    
    func leaveViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func authorLabelTapped(_ sender: UITapGestureRecognizer) {
        //TODO: work out tap gesture recognizer
        print("working")
    }
    
    @IBAction func swipeFromLeftScreenEdge(_ sender: UIScreenEdgePanGestureRecognizer) {
        leaveViewController()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        if hasLiked {
            post.likes -= 1
            updateUserInterface()
        } else {
            post.likes += 1
            updateUserInterface()
        }
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.comment = post.comments[indexPath.row]
        return cell
    }
    
    
}
