//
//  AboutUsViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/17/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "aboutUsSegue" {
            let destVC = segue.destinationViewController as! AboutUsViewController
            
        }
    }
    
    @IBAction func datasetUrllinkTapped(sender: AnyObject) {
      
    }
}
