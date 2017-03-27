//
//  SettingRemindTableViewController.swift
//  T-Helper
//
//  Created by zjajgyy on 2016/12/1.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit
import AudioToolbox

class SettingRemindTableViewController: UITableViewController {
    
    @IBOutlet weak var vibrateSwitch: UISwitch!
    
    @IBOutlet weak var soundSwitch: UISwitch!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //从数据库获得数据
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //print("\(appDelegate.selectUser(username: "default_user").count)")
        self.vibrateSwitch.setOn(appDelegate.selectRemindVibration(username: "default_user"), animated: true)
        self.soundSwitch.setOn(appDelegate.selectRemindSound(username: "default_user"), animated: true)
        
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
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    @IBAction func vibrateAction(_ sender: Any) {
        vibrateSwitch.setOn(!vibrateSwitch.isOn, animated: true)
        print("vibrate: \(vibrateSwitch.isOn)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.updateRemindVibration(vibrationOption: vibrateSwitch.isOn, username: "default_user")
    }
    
    
    @IBAction func soundAction(_ sender: Any) {
        soundSwitch.setOn(!soundSwitch.isOn, animated: true)
        print("sound: \(soundSwitch.isOn)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.updateRemindSound(soundOption: soundSwitch.isOn, username: "default_user")
        
    }
    
    //用于调用提醒
    func remind(){
        if (soundSwitch.isOn == true){
            let soundIDTest: SystemSoundID = 1005;
            AudioServicesPlaySystemSound(soundIDTest)
        } else if (vibrateSwitch.isOn == true) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
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
