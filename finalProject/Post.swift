//
//  Post.swift
//  finalProject
//
//  Created by Jack Standefer on 4/6/22.
//

import Foundation

struct Post {
    var author: User
    var text: String
    var likes: Int
    var comments: [Comment]
    
    init(author: User, text: String) {
        self.author = author
        self.text = text
        self.likes = Int.random(in: 0...100)
        self.comments = []
    }
}
