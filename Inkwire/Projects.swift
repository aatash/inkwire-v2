//
//  Projects.swift
//  Inkwire
//
//  Created by Arunav Gupta on 8/3/18.
//  Copyright © 2018 Metaphor Education. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Project {

    var coverImg: String
    var description: String
    var isPublic: Bool
    var lastModified: Timestamp
    var title: String
    var users: [String]
    var posts: [String]
    
    init(coverImg: String, description: String, isPublic: Bool, lastModified: Timestamp, title: String, users: [String], posts: [String]) {
        self.coverImg = coverImg
        self.description = description
        self.isPublic = isPublic
        self.lastModified = lastModified
        self.title = title
        self.users = users
        self.posts = posts
    }
    
    init(project: Project) {
        self.coverImg = project.coverImg
        self.description = project.description
        self.isPublic = project.isPublic
        self.lastModified = project.lastModified
        self.title = project.title
        self.users = project.users
        self.posts = project.posts
    }
    
    mutating func addToFirestore() {
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("projects").addDocument(data: [
            "coverImg": self.coverImg,
            "description": self.description,
            "isPublic": self.isPublic,
            "lastModified": self.lastModified,
            "title": self.title,
            "users": self.users,
            "posts": self.posts
        ]) { err in
            if let err = err {
                print("Error adding project: \(err)")
            } else {
                print("Project added with ID: \(ref!.documentID)")
            }
        }
    }
}


