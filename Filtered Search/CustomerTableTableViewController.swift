//
//  CustomerTableTableViewController.swift
//  Filtered Search
//
//  Created by Amalan Dhananjayan on 10/22/14.
//  Copyright (c) 2014 Batzee. All rights reserved.
//

import UIKit

class CustomerTableTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var customers = [Customer]()
    var filteredCustomers = [Customer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sample Data for candyArray
        self.customers = [Customer(category:"Chocolate", name:"chocolate Bar"),
            Customer(category:"Chocolate", name:"chocolate Chip"),
            Customer(category:"Chocolate", name:"dark chocolate"),
            Customer(category:"Hard", name:"lollipop"),
            Customer(category:"Hard", name:"candy cane"),
            Customer(category:"Hard", name:"jaw breaker"),
            Customer(category:"Other", name:"caramel"),
            Customer(category:"Other", name:"sour chew"),
            Customer(category:"Other", name:"gummi bear")]
        
        // Reload the table
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredCustomers.count
        } else {
            return self.customers.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as   //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cellid", forIndexPath: indexPath) as UITableViewCell
        var customer : Customer
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            customer = filteredCustomers[indexPath.row]
        } else {
            customer = customers[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel!.text = customer.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell

    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // Filter the array using the filter method
        self.filteredCustomers = self.customers.filter({( customer: Customer) -> Bool in
            let categoryMatch = (scope == "All") || (customer.category == scope)
            let stringMatch = customer.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
        return true
    }
    
    
    /* //fornormal search
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("customerDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "customerDetail" {
            let customerDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredCustomers[indexPath.row].name
                customerDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.customers[indexPath.row].name
                customerDetailViewController.title = destinationTitle
            }
        }
    }

}
