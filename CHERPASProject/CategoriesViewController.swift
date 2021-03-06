//
//  CategoriesViewController.swift
//  CHERPASProject
//
//  Created by Rachel Pavilanis on 1/3/17.
//  Copyright © 2017 Rachel Pavilanis. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesViewController: UITableViewController {
    
    var categories = ["Cleanliness", "Healthy Eating", "Exercise", "Relationships", "Personal Development", "Action-Based Living", "Spirituality"]
    
//    var dailyTasks = ["Clean bathroom", "Eat 3 servings of veggies", "Week 3, Day 1 of C25K", "Call Lila", "Read 30 minutes", "Do January budget", "Meditate 20 minutes - Headspace"]
    var dailyTask = [String]()
    
    var monthlyGoals = ["Clean for 15 minutes each day.", "H Goal", "E Goal", "R Goal", "P Goal", "A Goal",
        "S Goal"]
    
    var yearlyGoals = ["At monthly check-ins, the apartment will be clean and organized due to gradual daily cleaning.", "H Goal", "E Goal", "R Goal", "P Goal", "A Goal","S Goal"]
    
    var quotes = ["Our goals can only be reached through a vehicle of a plan, in which we must fervently believe and upon which we must vigorously act. There is no other route to success.", "H Quote", "E Quote", "R Quote", "P Quote", "A Goal","S Quote"]


    override func viewDidLoad() {
        super.viewDidLoad()
        queryTasks()
        // This removes the label on the back bar - remove this if I want to add label back in for this.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // need to change this as soon as I can back to categories.count 
        return dailyTask.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        let categoryName = categories[indexPath.row]
        // this code works - but not enough space to include name and task detail - just want to display task
//        cell.textLabel?.text = categoryName
       
        cell.detailTextLabel?.text = dailyTask[indexPath.row]
        
        
        cell.detailTextLabel?.textColor = UIColor(red: 27/255, green: 124/255, blue: 150/255, alpha: 1.0)
        cell.textLabel?.text = categories[indexPath.row]
        cell.imageView?.image = UIImage(named: categoryName)
        
        return cell
    }

        
//        cell.textLabel?.text = "Category OR Daily Task"
//        cell.imageView?.image = UIImage(named: "first-image")
//        return cell
//    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dayOverview" {
            let dayOverview = segue.destination as! DayOverviewViewController
            if let indexpath = self.tableView.indexPathForSelectedRow {
                let taskItem = dailyTask[indexpath.row] as String
                dayOverview.sentData1 = taskItem
                
                let monthGoal = monthlyGoals[indexpath.row] as String
                dayOverview.sentData2 = monthGoal
                
                let yearGoal = yearlyGoals[indexpath.row] as String
                dayOverview.sentData3 = yearGoal
                
                let dailyQuote = quotes[indexpath.row] as String
                dayOverview.sentData4 = dailyQuote
                
                let CHERPAS = categories[indexpath.row] as String
                dayOverview.sentData5 = CHERPAS
            }
        }

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func queryTasks() {
        
        let todayStart = Calendar.current.startOfDay(for: Date() as Date)
        let todayEnd: Date = {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        
        let realm = try! Realm()
        
        let allTasks = realm.objects(DailyTask)
        // will also need to add filter so that it includes only appropriate category as well
        let currentTask = allTasks.filter("createdAt BETWEEN %@", [todayStart, todayEnd])
        
        for task in currentTask{
            dailyTask.append(task.name)
            
            tableView.reloadData()
        }
        
    }

    

}
