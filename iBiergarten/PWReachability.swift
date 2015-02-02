//
//  PWReachability.swift
//  iBiergarten
//
//  Created by platzerworld on 25.01.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import Foundation


class PWReachability{
    
    let internetReachable: Reachability
    let nc = NSNotificationCenter.defaultCenter()
    let kAddHomeError: String = "kAddHomeError"
    
    
    init() {
        self.internetReachable = Reachability.reachabilityForInternetConnection()
        internetReachable.startNotifier()
        
        var reachability: Reachability = Reachability.reachabilityForInternetConnection()
        var internetStatus:NetworkStatus = reachability.currentReachabilityStatus()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        var observer = notificationCenter.addObserverForName("gpl", object: nil, queue: mainQueue) { _ in
            print("gpl was here")
            self.doOne()
        }
        
        //notificationCenter.addObserver(self, selector: "doOne", name: "gpl", object: nil)
        
        fetchNearbyPlaces()
        
    }
    
    func fetchNearbyPlaces() {
        nc.postNotificationName("gpl", object: nil)
    }
    
    func doOne() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"drawAShape:", name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"showAMessage:", name: "actionTwoPressed", object: nil)
        
        var dateComp:NSDateComponents = NSDateComponents()
        dateComp.year = 2015;
        dateComp.month = 02;
        dateComp.day = 02;
        dateComp.hour = 15;
        dateComp.minute = 04;
        dateComp.timeZone = NSTimeZone.systemTimeZone()
        
        var calender:NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        var date:NSDate = calender.dateFromComponents(dateComp)!
        
        
        var notification:UILocalNotification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.alertBody = "Hi, I am a notification"
        notification.fireDate = date
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func drawAShape(notification:NSNotification){
        var view:UIView = UIView(frame:CGRectMake(10, 10, 100, 100))
        view.backgroundColor = UIColor.redColor()
        
        
    }
    
    func showAMessage(notification:NSNotification){
        var message:UIAlertController = UIAlertController(title: "A Notification Message", message: "Hello there", preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
       
        
    }
}
