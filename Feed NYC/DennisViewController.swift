//
//  DennisViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class DennisViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let xibSubView: XibAnnotationView = XibAnnotationView(frame: CGRect(x: 10, y: 300, width: 300, height: 100))
        self.view.addSubview(xibSubView)
        
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
