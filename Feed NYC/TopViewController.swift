//
//  TopViewController.swift
//  Feed NYC
//
//  Created by Henry Dinhofer on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        if let container = self.so_containerViewController
        {
            container.isSideViewControllerPresented = true
            
            // To close the sidebar menu set is sideVCPresented to false
        }

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
