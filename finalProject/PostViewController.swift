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
    var comments: Comments!
    var currentUser: ScoreUser!
    var users: ScoreUsers!
    var postingUser: ScoreUser!
    var hasLiked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()
        
        users = ScoreUsers()
        
        post.loadDataForLikes {
            self.likesLabel.text = "\(self.post.usersWhoLiked.count) likes"
            self.postTextLabel.sizeToFit()
        }
        
        users.loadData {
            for user in self.users.userArray {
                if user.userID == self.post.postingUserID {
                    self.postingUser = user
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProfileFromPost" {
            let destination = segue.destination as! ProfileViewController
            destination.user = postingUser
        }
    }
    
    func updateUserInterface() {
        postTitleLabel.text = post.postingUsername
        postTextLabel.text = post.text
        likesLabel.text = "\(post.likes) likes"
    }
    
    func leaveViewController() {
        post.saveData { success in
            if success {
                print("saved data")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("data not saved")
            }
        }
    }
    
    @objc func titleLabelTapped(_ sender: UITapGestureRecognizer) {
        print("working")
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelTapped(_:)))
                self.postTitleLabel.isUserInteractionEnabled = true
                self.postTitleLabel.addGestureRecognizer(labelTap)
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
        if self.post.usersWhoLiked.contains(self.currentUser.userID) {
            self.post.likes -= 1
            if let index = self.post.usersWhoLiked.firstIndex(of: self.currentUser.userID) {
                self.post.usersWhoLiked.remove(at: index)
            }
            self.post.saveData { success in
                if success {
                    print("data saved")
                } else {
                    print("could not save data")
                }
            }
        } else {
            self.post.likes += 1
            self.post.usersWhoLiked.append(self.currentUser.userID)
            self.post.saveData { success in
                if success {
                    print("data saved")
                } else {
                    print("could not save data")
                }
            }
        }
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        return cell
    }
}
