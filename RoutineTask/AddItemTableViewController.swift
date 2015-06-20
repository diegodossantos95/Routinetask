//
//  AddItemTableViewController.swift
//  SwiftApp
//
//  Created by Diego dos Santos on 4/15/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//


import UIKit
import CoreData

class AddItemTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var notificationTimePicker: UIDatePicker!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
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
    
    //Mark: Actions
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func donePressed(sender: UIBarButtonItem) {
        if (nameTextField.text != "" && selectedIndexPath != nil){
        
            var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            var time = notificationTimePicker.date
            var units = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitWeekday
            var componentsForFireDate = calendar?.components(units , fromDate: time)

            componentsForFireDate?.weekday = (selectedIndexPath!.row+1)
        
            let fireDateOfNotification = calendar?.dateFromComponents(componentsForFireDate!)
        
            let uniqueID = NSUUID().UUIDString
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .NoStyle
            formatter.timeStyle = .ShortStyle
            let notificationTimeString = formatter.stringFromDate(taskTimePicker.date)
            
            let notification  = UILocalNotification()
            notification.fireDate = fireDateOfNotification
            notification.timeZone = NSTimeZone.localTimeZone()
            notification.alertBody = descField.text + ". Today, " + notificationTimeString
            notification.alertTitle = nameTextField.text
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.repeatInterval = NSCalendarUnit.CalendarUnitWeekOfYear
            notification.userInfo = ["uniqueID" : uniqueID, "taskTimeForWatch" : notificationTimeString, "bodyForWatch" :descField.text]
            notification.category = "Task_Notification"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedContext) as! NSManagedObject
        
            item.setValue(nameTextField.text, forKey: "name")
            item.setValue(descField.text, forKey: "desc")
            item.setValue(uniqueID, forKey: "uniqueID")
            item.setValue(fireDateOfNotification, forKey: "date")
        
            var error: NSError?
            if !managedContext.save(&error) {
                self.alertController("Save problem :(", message: "Could not save \(error), \(error?.userInfo), please contact the support.")
            }else{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.alertController("Fields in blank", message: "Name, Date and Time are mandatory. Please complete before save your task. :)")
    }
    
    //Mark: AlertView
    func alertController(title: String, message: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
        cell.layer.borderColor = UIColor(red: 1, green: 164/255, blue: 30/255, alpha: 1).CGColor
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(selectedIndexPath != indexPath && selectedIndexPath != nil){
            var unselectCell = collectionView.cellForItemAtIndexPath(selectedIndexPath!) as! WeekDaysCollectionViewCell
            unselectCell.backgroundColor = UIColor.whiteColor()
            unselectCell.dayLabel.textColor = UIColor(red: 1, green: 164/255, blue: 30/255, alpha: 1)
        }
            var cell = collectionView.cellForItemAtIndexPath(indexPath) as! WeekDaysCollectionViewCell
            cell.backgroundColor = UIColor(red: 1, green: 164/255, blue: 30/255, alpha: 1)
            cell.dayLabel.textColor = UIColor.whiteColor()
            selectedIndexPath = indexPath
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 3
        }
        return 2
    }
    
    //MARK: ScrollView
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
