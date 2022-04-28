//
//  ScoreUsers.swift
//  finalProject
//
//  Created by Jack Standefer on 4/27/22.
//

import Foundation
import Firebase

class ScoreUsers {
    var userArray: [ScoreUser]!
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: adding snapshot listener")
                return completed()
            }
            self.userArray = []
            for document in querySnapshot!.documents {
                let user = ScoreUser(dictionary: document.data())
                user.userID = document.documentID
                self.userArray.append(user)
            }
            completed()
        }
    }
}
