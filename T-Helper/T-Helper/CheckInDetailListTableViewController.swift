//
//  CheckInDetailListTableViewController.swift
//  T-Helper
//
//  Created by zjajgyy on 2016/11/25.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class CheckInDetailListTableViewController: UITableViewController {
    //var checkInNumberList = [CheckInNumber(1, CheckInDetail("12:00-13:00", "思东", CheckInTaskList("写一遍英语报告"), "ios真难"))]
    //var planList = [["1", "12:00-13:00", "思东", "ios真难"], ["2", "12:00-13:00", "思东", "ios真难"], ["1", "12:00-13:00", "思东", "ios真难"], ["2", "12:00-13:00", "思东", "ios真难"]]
    //var taskList = [["1", "2"], ["3", "4"], ["5", "6"], ["7", "8"]]
    var planList: Array<PlanEntity>!
    var taskList: Array<TaskEntity>!
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        print(index)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return planList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckInDetailListCell", for: indexPath) as! CheckInDetailListTableViewCell

        // Configure the cell
        let plan = planList[indexPath.row]
        cell.checkInNumberLabel.text = "第\(indexPath.row+1)次打卡记录"
        print(">>>>>>>>>> 打卡日历：")
        print(plan)
        cell.timeLabel.text = "\(String(describing: plan.start_time!))-\(String(describing: plan.end_time!))"
        cell.positionLabel.text = plan.location
        cell.notesTextView.text = plan.note

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CheckInDetailShowStudyTask",
            let indexPath = tableView.indexPathForSelectedRow,
            let checkInDetailTaskListTableViewController = segue.destination as? CheckInDetailTaskListTableViewController {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                let planID = planList[indexPath.row].id
                self.taskList = appDelegate?.selectCurrentTasks(id: planID!)
                checkInDetailTaskListTableViewController.taskList = self.taskList
            //checkInDetailTaskListTableViewController.taskList = planList[indexPath.row]
            
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
