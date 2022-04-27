//
//  Comment.swift
//  finalProject
//
//  Created by Jack Standefer on 4/14/22.
//

import Foundation

struct Comment {
    var author: ScoreUser!
    var text: String!
    var likes: Int!
    var originalPostID: String!
    var commentID: String!
    var posterID: String!
    
    var dictionary: [String: Any] {
        return ["author": author, "text": text, "likes": likes, "originalPostID": originalPostID, "commentID": commentID, "posterID": posterID]
    }
    
    init(author: ScoreUser, text: String, originalPostID: String, commentID: String, posterID: String) {
        self.author = author
        self.text = text
        self.likes = 0
        self.originalPostID = originalPostID
        self.commentID = commentID
        self.posterID = posterID
    }
}
