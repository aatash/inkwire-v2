//
//  FirstViewController.swift
//  Inkwire
//
//  Created by Aatash Parikh on 7/2/18.
//  Copyright © 2018 Metaphor Education. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var uid: String = "3KRxy7C6XGZHDe3oLRV0"    // TODO: change to authorized user id

    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    var imageArray = [UIImage(named: "code"), UIImage(named: "chemistry"), UIImage(named: "Desert-6"), UIImage(named: "journal"), UIImage(named: "profile"),]
    var titleArray: [String] = []
    var descriptionArray: [String] = []
    var isPublicArray: [Bool] = []
    var lastModifiedArray: [Timestamp] = []
    
    var projectsOfUser: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // TODO: add update functionality (delete -> rewrite) for images and collaborators
    func fetchRecentData() {
        //Clear existing local data
        titleArray.removeAll()
        descriptionArray.removeAll()
        isPublicArray.removeAll()
        lastModifiedArray.removeAll()
        projectsOfUser.removeAll()
        
        // Add projects from user to an array of strings
        let userRef = Firestore.firestore().collection("users").document(uid)
        userRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let myData = docSnapshot.data()
            self.projectsOfUser = myData?["projectsAsContributor"] as? [String] ?? [""]
            print("Project IDs copied!")
            
            // Add each project's properties to their own arrays
            var docRef: DocumentReference! = nil
            if (self.projectsOfUser.count >= 1) {
                for i in 0...(self.projectsOfUser.count - 1) {
                    docRef = Firestore.firestore().collection("projects").document(self.projectsOfUser[i])
                    docRef.getDocument { (docSnapshot, error) in
                        guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
                        let myData = docSnapshot.data()
                        self.titleArray.append(myData!["title"] as? String ?? "")
                        print(self.titleArray)
                        self.descriptionArray.append(myData!["description"] as? String ?? "")
                        print(self.descriptionArray)
                        self.isPublicArray.append(myData!["isPublic"] as? Bool ?? false)
                        print(self.isPublicArray)
                        //let timestamp: Timestamp = docSnapshot.get("lastModified") as! Timestamp
                        //let date: Date = timestamp.dateValue()
                        self.lastModifiedArray.append(myData!["lastModified"] as? Timestamp ?? Timestamp.init())
                        print("Project properties of project \(i) copied!")
                        print("Number of projects: \(self.projectsOfUser.count)")
                        self.projectCollectionView.reloadData()
                    }
                }
            } else {
                print("No projects created!")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecentData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentProjectsCollectionViewCell", for: indexPath) as! RecentProjectsCollectionViewCell
        
        cell.titleBox?.text = titleArray[indexPath.row]
        cell.recentImage?.image = imageArray[indexPath.row]
        cell.recentDescription?.text = descriptionArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProject = titleArray[indexPath.row]
        print(selectedProject)
        for indexPath in collectionView.indexPathsForVisibleItems {
            print(indexPath.row)
            print(collectionView.cellForItem(at: indexPath)?.isSelected)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier ?? "no segue id")
        if segue.identifier == "OpenProject", let sender = sender
        {
            print("hello")
            let destinationController = segue.destination as! ProjectDetailViewController
            destinationController.title = "Really Long project Title goes here let's see if it fits"
           }
        }
    
}

