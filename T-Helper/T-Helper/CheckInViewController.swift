//
//  CheckInViewController.swift
//  T-Helper
//
//  Created by 陈陈陈 on 2016/11/28.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var planTableView: UITableView!
    @IBOutlet weak var studyTime: UILabel!

    var planEntity:PlanEntity!
    var plan_id:String!
    var taskList:[TaskEntity]!
    let appdelegate = UIApplication.shared.delegate as?
    AppDelegate
    let username = "default_user"
    var selectedIndexs:[Int]=[]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK:4.给完成页面传过去一个plan实体（减少一次查询数据库）
        if segue.identifier == "EnterFinishedPage",
            let finishPlanTableViewController = segue.destination as? FinishPlanTableViewController {
            finishPlanTableViewController.planEntity = self.planEntity
        }
    }

    @IBAction func CheckInButton(_ sender: UIButton) {
        
        //MARK:3.点击“打卡”修改数据库：某个计划的全部task的状态修改
        appdelegate?.updateTaskListState(taskEntityList: taskList)
        for i in 0...(taskList.count-1){
            print("打卡:\(taskList[i].content)——\(taskList[i].state)")
        }
        print("修改task列表的状态")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.view!.addSubview(planTableView)
        self.planTableView.dataSource = self
        self.planTableView.delegate = self
        self.planTableView.allowsMultipleSelection = true;
        //let  = appdelegate?.selectUser(username: username)
        print("本次学习时长:\(planEntity?.actual_duration)")
        studyTime.text = "\((planEntity?.actual_duration)!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckInPlanCell", for: indexPath) as! CheckInListTableViewCell
        cell.planLabel.text = taskList[indexPath.row].content
        //判断是否选中（选中单元格尾部打勾）
        if selectedIndexs.contains(indexPath.row) {
           // cell.checkButton.
            cell.checkButton.setBackgroundImage(#imageLiteral(resourceName: "radio-selected"), for: .normal)
        } else {
            //cell.accessoryType = UITableViewCellAccessoryType.None
            cell.checkButton.setBackgroundImage(#imageLiteral(resourceName: "radio"), for: .normal)
            taskList[indexPath.row].state = TaskStatus.UNCHECKED
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Configure the cell...
        //MARK:2.修改tasklist的state，为存储到数据库做准备
        
        //判断该行原先是否选中        
        if let index = selectedIndexs.index(of:indexPath.row){
            selectedIndexs.remove(at: index) //原来选中的取消选中
            taskList[indexPath.row].state = TaskStatus.UNCHECKED
        }else{
            selectedIndexs.append(indexPath.row) //原来没选中的就选中
            taskList[indexPath.row].state = TaskStatus.CHECKED
        }
        
        //刷新该行
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
