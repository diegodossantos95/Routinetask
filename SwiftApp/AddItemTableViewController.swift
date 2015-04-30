//
//  AddItemTableViewController.swift
//  SwiftApp
//
//  Created by Diego dos Santos on 4/15/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//


import UIKit
import CoreData
import CloudKit

class AddItemTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timePicker: UIDatePicker!
    let weekDays : [String] = ["Su","Mo","Tu","We","Th","Fr","Sa"]
    var selectedIndexPath : NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func donePressed(sender: UIBarButtonItem) {
        //Create date to notification
        var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        var time = timePicker.date
        var units = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitWeekday
        var componentsForFireDate = calendar?.components(units , fromDate: time)

        componentsForFireDate?.weekday = (selectedIndexPath!.row+1)
        
        let fireDateOfNotification = calendar?.dateFromComponents(componentsForFireDate!)
        
        //Generate UniqueID
        let uniqueID = NSUUID().UUIDString
        
        //Create a notification
        let notification  = UILocalNotification()
        notification.fireDate = fireDateOfNotification
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.alertBody = nameTextField.text
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.repeatInterval = NSCalendarUnit.CalendarUnitWeekOfYear
        notification.userInfo = ["uniqueID" : uniqueID,]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        NSLog("%@",notification)
        
        //Add to CoreData
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext!
//        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedContext) as! Item
//        
//        item.setValue(nameTextField.text, forKey: "name") //Name
//        //Desc
//        item.setValue(uniqueID, forKey: "uniqueID")//Unique ID
//        item.setValue(fireDateOfNotification, forKey: "date")//Date
//        item.setValue(true, forKey: "active") //Active
//        
//        var error: NSError?
//        if !managedContext.save(&error) {
//            println("Could not save \(error), \(error?.userInfo)")
//        }
        
        //Add to CloudKit
        let myRecord = CKRecord(recordType: "Items")
        myRecord.setObject(nameTextField.text, forKey: "name") //Name
        myRecord.setObject(uniqueID, forKey: "uniqueID") //UniqueID
        myRecord.setObject(fireDateOfNotification, forKey: "date") //Date
        myRecord.setObject(true, forKey: "active") //Active
        //Desc

        let publicDB = CKContainer.defaultContainer().publicCloudDatabase
        publicDB.saveRecord(myRecord, completionHandler:
            ({returnRecord, error in
                if let err = error {
                    NSLog("error: %@",err)
                }
        }))
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: -Collection View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func collectionView(_collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = _collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! WeekDaysCollectionViewCell
        cell.dayLabel.text = weekDays[indexPath.row]
        cell.layer.cornerRadius = 22
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.blackColor().CGColor
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(selectedIndexPath != indexPath && selectedIndexPath != nil){
            var unselectCell = collectionView.cellForItemAtIndexPath(selectedIndexPath!) as! WeekDaysCollectionViewCell
            unselectCell.backgroundColor = UIColor.whiteColor()
            unselectCell.dayLabel.textColor = UIColor.blackColor()
        }
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as! WeekDaysCollectionViewCell
            cell.backgroundColor = UIColor.blackColor()
            cell.dayLabel.textColor = UIColor.whiteColor()
            selectedIndexPath = indexPath
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
