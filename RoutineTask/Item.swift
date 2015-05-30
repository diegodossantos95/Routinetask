//
//  Item.swift
//  RoutineTask
//
//  Created by Diego dos Santos on 5/1/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var desc: String
    @NSManaged var name: String
    @NSManaged var uniqueID: String

    
    func toDictionary()->NSDictionary{
        var dic = NSDictionary()
        dic.setValue(name, forKey: "name")
//        dic.setValue(desc, forKey: "description")
//        dic.setValue(uniqueID, forKey: "uniqueID")
        var string = date.descriptionWithLocale(NSLocale.currentLocale())
        
        return dic
    }
}
