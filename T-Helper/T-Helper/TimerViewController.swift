//
//  TimerViewController.swift
//  T-Helper
//
//  Created by 陈陈陈 on 2016/11/27.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit
import AudioToolbox

class TimerViewController: UIViewController {

    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var PauseButton: UIButton!
    
    @IBOutlet weak var FinishButton: UIButton!
    
    var timer:DispatchSourceTimer!
    var timeHour:Int = 0
    var timeMin:Int = 0
    var timeSec:Int = 0
    var timeOut:Int = 0
    var total_time:Int=0
    var timerThread:Thread!
    var queue:DispatchQueue!
    var checkButton:Int=0
    
    let appdelegate = UIApplication.shared.delegate as?
    AppDelegate
    //var plan_id:String!
    var planEntity:PlanEntity!
    var taskList:[TaskEntity]!
    var userEntity:UserEntity!
    let username = "default_user"

    
   // var currentPlanList = ["计划1：iOSiOS满脑子都是你呀","计划2：前端作业真难","计划3：前端作业真难","计划4：前端作业真难","计划4：前端作业真难","计划4：前端作业真难","计划4：前端作业真难","计划4：前端作业真难","计划4：前端作业真难","计划4：前端作业真难","计划4：前端作业真难"]
   
    
    @IBAction func PauseButton(_ sender: UIButton) {
        //TODO->todo:切三张图
        FinishButton.backgroundColor = UIColor.white
        FinishButton.layer.borderColor = UIColor.white.cgColor
        FinishButton.isUserInteractionEnabled = true
        if checkButton == 0 {
           // sender.titleLabel?.text = "暂停"
            sender.setTitle("暂停", for: .normal)
            //sender.setBackgroundImage(UIImage(named:"background-stop.png"), for: .normal)
            print("开始计时")
            checkButton = 1
            startTimer()
            //MARK:数据库操作(planEntity,start_time,state)
            let currentTime = getCurrentDate()[1]
            self.planEntity = appdelegate?.startNewPlan(planEntity:planEntity, start_time: currentTime, state: PlanStatus.DOING)
            
        }else if checkButton == 1{
            sender.setTitle("继续", for: .normal)
            print("暂停")
            checkButton = 2
            pauseTimer()
        }else if checkButton == 2{
           // sender.titleLabel?.text = "暂停"
            sender.setTitle("暂停", for: .normal)
            print("继续")
            checkButton = 0
            timer.resume()
        }
        
    }
    
