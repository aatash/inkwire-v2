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
    
    var coverImg: UIImage!
    
    @IBAction func imageTapped(_ sender: UIButton) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.coverImg = image
            self.coverImgButton.setImage(image, for: UIControlState.normal)
            print("Image success!")
            self.coverImgButton.alpha = 0.5
            self.imageProgress.isHidden = false
            
            let data = UIImageJPEGRepresentation(image, 0.8)
            let imageRef = Storage.storage().reference().child("projects/\(UUID().uuidString).jpg")
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    print("Upload finished!")
                    self.coverImgButton.alpha = 1.0
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
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateProject" {
            
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
