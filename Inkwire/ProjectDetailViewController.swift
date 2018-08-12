//
//  ProjectDetailViewController.swift
//  Inkwire
//
//  Created by Aatash Parikh on 8/9/18.
//  Copyright © 2018 Metaphor Education. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        let tlabel = UILabel(frame: frame)
        tlabel.text = self.title
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.boldSystemFont(ofSize: 17) //UIFont(name: "Helvetica", size: 17.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        self.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.never
        self.navigationItem.titleView = tlabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
