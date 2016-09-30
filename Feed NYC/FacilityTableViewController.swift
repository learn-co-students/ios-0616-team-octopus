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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        // If user has entered search query
        if searchController.isActive && searchController.searchBar.text != "" {
            numberOfRows = self.filteredFacilities.count
        } else {
            // Display entire list
            numberOfRows = self.facilities.count
        }

        return numberOfRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        

        let facility : Facility
        
        if searchController.isActive && searchController.searchBar.text != "" {
            facility = filteredFacilities[(indexPath as NSIndexPath).row]
        } else {
            facility = facilities[(indexPath as NSIndexPath).row]
        }
        

        cell.textLabel?.textColor = UIColor.flatNavyBlue()
        cell.detailTextLabel?.textColor = UIColor.flatGrayColorDark()
        cell.textLabel?.text = facility.name as String
        cell.detailTextLabel?.text = facility.briefDescription as String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if ((indexPath as NSIndexPath).row % 2 == 0) {
            cell.backgroundColor = UIColor.flatWhiteColorDark().lighten(byPercentage: 0.2)
        } else {
            cell.backgroundColor = UIColor.flatWhite().lighten(byPercentage: 0.5)
        }
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPath(for: sender as! UITableViewCell) else { return }
        
        // Get the facility we want to pass
        let facility : Facility
        if searchController.isActive && searchController.searchBar.text != "" {
            facility = filteredFacilities[(indexPath as NSIndexPath).row]
        } else {
            facility = facilities[(indexPath as NSIndexPath).row]
        }

        // Pass the facility to the destinationVC
        if segue.destination.isKind(of: CenkersDetailViewController.self) {
            let destVC = segue.destination as! CenkersDetailViewController
                destVC.facilityToDisplay = facility
        }
    }

}
//MARK: -Search functionality
extension FacilityTableViewController: UISearchResultsUpdating {
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredFacilities = facilities.filter { facility in
            return facility.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
