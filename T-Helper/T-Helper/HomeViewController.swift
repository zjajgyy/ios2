//
//  HomeViewController.swift
//  T-Helper
//
//  Created by 李鹏翔 on 2016/11/30.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dailyWordTextLabel: UILabel!
    
    @IBOutlet weak var dailyWordAuthorLabel: UILabel!
    
    @IBOutlet weak var dailyWordCoverImg: UIImageView!
    
    // 打卡次数
    @IBOutlet weak var attendTimesLabel: UILabel!
    
    // 累计学习时间: 单位小时
    @IBOutlet weak var learnTimeLabel: UILabel!
    
    
    @IBOutlet weak var unfinishedTasksTableView: UITableView!
    
    
    var id = 0
    
    var dailyWord = DailyWord()
    
    var unfinishedTasks = [TaskEntity]()
    
    var userName = "default_user"
    
    var currUser: UserEntity!
    
    //var batchSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        unfinishedTasksTableView.delegate = self
        unfinishedTasksTableView.dataSource = self
        unfinishedTasksTableView.allowsMultipleSelection = true
        
        
        
        dailyWordTextLabel.numberOfLines = 0
        dailyWordTextLabel.lineBreakMode = .byWordWrapping
        
        
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            currUser = appDelegate.selectUser(username: userName)
            let ua = currUser.username
            if ua == nil {
                
                appDelegate.saveUser(user: currUser, id: "1", username: userName, count: "0", total_duration: "00:00:00", sound: true, vibration: true)
            }
            
            attendTimesLabel.text = currUser.count
            //let temp = currUser.total_duration?.characters.split(separator: ":")
            
            print("user: \(currUser.username)  times: \(currUser.count)  total_duration: \(currUser.total_duration)")
            let temp = currUser.total_duration?.components(separatedBy: ":")
            let h = temp?[0]
            let m = temp?[1]
            let display: Int = Int(h!)! * 60 + Int(m!)!
            print("hour:\(h)-----minute:\(m)")
            learnTimeLabel.text = String(format: "%d", display)
            
            unfinishedTasks = appDelegate.selectTasksByStatus(status: TaskStatus.UNCHECKED)
            
//            if unfinishedTasks.isEmpty {
//                let t = TaskEntity(context: appDelegate.persistentContainer.viewContext)
//                t.content = "熟悉T-Helper这个应用"
//                t.state = TaskStatus.CHECKED
//                t.id = UUID().uuidString
//                t.plan_id = "1"
//                unfinishedTasks.append(t)
//                
//                let t1 = TaskEntity(context: appDelegate.persistentContainer.viewContext)
//                t1.content = "创建一个自己的学习计划"
//                t1.state = TaskStatus.CHECKED
//                t1.id = UUID().uuidString
//                t1.plan_id = "1"
//                unfinishedTasks.append(t1)
//                
//                
//                
//            }
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
    
    
    // 点击“换一换”按钮
    @IBAction func changeDailyWord(_ sender: UIButton) {
        
        fetchDailyWord()
        print("Changed the daily words.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchDailyWord()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func fetchDailyWord() -> Void {
        dailyWord.id = nextId()
        dailyWord.isFetched = false
        dailyWord.isEntityFetched = false
        dailyWord = dailyWord.entity
        dailyWordTextLabel.text = dailyWord.desc
        dailyWordAuthorLabel.text = "-- " + dailyWord.author!
        dailyWordCoverImg.image = dailyWord.image
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(wordFetched),
            name: NSNotification.Name("WordsFetched"),
            object: dailyWord)
    }
    
    
    func wordFetched() {
        dailyWord = dailyWord.entity
        dailyWordTextLabel.text = dailyWord.desc
        dailyWordAuthorLabel.text = "-- " + dailyWord.author!
        dailyWordCoverImg.image = dailyWord.image
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(imageFetched),
            name: NSNotification.Name("ImageFetched"),
            object: dailyWord
        )
        
    }
    
    func imageFetched() -> Void {
        dailyWordCoverImg.image = dailyWord.image
    }
    
    
    func nextId() -> Int {
        if self.id < 3 {
            self.id += 1
        } else {
            self.id = 1
        }
        return self.id
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return unfinishedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "unfinishedTaskCell", for: indexPath) as! UnfinishedTaskTableViewCell
        
        let t = unfinishedTasks[indexPath.row]
        if t.state == TaskStatus.UNCHECKED {
            cell.checked = false
            cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "radio"), for: .normal)
        } else {
            cell.checked = true
            cell.checkBtn.setBackgroundImage(#imageLiteral(resourceName: "radio-selected"), for: .normal)

        }
        
        cell.detailLabel.text = t.content
        cell.id = t.id
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddSchedule",
            let addScheduleController = segue.destination as? AddScheduleViewController {
            var tasks = [TaskEntity]()
            // 筛选出已选中的task，传到新建页面
            for t in unfinishedTasks {
                if t.state == TaskStatus.CHECKED {
                    tasks.append(t)
                }
            }
            // 将tasks传到“增加计划”界面
            addScheduleController.tasks = tasks
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "unfinishedTaskCell", for: indexPath) as! UnfinishedTaskTableViewCell
        
        //print("\(cell.detailLabel.text): \(cell.checked)")
        
        //print(indexPath.row)
        
        let task = unfinishedTasks[indexPath.row]
        
        if task.state == TaskStatus.UNCHECKED {
            task.state = TaskStatus.CHECKED
        } else {
            task.state = TaskStatus.UNCHECKED
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let t = unfinishedTasks[indexPath.row]
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                appDelegate.deleteTask(task: t)
                unfinishedTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    
    // 批量任务操作：全选，全部取消选择
    @IBAction func batchToggle(_ sender: UIButton) {
        
        for i in unfinishedTasks {
            if i.state == TaskStatus.CHECKED {
                i.state = TaskStatus.UNCHECKED
            } else {
                i.state = TaskStatus.CHECKED
            }
            let indexPath = IndexPath(row: unfinishedTasks.index(of: i)!, section: 0)
            unfinishedTasksTableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
    
}
