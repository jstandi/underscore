//
//  Photo.swift
//  finalProject
//
//  Created by Jack Standefer on 4/27/22.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUserEmail: String
    var date: Date
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["description": description, "photoUserID": photoUserID, "photoUserEmail": photoUserEmail, "date": timeIntervalDate, "photoURL": photoURL]
    }
    
    init(image: UIImage, description: String, photoUserID: String, photoUserEmail: String, date: Date, photoURL: String, documentID: String) {
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUserEmail = photoUserEmail
        self.date = date
        self.photoURL = photoURL
        self.documentID = documentID
    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        let reviewUserEmail = Auth.auth().currentUser?.email ?? "unknown email"
        self.init(image: UIImage(), description: "", photoUserID: reviewUserID, photoUserEmail: reviewUserEmail, date: Date(), photoURL: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUserEmail = dictionary["photoUserEmail"] as! String? ?? ""
        let timeIntervalDate = dictionary["timeIntervalDate"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        
        self.init(image: UIImage(), description: description, photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: date, photoURL: photoURL, documentID: "")
    }
    
    func saveData(user: ScoreUser, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("could not convert photo.image to data")
            return
        }
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        if documentID == "" {
            documentID = UUID().uuidString
        }
        
        let storageRef = storage.reference().child(user.userID).child(documentID)
        
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { metadata, error in
            if let error = error {
                print("Error: upload for ref \(uploadMetaData) failed. \(error.localizedDescription)")
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            print("Upload successful")
            
            storageRef.downloadURL { url, error in
                guard error == nil else {
                    print("Couldn't create a download url \(error!.localizedDescription)")
                    return completion(false)
                }
                guard let url = url else {
                    print("Error: url was nil")
                    return completion(false)
                }
                self.photoURL = "\(url)"
                
                let dataToSave: [String: Any] = self.dictionary
                let ref = db.collection("spots").document(user.userID).collection("photos").document(self.documentID)
                ref.setData(dataToSave) { (error) in
                    guard error == nil else {
                        print("ERROR in updating document \(error!.localizedDescription)")
                        return completion(false)
                    }
                    print("Updated document \(self.documentID) in spot \(user.userID)")
                    completion(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Error: upload task for file \(self.documentID) failed in spot \(user.userID), with error \(error.localizedDescription)")
            }
            completion(false)
        }
    }
    
    func loadImage(user: ScoreUser, completion: @escaping (Bool) -> ()) {
        guard user.userID != "" else {
            print("Error: did not pass a valid spot into loadImage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(user.userID).child(documentID)
        storageRef.getData(maxSize: 25 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error: an error occurred while reading data from file ref: \(storageRef) error: \(error.localizedDescription)")
                return completion(false)
            } else {
                self.image = UIImage(data: data!) ?? UIImage()
                return completion(true)
            }
        }
    }
    
    func deleteData(user: ScoreUser, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("spots").document(user.userID).collection("photos").document(documentID).delete { error in
            if let error = error {
                print("Error: deleting photo documentID \(self.documentID). Error: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    private func deleteImage(user: ScoreUser) {
        guard user.userID != "" else {
            print("Error: did not pass a valid spot into deleteImage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(user.userID).child(documentID)
        storageRef.delete { error in
            if let error = error {
                print("Error: could not delete photo")
            } else {
                print("Photo successfully deleted")
            }
        }
    }
}
