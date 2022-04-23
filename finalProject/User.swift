//
//  User.swift
//  finalProject
//
//  Created by Jack Standefer on 4/11/22.
//

import Foundation
import UIKit

class User {
    var username: String!
    private var email: String!
    var posts: [Post]!
    var following: [User]!
    var followers: [User]!
    var likes: Int
    var dob: Date!
    var profilePicture: UIImage!
    private var password: String!
    
    init(username: String!, password: String!, email: String!, dob: Date!) {
        self.username = username
        self.password = password
        self.dob = dob
        self.email = email
        self.posts = []
        self.following = []
        self.followers = []
        self.likes = 0
        self.profilePicture = UIImage()
    }
    
    convenience init() {
        self.init(username: "", password: "", email: "", dob: Date())
    }
    
    convenience init(username: String) {
        self.init(username: username, password: "", email: "", dob: Date())
    }
    
    func followUser(user: User) {
        following.append(user)
    }
    
    func addNewPost(post: Post) {
        posts.append(post)
    }
}
