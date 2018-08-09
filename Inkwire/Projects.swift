//
//  Projects.swift
//  Inkwire
//
//  Created by Arunav Gupta on 8/3/18.
//  Copyright © 2018 Metaphor Education. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Projects {

    var coverImgUrl: URL
    var description: String
    var title: String
    var contributorIDs: [String]// {
    //didSet {
    //      if contributorIDs != nil {
    //         contributorIDs = Array(Set(contributorIDs))
    //      }
    //  }
    // }
    var postIDs: [String] //{
    //didSet {
    //     if postIDs != nil {
    //        postIDs = Array(Set(postIDs))
    //    }
    // }
    // }
    
    init(coverImgUrl: URL, description: String, title: String, contributorIDs: [String], postIDs: [String]) {
        self.coverImgUrl = coverImgUrl
        self.description = description
        self.title = title
        self.contributorIDs = contributorIDs
        self.postIDs = postIDs
        
        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("projects").addDocument(data: [
            "title": title,
            "description": description,
            "coverImgUrl": coverImgUrl,
            "contributorIDs": [contributorIDs],
            "postIDs": [postIDs]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}


