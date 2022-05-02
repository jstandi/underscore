//
//  ProfileViewController.swift
//  finalProject
//
//  Created by Jack Standefer on 4/6/22.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var numPostsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var posts: Posts!
    var authUI: FUIAuth!
    var user: ScoreUser!
    var users: ScoreUsers!
    var currentUser: ScoreUser!
    var editable: Bool!
    var profilePosts: [Post] = []
    var totalLikes = 0
    var profilePicture: UIImage!
    var photo: Photo!
    var photos: Photos!
    var currentlyEditing = false
    
    var imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        editProfileButton.isHidden = true
        usernameLabel.isEnabled = false
        
        posts = Posts()
        users = ScoreUsers()
        photos = Photos()
        
        if currentUser.userID == user.userID {
            editable = true
            editProfileButton.isHidden = false
            usernameLabel.isEnabled = true
        }
        
        posts.loadData() {
            for post in self.posts.postArray {
                if post.postingUserID == self.user.userID {
                    if !self.profilePosts.contains(post) {
                        self.profilePosts.append(post)
                        self.totalLikes += post.likes
                    }
                }
            }
            
            self.sortByTime()
            self.numPostsLabel.text = "\(self.profilePosts.count) Posts"
            self.likesLabel.text = "\(self.totalLikes) Likes"
        }
        
        users.loadData {
            for user in self.users.userArray {
                if user.userID == self.user.userID {
                    self.usernameLabel.text = user.username
                    self.bioTextView.text = user.bio
                }
            }
        }
        
        photos.loadData(user: user) {
            for photo in self.photos.photoArray {
                if photo.photoUserID == self.user.userID {
                    photo.loadImage(user: self.user) { success in
                        if success {
                            self.profilePicture = photo.image
                        } else {
                            print("error loading image")
                        }
                    }
                }
            }
        }
                
        usernameLabel.text = user.username
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPostFromProfile" {
            let destination = segue.destination as! PostViewController
            destination.currentUser = currentUser
            destination.post = profilePosts[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func sortByTime() {
        profilePosts.sort(by: {$0.postedDate > $1.postedDate})
        tableView.reloadData()
    }
    
    func presentSaveAlert() {
        let alertController = UIAlertController(title: "Info Saved", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let noSpacesUsername = usernameLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpacesUsername != "" {
            user.username = noSpacesUsername
        }
        user.bio = bioTextView.text!
        user.updateUserInfo { success in
            if success {
                self.presentSaveAlert()
                print("updated user info")
            } else {
                print("could not update user info")
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profilePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfilePostTableViewCell
        cell.postTextLabel.text = profilePosts[indexPath.row].text
        cell.usernameLabel.text = user.username
        return cell
    }
        
}
