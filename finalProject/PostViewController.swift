//
//  PostViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/6/22.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if post == nil {
            post = Post(poster: User(), text: "")
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        postTitleLabel.text = post.poster.username
        postTextLabel.text = post.text
    }
    
    func leaveViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func swipeFromLeftScreenEdge(_ sender: UIScreenEdgePanGestureRecognizer) {
        leaveViewController()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
}
