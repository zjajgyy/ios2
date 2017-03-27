//
//  AppDelegate.swift
//  T-Helper
//
//  Created by zjajgyy on 2016/11/24.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //change the color and text of the navigation bar
        UINavigationBar.appearance().barTintColor = UIColor(red: 32/255.0, green:
            158/255.0, blue: 133/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        if let barFont = UIFont(name: "Futura", size: 25.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:barFont]
        }
        
        //获取初次启动标志
        let sign:Bool = UserDefaults.standard.bool(forKey: "FirstSign")
        
        //如果没有获取不到，并设置其为true
        if(!sign){
            UserDefaults.standard.set(true, forKey: "FirstSign")
        }else{
            //获得Main.storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainPage = storyboard.instantiateViewController(withIdentifier: "MainPage")
            self.window?.rootViewController = mainPage
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "T-Helper")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //coredata操作
    //MARK:1.为一个plan创建新的任务列表
    func addNewTask(id:String,plan_id:String,content:String)->TaskEntity{
        let task = TaskEntity(context: persistentContainer.viewContext)
        task.id = id
        task.plan_id = plan_id
        task.content = content
        print("saving a new task")
        saveContext()
        return task
    }
    //MARK:2.创建新计划(日期，计划完成时间，开始时间,任务集合)
    func addNewPlan(id:String,date:String,plan_duration:String,start_time:String,taskList:[[String]]){
        let plan = PlanEntity(context: persistentContainer.viewContext)
        var taskEntitySet:[TaskEntity]=[]
        plan.id = id
        plan.date = date
        plan.plan_duration = plan_duration
        plan.start_time = start_time
        for i in 0...(taskList.count-1){
            let task = taskList[i]
            let taskEntity = addNewTask(id:task[0], plan_id: id, content: task[1])
            taskEntitySet.append(taskEntity)
        }
        saveContext()
    }
    
    //MARK:3.点击“创建”开始新计划(id，start_time，state)
    func startNewPlan(planEntity:PlanEntity,start_time:String,state:String)->PlanEntity{
        print("coredata------点击“开始”开始新计划")
        planEntity.start_time = start_time
        planEntity.state = state
        saveContext()
        return planEntity
    }
    
    
    //MARK:4.完成计划，更新计划实体信息
    func finishNewPlan(planEntity:PlanEntity,end_time:String,actual_duration:String,state:String)->PlanEntity{
        print("coredata------完成新计划")
        planEntity.end_time = end_time
        planEntity.actual_duration = actual_duration
        planEntity.state = state
        saveContext()
        return planEntity
    }
    
    
    //MARK:点击“打卡”修改task列表的状态，传入task实体列表和对应的state列表
