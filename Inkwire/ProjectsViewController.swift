//
//  FirstViewController.swift
//  Inkwire
//
//  Created by Aatash Parikh on 7/2/18.
//  Copyright © 2018 Metaphor Education. All rights reserved.
//

import UIKit
import Firebase

class ProjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var imageArray = [UIImage(named: "code"), UIImage(named: "chemistry"), UIImage(named: "Desert-6"), UIImage(named: "journal"), UIImage(named: "profile"),]
    var titleArray = ["Codeday 2018", "Chemistry Journal", "Photos", "Family Journal", "Robotics",]
    var descArray = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Lorem ipsum dolor sit amet", "Lorem ipsum dolor sit amet", "Lorem ipsum dolor sit amet", "Lorem ipsum dolor sit amet",]
    var selectArray = [false, false, false, false, false,]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        cell.recentDescription?.text = descArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProject = titleArray[indexPath.row]
        selectArray[indexPath.row] = true
        print(selectedProject)
        for indexPath in collectionView.indexPathsForVisibleItems {
            print(indexPath.row)
            print(collectionView.cellForItem(at: indexPath)?.isSelected)
        }
    }
    
}

