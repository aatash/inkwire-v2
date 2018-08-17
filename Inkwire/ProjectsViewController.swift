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
import FirebaseStorage

class ProjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var uid: String = Auth.auth().currentUser!.uid    // TODO: change to authorized user id

    @IBOutlet weak var projectCollectionView: UICollectionView!
    var imageArray: [String: UIImage] = [:]
    var projectsArray: [Project] = []
    var projectsOfUser: [String] = []
    var projStorageRef = Storage.storage().reference(forURL: "gs://inkwire-v2.appspot.com/projects")
    
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
                        
                        self.projectsArray.append(Project(coverImg: coverImg, description: description, isPublic: isPublic, lastModified: lastModified, title: title, users: users, posts: posts))
                        self.printProjectsArray()
                        
                        let coverImgRef = self.projStorageRef.child(coverImg)
                        
                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        
                        coverImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            print(coverImgRef)
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("Error fetching image!")
                                print(self.imageArray)
                                self.projectCollectionView.reloadData()
                            } else {
                                print("Image fetched!")
                                self.imageArray[coverImg] = UIImage(data: data!)!
                                print(self.imageArray)
                                self.projectCollectionView.reloadData()
                            }
                        }
                        
                        //Add sort mechanism
                        self.projectsArray.sort { (lhs: Project, rhs: Project) in
                            return lhs.lastModified.dateValue() > rhs.lastModified.dateValue()
                        }
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
        
        cell.recentImage?.image = (self.imageArray[self.projectsArray[indexPath.row].coverImg] != nil) ? self.imageArray[self.projectsArray[indexPath.row].coverImg] : UIImage(named: "journal")
        cell.titleBox?.text = projectsArray[indexPath.row].title
        cell.recentDescription?.text = projectsArray[indexPath.row].description
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedProject = projectsArray[indexPath.row].title
//        print(selectedProject)
//        for indexPath in collectionView.indexPathsForVisibleItems {
//            print(indexPath.row)
//            print(collectionView.cellForItem(at: indexPath)?.isSelected)
//        }
//    }
    
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
            let projectIndex = projectCollectionView.indexPath(for: sender as! UICollectionViewCell)!.row
            print(projectIndex)
            let projectTitle = projectsArray[projectIndex].title
            let projectImage = imageArray[projectsArray[projectIndex].coverImg]
            let destinationController = segue.destination as! ProjectDetailViewController
            destinationController.title = projectTitle
            destinationController.coverImage = projectImage!
           }
        }
    
}