//    func updateTaskListState(taskEntityList:[TaskEntity],stateList:[String]){
//        print("coredata--------点击“打卡”修改task列表的状态")
//
//        for i in 0...taskEntityList.count{
//            taskEntityList[i].state = stateList[i]
//        }
//        saveContext()
//    }
    //MARK:完成页面点击“完成”添加note，传入plan_id和note
    func addNoteForPlan(planEntity:PlanEntity,note:String)->PlanEntity{
        print("coredata--------完成页面添加note")
        planEntity.note = note
        saveContext()
        return planEntity
    }
    
    func updateTaskListState(taskEntityList:[TaskEntity]){
        print("coredata--------点击“打卡”修改task列表的状态")
        saveContext()
    }
    
    //5.记录任务state
    func recordTaskState(id:String,plan_id:String,state:String){
        print("coredata------打卡，记录任务完成与否")
        let task = TaskEntity(context: persistentContainer.viewContext)
        task.id = id
        task.plan_id = plan_id
        task.state = state
        saveContext()

    }
    
    
    //获取当前计划
    func selectCurrentPlan(id:String)->PlanEntity{
        var planEntity:PlanEntity!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanEntity")
            let predicate = NSPredicate(format:"id="+id)
            fetchRequest.predicate = predicate
            planEntity = try
                (persistentContainer.viewContext.fetch(fetchRequest) as?[PlanEntity])?[0]
        } catch {
            print("Failed to fetch plan: \(error)")
        }
        return planEntity
    }
    
    //MARK:查询当前计划里的task列表
    func selectCurrentTasks(id:String)->Array<TaskEntity>{
        var taskList:[TaskEntity]!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            let predicate = NSPredicate(format:"plan_id=\(id)")
            fetchRequest.predicate = predicate
            
            taskList = try
                persistentContainer.viewContext.fetch(fetchRequest) as?[TaskEntity]
        } catch {
            print("Failed to fetch employees: \(error)")
        }
        
        return taskList
    }
    
    
    //删除一条计划
    func deleteTask(id:String){
        var taskList:[TaskEntity]!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            let predicate = NSPredicate(format:"id=1")
            fetchRequest.predicate = predicate
            
            taskList = try
                persistentContainer.viewContext.fetch(fetchRequest) as? [TaskEntity]
        } catch {
            print("Failed to fetch task: \(error)")
        }
        
        for taskEntity in taskList{
            if taskEntity.id == id {
                persistentContainer.viewContext.delete(taskEntity)
                print("deleting the person from context ...")
            }
        }
        saveContext()
    }
    
    // 删除实体
    func deleteTask(task: TaskEntity) {
        do {
            persistentContainer.viewContext.delete(task)
            saveContext()
        } catch {
            print("Fail to delete task. \(error)")
        }
    }
    
    //根据日期查询当天计划
    func selectPlanByDate(date: String) -> Array<PlanEntity>?{
        var planListTemp=[PlanEntity]()
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanEntity")
            let predicate = NSPredicate(format: "date = \""+date+"\"")
                fetchRequest.predicate = predicate
            
            planListTemp = try persistentContainer.viewContext.fetch(fetchRequest) as! [PlanEntity]
        } catch {
            print("Failed to fetch plans: \(error)")
            return nil
        }
        
        print("\(planListTemp.count)")
        //按照id由小至大排序
        var planList = [PlanEntity]()
        var minIndex: Int
        while planListTemp.count != 0 {
            minIndex = 0
            for i in 0...(planListTemp.count-1) {
                if Int(planListTemp[i].id!)! < Int(planListTemp[minIndex].id!)! {
                    minIndex = i
                }
            }
            planList.append(planListTemp[minIndex])
            planListTemp.remove(at: minIndex)
        }
        
        print("\(planList.count)")
        return planList
    }

    
    // just for test
    func selectAllPlans() -> [PlanEntity] {
        var a: [PlanEntity]!
        do {
        
            a = try persistentContainer.viewContext.fetch(PlanEntity.fetchRequest()) as? [PlanEntity]
            
            if !(a?.isEmpty)! {
                for i in a! {
                    print("plan >> id: \(i.id) date: \(i.date)")
                }
            }
            
        } catch {
            print("error when getch all plans")
        }
        return a
    }
    
    //查询用户表中声音提醒
    func selectRemindSound(username: String) -> Bool {
        var userEntity: UserEntity!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
            let predicate = NSPredicate(format: "username = \"" + username + "\"")
            fetchRequest.predicate = predicate
            userEntity = try (persistentContainer.viewContext.fetch(fetchRequest) as? [UserEntity])?[0]
        } catch {
            print("Failed to fetch plans: \(error)")
        }
        return userEntity.sound
    }
    
    //查询用户表中振动提醒
    func selectRemindVibration(username: String) -> Bool {
        var userEntity: UserEntity!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
            let predicate = NSPredicate(format: "username = \"" + username + "\"")
            fetchRequest.predicate = predicate
            userEntity = try (persistentContainer.viewContext.fetch(fetchRequest) as? [UserEntity])?[0]
        } catch {
            print("Failed to fetch plans: \(error)")
        }
        return userEntity.vibration
    }
    
    //修改用户表中声音提醒
    func updateRemindSound(soundOption: Bool, username: String) {
        var userEntity: UserEntity!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
            let predicate = NSPredicate(format: "username = \"" + username + "\"")
            fetchRequest.predicate = predicate
            userEntity = try (persistentContainer.viewContext.fetch(fetchRequest) as? [UserEntity])?[0]
        } catch {
            print("Failed to fetch plans: \(error)")
        }
        userEntity.sound = soundOption
        print("updating the sound option to context ...")
        saveContext()
    }
    
    //修改用户表中振动提醒
    func updateRemindVibration(vibrationOption: Bool, username: String) {
        var userEntity: UserEntity!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
            let predicate = NSPredicate(format: "username = \"" + username + "\"")
            fetchRequest.predicate = predicate
            userEntity = try (persistentContainer.viewContext.fetch(fetchRequest) as? [UserEntity])?[0]
        } catch {
            print("Failed to fetch plans: \(error)")
        }
        userEntity.vibration = vibrationOption
        print("updating the vibration option to context ...")
        saveContext()
    }
    
    // MARK: 用户操作
    // 查询指定用户, 若查不到，则返回新建的对象
    func selectUser(username: String!) -> UserEntity {
        
        var list:[UserEntity]!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
            let predicate = NSPredicate(format: "username = \"" + username + "\"")
            fetchRequest.predicate = predicate
            
            list = try
                persistentContainer.viewContext.fetch(fetchRequest) as? [UserEntity]
        } catch {
            print("Failed to fetch employees: \(error)")
        }
        
        if list != nil && !list.isEmpty {
            return list[0]
        }
        //return list[0]
        return UserEntity(context: persistentContainer.viewContext)
    }
    
    
    // 保存用户信息
    func saveUser(user: UserEntity, id: String!, username: String!, count: String!, total_duration: String!, sound: Bool!, vibration: Bool!) {
        user.username = username
        user.count = count
        user.total_duration = total_duration
        user.id = id
        user.sound = sound
        user.vibration = vibration
        
        saveContext()
    }
    
    //MARK更新用户信息(总打卡次数和总时长)
    func updateUser(userEntity:UserEntity,count:String,total_duration:String)->UserEntity{
        userEntity.count = count
        userEntity.total_duration = total_duration
        saveContext()
        return userEntity
    }
    
    
    // MARK: 任务模块操作
    
    // 查询某个状态下的任务
    func selectTasksByStatus(status: String!) -> [TaskEntity] {
        var list: [TaskEntity]!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            let predicate = NSPredicate(format: "state = \"" + status + "\"")
            fetchRequest.predicate = predicate
            
            list = try
                persistentContainer.viewContext.fetch(fetchRequest) as? [TaskEntity]
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
        return list
    }
    
    
    // MARK: 计划模块
    
    // 查询已有的计划数
    func selectPlanCount() -> Int {
        
        var list: [PlanEntity]!
        do {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanEntity")
            
            list = try
                persistentContainer.viewContext.fetch(PlanEntity.fetchRequest()) as? [PlanEntity]
        } catch {
            print("Failed to fetch plan count: \(error)")
        }
        return list.count
    }
    
    // 删除某个计划
    func deletePlan(plan: PlanEntity) {
        do {
            persistentContainer.viewContext.delete(plan)
            saveContext()
        } catch {
            print("Failed to delete plan. \(error)")
        }
    }
    
    
    func selectTasksByPlan(planId: String!) -> [TaskEntity] {
        var list: [TaskEntity]!
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            let predicate = NSPredicate(format: "plan_id = \"" + planId + "\"")
            fetchRequest.predicate = predicate
            list = try persistentContainer.viewContext.fetch(fetchRequest) as? [TaskEntity]
        } catch {
            print("Failed to fetch plans. \(error)")
        }
        
        return list
    }
    
}

