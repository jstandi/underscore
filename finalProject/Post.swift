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
    
    var dictionary: [String: Any] {
        return ["text": text, "latitude": latitude, "longitude": longitude, "likes": likes, "postingUsername": postingUsername, "postingUserID": postingUserID, "documentID": documentID]
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
    
    init(text: String, coordinate: CLLocationCoordinate2D, likes: Int, postingUsername: String, postingUserID: String, documentID: String) {
        self.text = text
        self.coordinate = coordinate
        self.likes = likes
        self.postingUsername = postingUsername
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    override convenience init() {
        self.init(text: "", coordinate: CLLocationCoordinate2D(), likes: 0, postingUsername: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let text = dictionary["text"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let likes = dictionary["likes"] as! Int? ?? 0
        let postingUsername = dictionary["postingUsername"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(text: text, coordinate: coordinate, likes: likes, postingUsername: postingUsername, postingUserID: postingUserID, documentID: "")
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
            let ref = db.collection("spots").document(self.documentID)
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
}
