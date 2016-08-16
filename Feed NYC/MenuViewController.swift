//
//  MenuViewController.swift
//  Feed NYC
//
//  Created by Henry Dinhofer on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When you want to instantiate a new ViewController from Menu do two things:
    // 1) Instantiate new VC:
    //     let profileViewController =
    //      self.storyboard!.instantiateViewControllerWithIdentifier("profileViewController")
    
    // 2) Set self.so_containerViewController.topViewController equal to new VC:
    //     self.so_containerViewController.topViewController = profileViewController
    // 3) To close the sidebar menu set is sideVCPresented to false
    //      self.so_containerViewController?.isSideViewControllerPresented = false
    @IBAction func AboutUsTapped(sender: AnyObject) {

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
