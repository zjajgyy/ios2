//
//  PlanEntity+CoreDataProperties.swift
//  T-Helper
//
//  Created by 李鹏翔 on 2016/12/2.
//  Copyright © 2016年 thelper. All rights reserved.
//

import Foundation
import CoreData


extension PlanEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanEntity> {
        return NSFetchRequest<PlanEntity>(entityName: "PlanEntity");
    }

    @NSManaged public var actual_duration: String?
    @NSManaged public var date: String?
    @NSManaged public var end_time: String?
    @NSManaged public var id: String?
    @NSManaged public var location: String?
    @NSManaged public var note: String?
    @NSManaged public var plan_duration: String?
    @NSManaged public var start_time: String?
    @NSManaged public var state: String?

}
