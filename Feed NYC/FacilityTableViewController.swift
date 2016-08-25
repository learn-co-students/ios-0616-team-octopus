//
//  FacilityTableViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FacilityTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var facilities = [Facility]()
    var filteredFacilities = [Facility]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        // If user has entered search query
        if searchController.active && searchController.searchBar.text != "" {
            numberOfRows = self.filteredFacilities.count
        } else {
            // Display entire list
            numberOfRows = self.facilities.count
        }

        return numberOfRows
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        

        let facility : Facility
        
        if searchController.active && searchController.searchBar.text != "" {
            facility = filteredFacilities[indexPath.row]
        } else {
            facility = facilities[indexPath.row]
        }
        

        cell.textLabel?.textColor = UIColor.flatNavyBlueColor()
        cell.detailTextLabel?.textColor = UIColor.flatGrayColorDark()
        cell.textLabel?.text = facility.name as String
        cell.detailTextLabel?.text = facility.briefDescription as String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.flatWhiteColorDark().lightenByPercentage(0.2)
        } else {
            cell.backgroundColor = UIColor.flatWhiteColor().lightenByPercentage(0.5)
        }
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) else { return }
        
        // Get the facility we want to pass
        let facility : Facility
        if searchController.active && searchController.searchBar.text != "" {
            facility = filteredFacilities[indexPath.row]
        } else {
            facility = facilities[indexPath.row]
        }

        // Pass the facility to the destinationVC
        if segue.destinationViewController.isKindOfClass(CenkersDetailViewController) {
            let destVC = segue.destinationViewController as! CenkersDetailViewController
                destVC.facilityToDisplay = facility
        }
    }

}
//MARK: -Search functionality
extension FacilityTableViewController: UISearchResultsUpdating {
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredFacilities = facilities.filter { facility in
            return facility.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
