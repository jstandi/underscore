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
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var changeProfilePictureButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var numPostsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var posts: Posts!
    var authUI: FUIAuth!
    var user: ScoreUser!
    var currentUser: ScoreUser!
    var editable: Bool!
    var profilePosts: [Post] = []
    var totalLikes = 0
    var profilePicture: UIImage!
    var photo: Photo!
    var photos: Photos!
    
    var imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        imagePickerController.delegate = self
        changeProfilePictureButton.isHidden = true
        editProfileButton.isHidden = true
        
        posts = Posts()
        photo = Photo()
        photos = Photos()
        
        if currentUser.userID == user.userID {
            editable = true
            changeProfilePictureButton.isHidden = false
            editProfileButton.isHidden = false
            usernameLabel.isUserInteractionEnabled = true
        }
        
        posts.loadData() {
            for post in self.posts.postArray {
                if post.postingUserID == self.user.userID {
                    self.profilePosts.append(post)
                    self.totalLikes += post.likes
                }
            }
            self.tableView.reloadData()
            self.numPostsLabel.text = "\(self.profilePosts.count) Posts"
            self.likesLabel.text = "\(self.totalLikes) Likes"
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
        
        // TODO: add direct message feature if able
        
        usernameLabel.text = user.username
    }
    
    func cameraOrLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.accessPhotoLibrary()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.accessCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func profilePhotoButtonPressed(_ sender: UIButton) {
//        TODO: need to save data here - change profile picture in view controller in viewWillAppear()
        cameraOrLibraryAlert()
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photo.image = editedImage
            photo.saveData(user: user) { success in
                if success {
                    print("photo saved")
                } else {
                    print("photo not saved")
                }
            }
            profilePictureImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo.image = originalImage
            photo.saveData(user: user) { success in
                if success {
                    print("photo saved")
                } else {
                    print("photo not saved")
                }
            }
            profilePictureImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func accessPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            self.oneButtonAlert(title: "Camera Not Available", message: "There is no camera available on this device")
        }
    }
}
