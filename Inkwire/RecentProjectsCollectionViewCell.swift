//
//  RecentProjectsCollectionViewCell.swift
//  Inkwire
//
//  Created by Arunav Gupta on 8/2/18.
//  Copyright © 2018 Metaphor Education. All rights reserved.
//

import UIKit

class RecentProjectsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleBox: UILabel!
    @IBOutlet weak var recentImage: UIImageView!
    @IBOutlet weak var RecentContainer: UIView!
    @IBOutlet weak var recentDescription: UITextView!
    
    override func awakeFromNib() {
        titleBox.adjustsFontSizeToFitWidth = true
        titleBox.minimumScaleFactor = 0.5
        backgroundColor = UIColor.white
        layer.cornerRadius = 9
        recentImage.contentMode = .scaleAspectFit
        recentDescription.adjustsFontForContentSizeCategory = true
        /*let tapGesture = UITapGestureRecognizer(target: self, action: Selector(enterProject))
        RecentContainer.addGestureRecognizer(tapGesture)
        RecentContainer.isUserInteractionEnabled = true*/
    }
    
    /*func enterProject(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if let RecentContainer = gesture.view as? UIView {
            print("Image Tapped")
            //Here you can initiate your new ViewController
            
        }
    }*/
    
    
}


