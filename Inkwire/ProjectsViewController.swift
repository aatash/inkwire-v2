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
import FirebaseAuth

class ProjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var uid: String = Auth.auth().currentUser!.uid    // TODO: change to authorized user id

    @IBOutlet weak var projectCollectionView: UICollectionView!
    var imageArray = [UIImage(named: "code"), UIImage(named: "chemistry"), UIImage(named: "Desert-6"), UIImage(named: "journal"), UIImage(named: "profile"),]
    var projectsArray: [Projects] = []
    var projectsOfUser: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Loaded.")
        print(uid)
    }
    
    // TODO: add update functionality (delete -> rewrite) for images and collaborators
    func fetchRecentData() {
        //Clear existing local data
        projectsArray.removeAll()
        
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
                        
                        let coverImg = myData!["coverImg"] as? String ?? ""
                        let description = myData!["description"] as? String ?? ""
                        let isPublic = myData!["isPublic"] as? Bool ?? false
                        let lastModified = myData!["lastModified"] as? Timestamp ?? Timestamp.init()
                        let title = myData!["title"] as? String ?? ""
                        let users = myData!["users"] as? [String] ?? []
                        let posts = myData!["posts"] as? [String] ?? []
                        
                        self.projectsArray.append(Projects(coverImg: coverImg, description: description, isPublic: isPublic, lastModified: lastModified, title: title, users: users, posts: posts))
                        self.printProjectsArray()
                        self.projectCollectionView.reloadData()
                    }
                }
            } else {
                print("No projects created!")
            }
        }
    }
    
    func printProjectsArray() {
        for i in 0...(projectsArray.count - 1) {
            print("Project \(i): \(projectsArray[i].title)  \(projectsArray[i].description)")
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
        return projectsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentProjectsCollectionViewCell", for: indexPath) as! RecentProjectsCollectionViewCell
        
        cell.titleBox?.text = projectsArray[indexPath.row].title
        cell.recentImage?.image = imageArray[indexPath.row] // TODO: make reference an image ID in the cloud storage
        cell.recentDescription?.text = projectsArray[indexPath.row].description
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProject = projectsArray[indexPath.row].title
        print(selectedProject)
        for indexPath in collectionView.indexPathsForVisibleItems {
            print(indexPath.row)
            print(collectionView.cellForItem(at: indexPath)?.isSelected)
        }
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
        
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

