//
//  CloudAccount+CoreDataProperties.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 19.11.2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//
//

import Foundation
import CoreData


extension CloudAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CloudAccount> {
        return NSFetchRequest<CloudAccount>(entityName: "CloudAccount")
    }

    @NSManaged public var initialAmount: Int64
    @NSManaged public var title: String
    @NSManaged public var uuid: UUID
    @NSManaged public var currency: CloudCurrency?

}
