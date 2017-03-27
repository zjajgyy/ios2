//
//  AddScheduleViewController.swift
//  T-Helper
//
//  Created by 李鹏翔 on 2016/11/27.
//  Copyright © 2016年 thelper. All rights reserved.
//
import Foundation
import UIKit

class AddScheduleViewController: UIViewController,
    UIPickerViewDelegate, UIPickerViewDataSource,
    UITableViewDelegate, UITableViewDataSource
     {
    //UITableViewDelegate, UITableViewDataSource

    @IBOutlet weak var planHourLabel: UILabel!
    
    @IBOutlet weak var planMinuteLabel: UILabel!
    
    @IBOutlet weak var pickerStackView: UIStackView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet weak var setPositionButton: UIButton!
    
    let HOUR_LEN = 13
    let MINUTE_LEN = 6
    
    let pickerOffset: CGFloat = 360
    
    var tasks = [TaskEntity]()
    var position: String!
    
    var currPlan: PlanEntity?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //将dataSource设置成自己
        pickerView.dataSource = self
        //将delegate设置成自己
        pickerView.delegate = self
        //设置选择框的默认值
        pickerView.selectRow(1, inComponent:1, animated:true)
        pickerView.selectRow(1, inComponent:0, animated:true)
        
        
//        for i in 1...5 {
//            tasks.append(ScheduleTask(detail: "这是一个我计划的任务-\(i)"))
//        }
        
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        self.taskTableView.allowsMultipleSelection = true
        
        
        //NSUUID().UUIDString
//        let uuid = UUID().uuidString
//        print(uuid)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            var idGen = appDelegate.selectPlanCount()
            idGen += 1
            currPlan = PlanEntity(context: appDelegate.persistentContainer.viewContext)
            currPlan?.id = String(idGen)
            currPlan?.plan_duration = "01:00"
            // 设置新建的日期
            let df = DateFormatter()
            df.dateFormat = "YYYY-MM-dd"
            currPlan?.date = df.string(from: Date())
            print("aaaaaaaaaa:\(currPlan?.date)")
            currPlan?.state = PlanStatus.NOT_START
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        if segue.identifier == "SetPosition", let nearbyViewController = segue.source as? NearbyViewController {
                self.position = nearbyViewController.addressTextField.text
        }
        print("pppppp: "+self.position)
        self.setPositionButton.setTitle(self.position, for: .normal)
    }
    
    @IBAction func showPickerView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerStackView.frame.origin.y += self.pickerOffset
        })
    }
    
    
    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    //设置选择框的行数为9行，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.HOUR_LEN
        } else if component == 2 {
            return self.MINUTE_LEN
        } else {
            return 1
        }
    }
    
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        if component == 0 {
            return String(format: "%02d", self.getHourByRow(row: row))
        } else if component == 1 {
            return "小时"
        } else if component == 2 {
            return String(format: "%02d", self.getMinutesByRow(row: row))
        } else if component == 3 {
            return "分钟"
        }
        return "err"
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        
        let selectedHour = self.getHourByRow(row: pickerView.selectedRow(inComponent: 0))
        let selectedMinute = self.getMinutesByRow(row: pickerView.selectedRow(inComponent: 2))
        print("selected hour: \(selectedHour), selected minute: \(selectedMinute)")
        
        self.planHourLabel.text = String(selectedHour)
        self.planMinuteLabel.text = String(selectedMinute)
        
        self.currPlan?.plan_duration = "\(selectedHour):\(selectedMinute)"
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pickerStackView.frame.origin.y -= self.pickerOffset
        })
    }
    
    @IBAction func addScheduleTask(_ sender: UIButton) {
        
        let alertCtl = UIAlertController(title: "增加计划任务", message: "", preferredStyle: .alert)
        
        alertCtl.addTextField {
            (textField: UITextField!) -> Void in
                textField.placeholder = "任务描述不超过15个字"
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            //也可以用下标的形式获取textField let login = alertController.textFields![0]
            let taskDetail = alertCtl.textFields!.first!.text
            print("新建任务：\(taskDetail)")
            
            if taskDetail == nil || (taskDetail?.isEmpty)! {
                return
            }
            
            let len = taskDetail?.lengthOfBytes(using: .utf8)
            if (len)! > 45 {
                return
            }
            
            let newIndexPath = IndexPath(row: self.tasks.count, section: 0)
            // save a entity and return one
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let newTask = TaskEntity(context: appDelegate.persistentContainer.viewContext)
                newTask.content = taskDetail
                newTask.id = UUID().uuidString
                newTask.plan_id = self.currPlan?.id
                newTask.state = TaskStatus.CHECKED
                
                appDelegate.saveContext()
                
                self.tasks.append(newTask)
            }
            
            self.taskTableView.insertRows(at: [newIndexPath], with: .bottom)
            
        })
        alertCtl.addAction(cancelAction)
        alertCtl.addAction(okAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
    
    func getMinutesByRow(row: Int) -> Int {
        return row * 10
    }
    
    func getHourByRow(row: Int) -> Int {
        return row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        let t = tasks[indexPath.row]
        if t.state == TaskStatus.UNCHECKED {
            cell.checked = false
            cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "radio"), for: .normal)
        } else {
            cell.checked = true
            cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "radio-selected"), for: .normal)
            
        }
        cell.detailLabel.text = tasks[indexPath.row].content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let t = tasks[indexPath.row]
        
        if t.state == TaskStatus.UNCHECKED {
            tasks[indexPath.row].state = TaskStatus.CHECKED
        } else {
            tasks[indexPath.row].state = TaskStatus.UNCHECKED
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        // 点击创建，创建计划操作创建
    
        
        var isEmpty = true
        
        for i in tasks {
            if i.state == TaskStatus.CHECKED {
                i.plan_id = currPlan?.id
                isEmpty = false
            }
        }
        
        if !isEmpty {
            
            if segue.identifier == "EnterCountDownPage",
                let timeViewController = segue.destination as?
                TimerViewController {
                //var checked = [TaskEntity]()
                
                // 设置地点
                currPlan?.location = setPositionButton.currentTitle
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.saveContext()
                    
                    let l = appDelegate.selectTasksByPlan(planId: currPlan?.id)
                    print(">>>>>> Add plan success.")
                    print(">>>>>> Created plan: id=\(currPlan?.id)")
                    print(">>>>>> Task list:")
                    for i in l {
                        print("id: \(i.id) content: \(i.content) state: \(i.state)")
                    }
                    print("<<<<<<< End")
                }
                
                timeViewController.planEntity = currPlan
                
            }
        } else {
            alert(msg: "选择任务为空", title: "警告")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let t = tasks[indexPath.row]
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                appDelegate.deleteTask(task: t)
                tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
        
    }
    
    func alert(msg: String, title: String) -> Void {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
