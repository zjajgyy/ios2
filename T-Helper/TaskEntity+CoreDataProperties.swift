//
//  TaskEntity+CoreDataProperties.swift
//  T-Helper
//
//  Created by 李鹏翔 on 2016/12/2.
//  Copyright © 2016年 thelper. All rights reserved.
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity");
    }

    @NSManaged public var content: String?
    @NSManaged public var id: String?
    @NSManaged public var plan_id: String?
    @NSManaged public var state: String?

}
