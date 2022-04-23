//
//  NewPostViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/6/22.
//

import UIKit

class NewPostViewController: UIViewController {
    
//    TODO: Figure out editing changed from text view, if not, change to text field
    
    @IBOutlet weak var postingUserLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postBarButton: UIBarButtonItem!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = User()
        }
        
        postBarButton.isEnabled = false
        postingUserLabel.text = "From: @\(user.username ?? "")"
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}
