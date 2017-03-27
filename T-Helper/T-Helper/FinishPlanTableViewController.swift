//
//  FinishPlanTableViewController.swift
//  T-Helper
//
//  Created by 陈陈陈 on 2016/12/2.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class FinishPlanTableViewController: UITableViewController {
    
    
    @IBOutlet weak var StudyTimeLabel: UILabel!
    @IBOutlet weak var StudyLocationLabel: UILabel!
    @IBOutlet weak var NoteTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    
    var planEntity:PlanEntity!
    let username = "default_user"

    
    let appdelegate = UIApplication.shared.delegate as?
    AppDelegate
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "RedirectToMainPage",
//            //  let indexPath = tableView.indexPathForSelectedRow,
//            let ho = segue.destination as? FinishPlanTableViewController {
//                
//        }
//    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //MARK:1.通过planEntity显示时间地点等信息

        StudyTimeLabel.text = planEntity.start_time! + "-" + planEntity.end_time!
        StudyLocationLabel.text = planEntity.location
        NoteTextView.layer.borderColor = UIColor(red: 32/255.0, green:
            158/255.0, blue: 133/255.0, alpha: 1.0).cgColor
        let userEntity = appdelegate?.selectUser(username: username)
        //let count = userEntity?.count?.components(separatedBy: """)
        let count = userEntity?.count
        print(count)
        
        //print("总打卡次数：\(count?[1])")
        //var count = userEntity!.count?
       // count = count.su
        countLabel.text = "第\(Int(count!)!)打卡"
        NoteTextView.layer.borderWidth = 2;
        NoteTextView.layer.cornerRadius = 16;
    }
    
    @IBAction func FinishPlanButton(_ sender: UIButton) {
        //MARK:2.点击“完成按钮”将note插入数据库
        self.planEntity = appdelegate?.addNoteForPlan(planEntity: planEntity, note: NoteTextView.text)
        print("添加备注，点击完成按钮回到首页")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
