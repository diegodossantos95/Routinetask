//
//  MainViewController.swift
//  SwiftApp
//
//  Created by Diego dos Santos on 4/7/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var sunday = NSMutableArray()
    var monday = NSMutableArray()
    var tuesday = NSMutableArray()
    var wednesday = NSMutableArray()
    var thursday = NSMutableArray()
    var friday = NSMutableArray()
    var saturday = NSMutableArray()
    var userDefaults = NSUserDefaults(suiteName: "group.routinetask")
    var dictionariesToWatch = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        sunday.removeAllObjects()
        monday.removeAllObjects()
        tuesday.removeAllObjects()
        wednesday.removeAllObjects()
        thursday.removeAllObjects()
        friday.removeAllObjects()
        saturday.removeAllObjects()
        
        let fetchRequest = NSFetchRequest(entityName:"Item")
        var error: NSError?
        let fetchedResults = managedContext!.executeFetchRequest(fetchRequest, error: &error) as![NSManagedObject]?
        
        var dateFormatWeek = NSDateFormatter()
        dateFormatWeek.dateFormat = "e"
        
        if let results = fetchedResults {
            for obj in results{
                var weekDayString = dateFormatWeek.stringFromDate(obj.valueForKey("date") as! NSDate)
                switch weekDayString {
                case "1":
                    sunday.addObject(obj)
                case "2":
                    monday.addObject(obj)
                case "3":
                    tuesday.addObject(obj)
                case "4":
                    wednesday.addObject(obj)
                case "5":
                    thursday.addObject(obj)
                case "6":
                    friday.addObject(obj)
                case "7":
                    saturday.addObject(obj)
                default:
                    NSLog("Error in weekday")
                }
            }
        } else {
            self.alertController("Fetch Error :(", message: "Could not fetch \(error), \(error!.userInfo), pelase contact the support.")
        }
        self.tableView.reloadData()
        self.dictionaryToWatchInBackground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dictionaryToWatchInBackground(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            self.dictionariesToWatch.removeAll(keepCapacity: false)
            let timeFormat = NSDateFormatter()
            timeFormat.dateStyle = .NoStyle
            timeFormat.timeStyle = .ShortStyle
            var dateFormatWeek = NSDateFormatter()
            dateFormatWeek.dateFormat = "e"
            var dic = [String:String]()
            
            for task in self.sunday{
                dic["weekday"] = "Sunday, " + timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["weekdayInt"] = dateFormatWeek.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["time"] = timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["name"] = task.valueForKey("name") as? String
                dic["desc"] = task.valueForKey("desc") as? String
                self.dictionariesToWatch.append(dic)
            }
            
            for task in self.monday{
                dic["weekday"] = "Monday, " + timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["weekdayInt"] = dateFormatWeek.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["time"] = timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["name"] = task.valueForKey("name") as? String
                dic["desc"] = task.valueForKey("desc") as? String
                self.dictionariesToWatch.append(dic)
            }
            
            for task in self.tuesday{
                dic["weekday"] = "Tuesday, " + timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["weekdayInt"] = dateFormatWeek.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["time"] = timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["name"] = task.valueForKey("name") as? String
                dic["desc"] = task.valueForKey("desc") as? String
                self.dictionariesToWatch.append(dic)
            }
            
            for task in self.wednesday{
                dic["weekday"] = "Wednesday, " + timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["weekdayInt"] = dateFormatWeek.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["time"] = timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["name"] = task.valueForKey("name") as? String
                dic["desc"] = task.valueForKey("desc") as? String
                self.dictionariesToWatch.append(dic)
            }
            
            for task in self.thursday{
                dic["weekday"] = "Thursday, " + timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["weekdayInt"] = dateFormatWeek.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["time"] = timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["name"] = task.valueForKey("name") as? String
                dic["desc"] = task.valueForKey("desc") as? String
                self.dictionariesToWatch.append(dic)
            }
            
            for task in self.friday{
                dic["weekday"] = "Friday, " + timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["weekdayInt"] = dateFormatWeek.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["time"] = timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["name"] = task.valueForKey("name") as? String
                dic["desc"] = task.valueForKey("desc") as? String
                self.dictionariesToWatch.append(dic)
            }
            
            for task in self.saturday{
                dic["weekday"] = "Saturday, " + timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["weekdayInt"] = dateFormatWeek.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["time"] = timeFormat.stringFromDate(task.valueForKey("date") as! NSDate)
                dic["name"] = task.valueForKey("name") as? String
                dic["desc"] = task.valueForKey("desc") as? String
                self.dictionariesToWatch.append(dic)
            }
            
            self.userDefaults!.setObject(self.dictionariesToWatch, forKey: "tasks")
            self.userDefaults!.synchronize()
            NSLog(self.dictionariesToWatch.description)
        }
    }
    
    //Mark: AlertView
    
    func alertController(title: String, message: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Mark: Tableview
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! HeaderTableViewCell
        var text = String()
        
        switch section {
        case 0:
            cell.titleLabel.text  = "Sunday"
        case 1:
            cell.titleLabel.text = "Monday"
        case 2:
            cell.titleLabel.text = "Tuesday"
        case 3:
            cell.titleLabel.text = "Wednesday"
        case 4:
            cell.titleLabel.text = "Thursday"
        case 5:
            cell.titleLabel.text = "Friday"
        default:
            cell.titleLabel.text = "Saturday"
        }
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var cell = tableView.dequeueReusableCellWithIdentifier("footerCell") as! FooterTableViewCell
        cell.titleLabel.text = "No tasks yet"
        var count = 0
        switch section {
        case 0:
            count = sunday.count
        case 1:
            count = monday.count
        case 2:
            count = tuesday.count
        case 3:
            count = wednesday.count
        case 4:
            count = thursday.count
        case 5:
            count = friday.count
        default:
            count = saturday.count
        }
        
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var count = 0
        switch section {
        case 0:
            count = sunday.count
        case 1:
            count = monday.count
        case 2:
            count = tuesday.count
        case 3:
            count = wednesday.count
        case 4:
            count = thursday.count
        case 5:
            count = friday.count
        default:
            count = saturday.count
        }
        
        if count > 0 {
            return 0
        }
        return 30
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sunday.count
        case 1:
            return monday.count
        case 2:
            return tuesday.count
        case 3:
            return wednesday.count
        case 4:
            return thursday.count
        case 5:
            return friday.count
        default:
            return saturday.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ItemTableViewCell
        
        switch indexPath.section {
        case 0:
            self.customCell(sunday, indexpath: indexPath, cell: cell)
        case 1:
            self.customCell(monday, indexpath: indexPath, cell: cell)
        case 2:
            self.customCell(tuesday, indexpath: indexPath, cell: cell)
        case 3:
            self.customCell(wednesday, indexpath: indexPath, cell: cell)
        case 4:
            self.customCell(thursday, indexpath: indexPath, cell: cell)
        case 5:
            self.customCell(friday, indexpath: indexPath, cell: cell)
        default:
            self.customCell(saturday, indexpath: indexPath, cell: cell)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var item : NSManagedObject
            switch indexPath.section {
            case 0:
                item = sunday.objectAtIndex(indexPath.row) as! NSManagedObject
                sunday.removeObject(item)
            case 1:
                item = monday.objectAtIndex(indexPath.row) as! NSManagedObject
                monday.removeObject(item)
            case 2:
                item = tuesday.objectAtIndex(indexPath.row) as! NSManagedObject
                tuesday.removeObject(item)
            case 3:
                item = wednesday.objectAtIndex(indexPath.row) as! NSManagedObject
                wednesday.removeObject(item)
            case 4:
                item = thursday.objectAtIndex(indexPath.row) as! NSManagedObject
                thursday.removeObject(item)
            case 5:
                item = friday.objectAtIndex(indexPath.row) as! NSManagedObject
                friday.removeObject(item)
            default:
                item = saturday.objectAtIndex(indexPath.row) as! NSManagedObject
                saturday.removeObject(item)
            }
            
            //Delete notification
            var notifications = UIApplication.sharedApplication().scheduledLocalNotifications
            for i in 0..<notifications.count {
                var notif =  notifications[i] as! UILocalNotification
                var userInfo:Dictionary<String,String!> = notif.userInfo as! Dictionary<String,String!>
                var uniqueid = userInfo["uniqueID"]
                if uniqueid == (item.valueForKey("uniqueID") as! String){
                    UIApplication.sharedApplication().cancelLocalNotification(notif)
                }
            }
            
            managedContext!.deleteObject(item)
            
            if !managedContext!.save(nil) {
                NSLog("Error")
            }
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            tableView.reloadData()
            
            self.dictionaryToWatchInBackground()
        }
    }
    
    //Mark: Others
    
    func customCell(array: NSMutableArray,indexpath: NSIndexPath, cell: ItemTableViewCell)-> ItemTableViewCell{
        
        var userObj = array.objectAtIndex(indexpath.row) as! NSManagedObject
        cell.name.text = userObj.valueForKey("name") as? String;
        
        var dateFormat = NSDateFormatter()
        dateFormat.dateFormat = NSDateFormatter.dateFormatFromTemplate("hh:mm", options: 0, locale: NSLocale.currentLocale())
        
        cell.date.text = dateFormat.stringFromDate(userObj.valueForKey("date") as! NSDate)
        
        return cell
    }
}
