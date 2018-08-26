//
//  AddProjectViewController.swift
//  Inkwire
//
//  Created by Arunav Gupta on 8/18/18.
//  Copyright © 2018 Metaphor Education. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AddProjectViewController: UIViewController {
    
    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var coverImgButton: UIButton!
    @IBOutlet weak var imageProgress: UIProgressView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var projectDesc: UITextView!
    @IBOutlet weak var projectPublic: UISwitch!
    
    var coverImg: UIImage!
    var coverImgID: String!
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    @IBAction func imageTapped(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.coverImg = image
            self.coverImgButton.setImage(image, for: UIControlState.normal)
            print("Image success!")
            self.coverImgButton.alpha = 0.5
            self.imageProgress.isHidden = false
            self.submitButton.alpha = 0.6
            self.submitButton.isUserInteractionEnabled = false
            
            let data = UIImageJPEGRepresentation(image, 0.4)
            self.coverImgID = UUID().uuidString + ".jpg"
            let imageRef = Storage.storage().reference().child("projects/\(self.coverImgID!)")
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                
                if let error = error {
                    print("Error!: Image failed to upload")
                }
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    print("Upload finished!")
                    self.coverImgButton.alpha = 1.0
                    self.submitButton.alpha = 1.0
                    self.submitButton.isUserInteractionEnabled = true
                    self.imageProgress.isHidden = true
                }
            }
            
            // Add a progress observer to an upload task
            let observer = uploadTask.observe(.progress) { snapshot in
                guard let progress = snapshot.progress else { return }
                self.imageProgress.progress = Float(progress.fractionCompleted)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.projectDesc.layer.borderWidth = 1
        //self.projectDesc.layer.borderColor = Constants.appColor as! CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateProject" {
            //create new project in Firestore
            //create default project
            let createDate = Timestamp(date: Date())
            var ref: DocumentReference? = nil
            ref = self.db.collection("projects").addDocument(data: [
                "coverImg": coverImgID ?? "",
                "description": self.projectDesc.text ?? "",
                "isPublic": self.projectPublic.isOn,
                "lastModified": createDate,
                "title": self.projectTitle.text ?? "New Project",
                "users": [auth.currentUser!.uid]
            ]) { err in
                if let err = err {
                    print("Error adding default project: \(err)")
                } else {
                    print("Default project added with ID: \(ref!.documentID)")
                }
            }
            
            //TODO: fetch user array into local array, append new project ID, then set the data on remote
            
            //add project to user's account
            self.db.collection("users/\(auth.currentUser!.uid)/projectsAsContributor").document(ref!.documentID).setData([
                "lastModified": createDate,
                "lastOpened": createDate
            ])
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
