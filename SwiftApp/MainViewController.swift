//
//  MainViewController.swift
//  SwiftApp
//
//  Created by Diego dos Santos on 4/7/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var items = NSMutableArray()
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let publicDB = CKContainer.defaultContainer().publicCloudDatabase
    
    override func viewDidLoad() {
        //MARK: verificar cloudkit e coredata
        
    super.viewDidLoad()
        //CloudKit
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Items",
            predicate:  predicate)
        publicDB.performQuery(query, inZoneWithID: nil) { fetchedObjects, errQuery in
            for obj in fetchedObjects {
                var item = obj as! CKRecord
                self.items.addObject(item)
            }
            self.tableView.reloadData()

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            })
        }
        
        //CoreData
//        let fetchRequest = NSFetchRequest(entityName:"Item")
//        var error: NSError?
//        let fetchedResults = managedContext!.executeFetchRequest(fetchRequest, error: &error) as![NSManagedObject]?
//        if let results = fetchedResults {
//            for obj in results{
//                var item = obj as! Item
//                self.items.addObject(item)
//            }
//        } else {
//            println("Could not fetch \(error), \(error!.userInfo)")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ItemTableViewCell
        var userObj = items[indexPath.row] as! CKRecord
        cell.name.text = userObj.valueForKey("name") as? String

        var dateFormat = NSDateFormatter()
        dateFormat.dateFormat = NSDateFormatter.dateFormatFromTemplate("EEEE, hh:mm", options: 0, locale: NSLocale.currentLocale())
        
        cell.date.text = dateFormat.stringFromDate(userObj.valueForKey("date") as! NSDate)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            //Delete notification
            var notifications = UIApplication.sharedApplication().scheduledLocalNotifications
            var item = items.objectAtIndex(indexPath.row) as! CKRecord
            for i in 0..<notifications.count {
                var notif =  notifications[i] as! UILocalNotification
                var userInfo:Dictionary<String,String!> = notif.userInfo as! Dictionary<String,String!>
                var uniqueid = userInfo["uniqueID"]
                if uniqueid == (item.valueForKey("uniqueID") as! String){
                        UIApplication.sharedApplication().cancelLocalNotification(notif)
                }
            }
            
            var toDelete = items[indexPath.row] as! CKRecord //as ckrecord
            
            //Delete obj in coredata
//            managedContext!.deleteObject(toDelete as NSManagedObject)
        
        //Delete obj in Cloudkit
        publicDB.deleteRecordWithID(toDelete.recordID, completionHandler: ({returnRecord, error in
                if let err = error {
                NSLog("error: %@",err)
                }
            }))
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}
