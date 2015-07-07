//
//  InterfaceController.swift
//  RoutineTask WatchKit Extension
//
//  Created by Diego dos Santos on 5/18/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    var userDefaults = NSUserDefaults(suiteName: "group.routinetask")
    var tasks : [[String:String]]!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        tasks = self.userDefaults!.objectForKey("tasks") as? [[String:String]]
        if tasks != nil && tasks.count > 0{
            table.setNumberOfRows(tasks.count, withRowType: "TaskRow")
            for (index, user) in enumerate(tasks) {
                if let row = table.rowControllerAtIndex(index) as? TaskRow {
                    row.rowLabel.setText(tasks[index]["name"])
                    row.dateLabel.setText(tasks[index]["weekday"])
                }
            }
        }else{
            table.setNumberOfRows(1, withRowType: "TaskRow")
            if let row = table.rowControllerAtIndex(0) as? TaskRow {
                row.rowLabel.setText("No tasks yet")
                row.dateLabel.setText("")
            }
        }
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
}
