//
//  InitialViewController.swift
//  Inkwire
//
//  Created by Aatash Parikh on 7/29/18.
//  Copyright © 2018 Metaphor Education. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /**
         If User is logged in, segue automatically to main screen.  Otherwise, display welcome screen.
         */
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "toMain", sender: self)
            } else {
                self.performSegue(withIdentifier: "toWelcome", sender: self)
            }
        }
        
        let blackGradientOverlay = UIImageView(frame: view.frame)
        blackGradientOverlay.image = UIImage(named: "blackGradientOverlay")
        view.insertSubview(blackGradientOverlay, at: 0)
        
        let backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "welcomeWallpaper")
        view.insertSubview(backgroundImage, at: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
