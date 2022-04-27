//
//  Posts.swift
//  finalProject
//
//  Created by Jack Standefer on 4/23/22.
//

import Foundation
import Firebase

class Posts {
    var postArray: [Post]!
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("posts").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: adding snapshot listener")
                return completed()
            }
            self.postArray = []
            for document in querySnapshot!.documents {
                let post = Post(dictionary: document.data())
                post.documentID = document.documentID
                self.postArray.append(post)
            }
            completed()
        }
    }
    
    func loadUserData(user: ScoreUser, completed: @escaping () -> ()) {
        db.collection("users").document(user.userID).collection("posts").addSnapshotListener { querySnapshot, error in
            guard error != nil else {
                print("something went wrong")
                return completed()
            }
            self.postArray = []
            for document in querySnapshot!.documents {
                let post = Post(dictionary: document.data())
                post.documentID = document.documentID
                self.postArray.append(post)
            }
            completed()
        }
    }
}
