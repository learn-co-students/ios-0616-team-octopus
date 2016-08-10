//
//  ContainerViewController.swift
//  Feed NYC
//
//  Created by Henry Dinhofer on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SidebarOverlay

class ContainerViewController: SOContainerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuSide = .Left
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("topScreen")
        self.sideViewController = self.storyboard?.instantiateViewControllerWithIdentifier("menuScreen")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
