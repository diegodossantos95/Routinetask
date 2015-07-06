//
//  GlanceController.swift
//  RoutineTask WatchKit Extension
//
//  Created by Diego dos Santos on 5/18/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    
    var userDefaults = NSUserDefaults(suiteName: "group.routinetask")
    var todayTasks = [[String:String]]()
    var tasks : [[String:String]]!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        tasks = self.userDefaults!.objectForKey("tasks") as? [[String:String]]
        if (tasks != nil) {
            if tasks!.count > 0{
                for (index, element) in enumerate(tasks) {
                    var weekday = element["weekdayInt"]
                    if  weekday == self.getDayOfWeek(){
                        todayTasks.append(tasks[index])
                    }
                }
            }
            if todayTasks.count > 0{
                table.setNumberOfRows(todayTasks.count, withRowType: "TaskRow")
                for (index, element) in enumerate(todayTasks) {
                    if let row = table.rowControllerAtIndex(index) as? TaskRow {
                        row.rowLabel.setText(todayTasks[index]["name"])
                        row.dateLabel.setText(todayTasks[index]["time"])
                    }
                }
            }else{
                table.setNumberOfRows(1, withRowType: "TaskRow")
                if let row = table.rowControllerAtIndex(0) as? TaskRow {
                    row.rowLabel.setText("No tasks yet")
                    row.dateLabel.setText("")
                }
            }

        }
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func getDayOfWeek()->String {
        let todayDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitWeekday, fromDate: todayDate)
        let weekDay = components.weekday
        return String(weekDay)
    }
}
