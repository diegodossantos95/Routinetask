//
//  NotificationController.swift
//  RoutineTask WatchKit Extension
//
//  Created by Diego dos Santos on 5/18/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

import WatchKit
import Foundation


class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet weak var subtitleLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a local notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
                
        titleLabel.setText(localNotification.userInfo!["bodyForWatch"] as? String)
        
        let taskTime = localNotification.userInfo!["taskTimeForWatch"] as? String
        subtitleLabel.setText("Today, " + taskTime!)
        
        completionHandler(.Custom)
    }
    
    
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: (WKUserNotificationInterfaceType) -> Void) {
    
        titleLabel.setText(remoteNotification["bodyForWatch"] as? String)
        
        subtitleLabel.setText(remoteNotification["taskTimeForWatch"] as? String)
        
        completionHandler(.Custom)
    }
    
}
