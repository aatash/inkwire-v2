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
    
    var projectID: String
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
    var followerIDs: [String]
}


