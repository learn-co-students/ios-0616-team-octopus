//
//  AboutUsViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/17/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import ChameleonFramework

class AboutUsViewController: UIViewController {
   
//    @IBOutlet weak var aboutUSText: UITextView!
//    @IBOutlet weak var aboutUsTxt1: UITextView!
//    @IBOutlet weak var aboutUsTxt2: UITextView!
//    @IBOutlet weak var aboutUsTxt3: UITextView!
//    @IBOutlet weak var aboutUsTxt4: UITextView!
//    @IBOutlet weak var markersText: UITextView!
//    @IBOutlet weak var aboutUsTxt5: UITextView!
//    @IBOutlet weak var resourcesText: UITextView!
//    @IBOutlet weak var dataSetLink: UIButton!
    
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var aboutUsTitle: UILabel!
    @IBOutlet weak var aboutUsParagraph: UITextView!
    @IBOutlet weak var markersTitle: UILabel!
    @IBOutlet weak var markersParagraph: UITextView!
    @IBOutlet weak var resourcesTitle: UILabel!
    @IBOutlet weak var resourcesLink: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.flatNavyBlueColor().lightenByPercentage(0.2)
        self.wrapperView.backgroundColor = UIColor.flatNavyBlueColor().lightenByPercentage(0.2)
        
        self.aboutUsTitle.textColor = UIColor.flatCoffeeColor()
        self.aboutUsParagraph.textColor = UIColor.flatWhiteColor().lightenByPercentage(0.7)
        
        self.markersTitle.textColor = UIColor.flatCoffeeColor()
        self.markersParagraph.textColor = UIColor.flatWhiteColor().lightenByPercentage(0.7)
        
        self.resourcesTitle.textColor = UIColor.flatCoffeeColor()
        self.resourcesLink.setTitleColor(UIColor.flatWhiteColor().lightenByPercentage(0.7), forState: .Normal)
        
        
//        aboutUsTxt5.textColor = UIColor.flatWhiteColor().lightenByPercentage(0.7)
//        resourcesText.textColor = UIColor.flatCoffeeColor()
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "aboutUsSegue" {
//            let destVC = segue.destinationViewController as! AboutUsViewController
//            
//        }
//    }
    
    @IBAction func webViewButtonTapped(sender: AnyObject) {
    }

}
