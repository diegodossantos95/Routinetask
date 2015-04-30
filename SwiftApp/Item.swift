//
//  Item.swift
//  SwiftApp
//
//  Created by Diego dos Santos on 4/21/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var active: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var name: String
    @NSManaged var desc: String
    @NSManaged var uniqueID: String

}
