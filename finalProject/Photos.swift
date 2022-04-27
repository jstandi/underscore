//
//  Photos.swift
//  finalProject
//
//  Created by Jack Standefer on 4/27/22.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(user: ScoreUser, completed: @escaping () -> ()) {
        guard user.userID != "" else {
            return
        }
        db.collection("spots").document(user.userID).collection("photos").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: adding snaphost listener \(error!.localizedDescription)")
                return completed()
            }
            self.photoArray = []
            for document in querySnapshot!.documents {
                let photo = Photo(dictionary: document.data())
                photo.documentID = document.documentID
                self.photoArray.append(photo)
            }
            completed()
        }
    }
}
