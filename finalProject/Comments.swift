//
//  Comments.swift
//  finalProject
//
//  Created by Jack Standefer on 4/24/22.
//

import Foundation
import Firebase

class Comments {
    var commentArray: [Comment] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(post: Post, completed: @escaping () -> ()) {
        guard post.documentID != "" else {
            return
        }
        db.collection("posts").document(post.documentID).collection("comments").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: adding snaphost listener \(error!.localizedDescription)")
                return completed()
            }
            self.commentArray = []
            for document in querySnapshot!.documents {
                let comment = Comment(dictionary: document.data())
                comment.documentID = document.documentID
                self.commentArray.append(comment)
            }
            completed()
        }
    }
}
