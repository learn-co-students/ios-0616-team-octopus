//
//  MenuViewController.swift
//  Feed NYC
//
//  Created by Henry Dinhofer on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var dierectoryBoxLabel: UIView!
    @IBOutlet weak var directories: UILabel!
    @IBOutlet weak var allLocationsBox: UIView!
    @IBOutlet weak var soupAndPantryLabel: UIButton!
    @IBOutlet weak var foodPantryBox: UIView!
    @IBOutlet weak var fodPantryLabel: UIButton!
    @IBOutlet weak var soupKitchenLabel: UIButton!
    @IBOutlet weak var mapLabel: UIButton!
    @IBOutlet weak var aboutUsLabel: UIButton!
    
    
    let store = FacilityDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuPageColors()

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
    @IBAction func AboutUsTapped(_ sender: AnyObject) {

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print(segue.destination)
        
        if segue.identifier == "allFacilities" {
            let navigationController = segue.destination
            let tableVC = navigationController.childViewControllers.first as! FacilityTableViewController
            tableVC.title = "Soup Kitchens & Food Pantries"
            
            tableVC.facilities = self.store.facilities.sorted{ $0.name < $1.name }
            
            print("Inside all facilities")
        } else if segue.identifier == "foodPantries" {
            let navigationController = segue.destination
            let tableVC = navigationController.childViewControllers.first as! FacilityTableViewController
            tableVC.title = "Food Pantries"
            let foodPantries = self.store.getFoodPantryFacilities()
            
            tableVC.facilities = foodPantries.sorted{ $0.name < $1.name }
            
            //print(tableVC.facilities)
            print("Inside food pantries")
        } else if segue.identifier == "soupKitchens" {
            let navigationController = segue.destination
            let tableVC = navigationController.childViewControllers.first as! FacilityTableViewController
            tableVC.title = "Soup Kitchens"
            tableVC.facilities = self.store.getFacilitiesThatHave(feature: Facility.foodType.SoupKitchen)
        }
        
    }
    
    func menuPageColors() {
        
        self.view.backgroundColor = UIColor.flatWhite().lighten(byPercentage: 0.5)
        self.dierectoryBoxLabel.backgroundColor = UIColor.flatNavyBlue().lighten(byPercentage: 0.2)
        directories.textColor = UIColor.flatWhite().lighten(byPercentage: 0.3)
        soupAndPantryLabel.setTitleColor(UIColor.flatSkyBlueColorDark(), for: UIControlState())
        fodPantryLabel.setTitleColor(UIColor.flatSkyBlueColorDark(), for: UIControlState())
        soupKitchenLabel.setTitleColor(UIColor.flatSkyBlueColorDark(), for: UIControlState())
        mapLabel.setTitleColor(UIColor.flatSkyBlueColorDark(), for: UIControlState())
        aboutUsLabel.setTitleColor(UIColor.flatSkyBlueColorDark(), for: UIControlState())
        allLocationsBox.layer.borderColor = UIColor.flatNavyBlueColorDark().cgColor
        
    }

}
