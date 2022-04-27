//
//  Post.swift
//  finalProject
//
//  Created by Jack Standefer on 4/6/22.
//

import Foundation
import Firebase
import MapKit

class Post: NSObject, MKAnnotation {
    var text: String
    var coordinate: CLLocationCoordinate2D
    var likes: Int
    var postingUsername: String
    var postingUserID: String
    var documentID: String
    var usersWhoLiked: [String]
    
    var dictionary: [String: Any] {
        return ["text": text, "latitude": latitude, "longitude": longitude, "likes": likes, "postingUsername": postingUsername, "postingUserID": postingUserID, "documentID": documentID, "usersWhoLiked": usersWhoLiked]
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(text: String, coordinate: CLLocationCoordinate2D, likes: Int, postingUsername: String, postingUserID: String, documentID: String, usersWhoLiked: [String]) {
        self.text = text
        self.coordinate = coordinate
        self.likes = likes
        self.postingUsername = postingUsername
        self.postingUserID = postingUserID
        self.documentID = documentID
        self.usersWhoLiked = usersWhoLiked
    }
    
    override convenience init() {
        self.init(text: "", coordinate: CLLocationCoordinate2D(), likes: 0, postingUsername: "", postingUserID: "", documentID: "", usersWhoLiked: [])
    }
    
    convenience init(dictionary: [String: Any]) {
        let text = dictionary["text"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let likes = dictionary["likes"] as! Int? ?? 0
        let postingUsername = dictionary["postingUsername"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let usersWhoLiked = dictionary["usersWhoLiked"] as! [String]? ?? []
        self.init(text: text, coordinate: coordinate, likes: likes, postingUsername: postingUsername, postingUserID: postingUserID, documentID: "", usersWhoLiked: usersWhoLiked)
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // get user ID
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("ERROR: could not save data - no valid posting user ID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // create dictionary
        let dataToSave: [String: Any] = self.dictionary
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("posts").addDocument(data: dataToSave) { error in
                guard error == nil else {
                    print("ERROR in adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document \(self.documentID)")
                completion(true)
            }
        } else {
            let ref = db.collection("posts").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR in updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Updated document \(self.documentID)")
                completion(true)
            }
        }
    }
    
    func loadDataForLikes(completed: @escaping () -> ()) {
        let db = Firestore.firestore()
        db.collection("posts").addSnapshotListener { querySnapshot, error in
            guard error == nil else {
                print("ERROR: adding snapshot listener")
                return completed()
            }
            for document in querySnapshot!.documents {
                let post = Post(dictionary: document.data())
                if document.documentID == self.documentID {
                    self.likes = post.likes
                    self.usersWhoLiked = post.usersWhoLiked
                    print("loaded data for post with text: \(post.text) with list: \(post.usersWhoLiked)")
                }
            }
            completed()
        }
    }
}
