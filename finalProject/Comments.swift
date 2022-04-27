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
    
//    func loadData(completed: @escaping () -> ()) {
//        db.collection("comments").addSnapshotListener { querySnapshot, error in
//            guard error == nil else {
//                print("Error in adding snapshot listener")
//                return completed()
//            }
//            self.commentArray = []
//            for document in querySnapshot!.documents {
//                let comment = Comment(author: ScoreUser(user: User()), text: "", originalPostID: "", commentID: "", posterID: "")
//            }
//        }
//    }
}
