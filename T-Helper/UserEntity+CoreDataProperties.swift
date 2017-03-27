//
//  UserEntity+CoreDataProperties.swift
//  T-Helper
//
//  Created by 李鹏翔 on 2016/12/2.
//  Copyright © 2016年 thelper. All rights reserved.
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity");
    }

    @NSManaged public var count: String?
    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var sound: Bool
    @NSManaged public var total_duration: String?
    @NSManaged public var username: String?
    @NSManaged public var vibration: Bool

}