    func getCurrentDate() -> ([String]){
        let date = Date()
        let components = Calendar.current.dateComponents(Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second]), from: date)
        print(components)
        let currentDate = String(format:"%02d",components.year!) + ":" + String(format:"%02d",components.month!)+":" + String(format:"%02d",components.day!)
        let currentTime = String(format:"%02d",components.hour!) + ":" + String(format:"%02d",components.minute!)+":" + String(format:"%02d",components.second!)
        print("当前时间：" + currentDate + currentTime)
        let time = [currentDate,currentTime]
        return time
        
        
    }

    
    //开启新线程
    func startTimer(){
        print("进入子线程 startTimer")
        timeOut = self.timeHour*3600 + self.timeMin*60 + self.timeSec
        
        queue = DispatchQueue.global()
        timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        resumeTimer()
    }
    
    func pauseTimer(){
        timer.suspend()
    }
    
    func resumeTimer(){
        
        print("timerReusme")

        timer.setEventHandler {
            //NSLog("timer exec!")
            if self.timeOut < 0 {
                DispatchQueue.main.async {
                    //定时结束UI处理
                    print("定时结束，处理UI")
                    self.showAlertMessage(message: "计时结束")
                    self.cancelTimer()
                    self.PauseButton.setTitle("开始", for: .normal)
                    //self.checkButton = 3
                }
            }else{
                self.timeHour = self.timeOut/3600
                self.timeMin = (self.timeOut%3600)/60
                self.timeSec = self.timeOut-self.timeMin*60-self.timeHour*3600
                let timeString = String(format: "%02d:%02d:%02d", arguments: [self.timeHour,self.timeMin, self.timeSec])
                //print("timeString" + timeString)
                DispatchQueue.main.async {
                    self.TimerLabel.text = timeString
                }
                
                self.timeOut -= 1
            }
            
        }
        timer.resume()

    }
    
    func cancelTimer(){
        if timer != nil{
            print("取消timer")
//            timer.setEventHandler{
//                self.remind()
//            }
            timer.cancel()
            //label重置为0
            let timeString = String(format: "%02d:%02d:%02d", arguments: [0,0,0])
            print("timeString" + timeString)
            DispatchQueue.main.async {
                self.TimerLabel.text = timeString
            }

        }
    }
    
    private func showAlertMessage(message:String){
        let alertController = UIAlertController(title:"倒计时", message:message, preferredStyle:.alert)
        let alertAction = UIAlertAction(title:"ok", style:.cancel, handler:nil)
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    //用于调用提醒
    func remind(){
        print("倒计时提醒remind")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.selectRemindSound(username: "default_user") == true){
            let soundIDTest: SystemSoundID = 1005;
            AudioServicesPlaySystemSound(soundIDTest)
        } else if (appDelegate.selectRemindVibration(username: "default_user") == true) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //self.taskList = appdelegate?.selectCurrentTasks(id: plan_id)
        
        if segue.identifier == "ShowCurrentTaskList",
            let checkInDetailTaskListTableViewController = segue.destination as? CheckInDetailTaskListTableViewController {
            //MARK:2.1从数据库获取本次计划列表传给checkInDetailTaskListTableViewController

            checkInDetailTaskListTableViewController.taskList = taskList
            print("跳转到查看当前计划列表页面TimerViewControler--->CheckInDetailTableViewController:taskList.count\(taskList.count)")
            
        } else if self.checkButton != 0,segue.identifier == "CheckInCurrentPlan",
            let checkInViewController = segue.destination as? CheckInViewController{
            //点击完成按钮,停止计时器，跳转页面
            
            self.remind()
            self.cancelTimer()
            self.PauseButton.setTitle("开始", for: .normal)
            self.FinishButton.isUserInteractionEnabled = false
            
            
            userEntity = appdelegate?.selectUser(username: username)
            let duration = calDuration(total_duration: userEntity.total_duration!)
            
            planEntity = appdelegate?.finishNewPlan(planEntity: self.planEntity, end_time: getCurrentDate()[1], actual_duration:duration[0],state: PlanStatus.FINISHED)
          
            print("username:\(userEntity.username) \(userEntity.count) \(userEntity.total_duration)")
            let count = Int(userEntity.count!)!+1
            print("存入打卡次数:\(count)")
            userEntity = appdelegate?.updateUser(userEntity: userEntity!, count: "\(count)", total_duration:duration[1])
            //print("即将跳转到打卡页面")
            //MARK:2.2CheckInListTableViewController
            checkInViewController.taskList = self.taskList
            checkInViewController.planEntity = self.planEntity
            print("跳转到打卡页面TimeViewController---->CheckInListTableViewController")
            
        }
    }
    
    func calDuration(total_duration:String)->[String]{
        let total_durationArray = userEntity.total_duration?.components(separatedBy: ":")
        var total_hour = Int((total_durationArray?[0])!)
        var total_min = Int((total_durationArray?[1])!)
        var total_sec = Int((total_durationArray?[2])!)
        
        print("total_durationArray:\(total_hour)----\(total_min)----\(total_sec)")

        let actual_duration = total_time - timeOut
        
        let total_duration = actual_duration + (total_hour!*3600 + total_min!*60 + total_sec!)
        
        let actual_hour = actual_duration/3600
        let actual_minute = (actual_duration - actual_hour*3600)/60
        let actual_second = actual_duration - actual_hour*3600 - actual_minute*60
        
        total_hour =  total_duration/3600
        total_min =  (total_duration - total_hour!*3600)/60
        total_sec = total_duration - total_hour!*3600 - total_min!*60
        
        //let second = total - hour*3600 - minute*60
        
        let actual_duration_str = String(format: "%02d:%02d:%02d", arguments: [actual_hour,actual_minute,actual_second])
        let total_duration_str = String(format: "%02d:%02d:%02d", arguments: [total_hour!,total_min!,total_sec!])
        print("total_duration_str" + total_duration_str)
        print("actual_duration_str" + actual_duration_str)
        return [actual_duration_str,total_duration_str]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PauseButton.layer.borderColor = UIColor.white.cgColor
        PauseButton.layer.borderWidth = 2
        PauseButton.layer.cornerRadius = PauseButton.frame.width*0.5
        PauseButton.backgroundColor = UIColor.white
        
        FinishButton.layer.borderColor = UIColor.lightGray.cgColor
        FinishButton.layer.borderWidth = 2
        FinishButton.layer.cornerRadius = FinishButton.frame.width*0.5
        FinishButton.backgroundColor = UIColor.lightGray
        FinishButton.isUserInteractionEnabled = false
        
        //MARK:planEntity是从翔那边获取的
        let time = planEntity.plan_duration?.components(separatedBy: ":")
        taskList = appdelegate!.selectCurrentTasks(id: planEntity.id!)
        print("数据库获取的tasklist.count:\(taskList.count) plan_id:\(planEntity.id)")
        for i in 0...(taskList.count-1){
            print("task content: \(taskList[i].content) task.plan_id:\(taskList[i].plan_id)")
        }
        timeHour = Int((time?[0])!)!
        timeMin = Int((time?[1])!)!
        let timeString = String(format: "%02d:%02d:%02d", arguments: [self.timeHour,self.timeMin, self.timeSec])
        TimerLabel.text = timeString
        
        total_time = self.timeHour*3600 + self.timeMin*60 + self.timeSec
        print("total_time:\(total_time)")
        print("计划时长\(timeString)")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if !(self.navigationController?.viewControllers.contains(self))!
        {
            print("用户点击返回按钮")
            cancelTimer()
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

}
