//
//  CloudCurrency+CoreDataProperties.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 19.11.2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//
//

import Foundation
import CoreData

extension CloudCurrency {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CloudCurrency> {
        let request = NSFetchRequest<CloudCurrency>(entityName: "CloudCurrency")
        request.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
        return request
    }

    @NSManaged public var code: String
    @NSManaged public var accounts: NSSet?

}

// MARK: Generated accessors for accounts
extension CloudCurrency {

    @objc(addAccountsObject:)
    @NSManaged public func addToAccounts(_ value: CloudAccount)

    @objc(removeAccountsObject:)
    @NSManaged public func removeFromAccounts(_ value: CloudAccount)

    @objc(addAccounts:)
    @NSManaged public func addToAccounts(_ values: NSSet)

    @objc(removeAccounts:)
    @NSManaged public func removeFromAccounts(_ values: NSSet)

}
