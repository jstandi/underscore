//
//  User.swift
//  finalProject
//
//  Created by Jack Standefer on 4/11/22.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class ScoreUser {
    var email: String
    var username: String
    var profilePictureURL: String
    var userID: String
    
    var dictionary: [String: Any] {
        return ["email": email, "username": username, "profilePictureURL": profilePictureURL]
    }
    
    init(email: String, username: String, profilePictureURL: String, userID: String) {
        self.email = email
        self.username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        self.profilePictureURL = profilePictureURL
        self.userID = userID
    }
    
    convenience init(user: User) {
        let email = user.email ?? ""
        let username = user.displayName ?? ""
        let profilePictureURL = (user.photoURL != nil ? "\(user.photoURL!)" : "")
        self.init(email: email, username: username, profilePictureURL: profilePictureURL, userID: user.uid)
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let username = dictionary["username"] as! String? ?? ""
        let profilePictureURL = dictionary["profilePictureURL"] as! String? ?? ""
        self.init(email: email, username: username, profilePictureURL: profilePictureURL, userID: "")
    }
    
    func saveIfNewUser(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        userRef.getDocument { document, error in
            guard error == nil else {
                print("could not access document")
                return completion(false)
            }
            guard document?.exists == false else {
                print("document for user \(self.userID) already exists")
                return completion(true)
            }
            let dataToSave: [String: Any] = self.dictionary
            db.collection("users").document(self.userID).setData(dataToSave) { error in
                guard error == nil else {
                    print("error: could not save data")
                    return completion(false)
                }
                return completion(true)
            }
        }
    }
}
