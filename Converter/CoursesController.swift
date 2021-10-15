//
//  CoursesController.swift
//  Converter
//
//  Created by Илья Викторов on 23.09.2021.
//

import UIKit

class CoursesController: UITableViewController {

    @IBAction func refreshAction(_ sender: Any) {
        Model.shared.loadXMLFile(date: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "startLoadingXML"), object: nil, queue: nil) { (notification) in
        
            DispatchQueue.main.async {
                let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
                activityIndicator.startAnimating()
                self.navigationItem.rightBarButtonItem?.customView = activityIndicator
            }
                
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "dataRefreshed"), object: nil, queue: nil) { (notification) in
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = Model.shared.currentDate
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.refreshAction(_:)))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
           
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "ErrorWhenXMLloading"), object: self, queue: nil) { (notification) in
            
            let errorName = notification.userInfo?["ErrorName"]
            print(errorName)
            
            DispatchQueue.main.async {
                let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
                activityIndicator.startAnimating()
                self.navigationItem.rightBarButtonItem?.customView = activityIndicator
            }
        }
        
        navigationItem.title = Model.shared.currentDate
        Model.shared.loadXMLFile(date: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.shared.currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let courseForCell = Model.shared.currencies[indexPath.row]
        
        cell.textLabel?.text = courseForCell.Name
        cell.detailTextLabel?.text = courseForCell.Value

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
