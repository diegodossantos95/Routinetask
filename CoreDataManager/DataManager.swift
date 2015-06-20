//
//  DataManager.swift
//  RoutineTask
//
//  Created by Diego dos Santos on 6/1/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

public class DataManager: NSObject {
    public class func getContext() -> NSManagedObjectContext {
        return WatchCoreDataProxy.sharedInstance.managedObjectContext!
    }
    
    public class func deleteManagedObject(object:NSManagedObject) {
        getContext().deleteObject(object)
        saveManagedContext()
    }
    
    public class func saveManagedContext() {
        var error : NSError? = nil
        if !getContext().save(&error) {
            NSLog("Unresolved error saving context \(error), \(error!.userInfo)")
            abort()
        }
    }
}
