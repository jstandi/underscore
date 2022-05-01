//
//  Comment.swift
//  finalProject
//
//  Created by Jack Standefer on 4/14/22.
//

import Foundation
import Firebase

class Comment {
    var text: String!
    var originalPostID: String!
    var posterID: String!
    var documentID: String!
    var likes: Int!
    var usersWhoLiked: [String]
    
    var dictionary: [String: Any] {
        return ["text": text!, "originalPostID": originalPostID!, "posterID": posterID!, "documentID": documentID!, "likes": likes!, "usersWhoLiked": usersWhoLiked]
    }
    
    init(text: String, originalPostID: String!, posterID: String, documentID: String, likes: Int, usersWhoLiked: [String]) {
        self.text = text
        self.originalPostID = originalPostID
        self.posterID = posterID
        self.documentID = documentID
        self.likes = likes
        self.usersWhoLiked = usersWhoLiked
    }
    
    convenience init() {
        let posterID = Auth.auth().currentUser?.uid ?? ""
        self.init(text: "", originalPostID: "", posterID: posterID, documentID: "", likes: 0, usersWhoLiked: [])
    }
    
    convenience init(dictionary: [String: Any]) {
        let text = dictionary["text"] as! String? ?? ""
        let originalPostID = dictionary["originalPostID"] as! String? ?? ""
        let posterID = dictionary["posterID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        let likes = dictionary["likes"] as! Int? ?? 0
        let usersWhoLiked = dictionary["usersWhoLiked"] as! [String]? ?? []
        
        self.init(text: text, originalPostID: originalPostID, posterID: posterID, documentID: documentID, likes: likes, usersWhoLiked: usersWhoLiked)
    }
    
    func saveData(post: Post, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // create dictionary
        let dataToSave: [String: Any] = self.dictionary
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("posts").document(post.documentID).collection("comments").addDocument(data: dataToSave) { error in
                guard error == nil else {
                    print("ERROR in adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document \(self.documentID!) to post \(post.documentID)")
            }
        } else {
            let ref = db.collection("posts").document(post.documentID).collection("comments").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR in updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Updated document \(self.documentID!) in post \(post.documentID)")
            }
        }
    }
    
    func loadDataForLikes(post: Post, completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        db.collection("posts").document(post.documentID).collection("comments").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: adding snapshot listener")
                return completed()
            }
            for document in querySnapshot!.documents {
                let comment = Comment(dictionary: document.data())
                if document.documentID == self.documentID {
                    self.likes = comment.likes
                    self.usersWhoLiked = comment.usersWhoLiked
                    print("loaded data for post with text: \(comment.text) with list: \(comment.usersWhoLiked)")
                }
            }
            completed()
        }
    }
}
