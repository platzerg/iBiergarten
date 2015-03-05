//
//  PWReachability.swift
//  iBiergarten
//
//  Created by platzerworld on 25.01.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import Foundation
import CoreData


class PWReachability{
    
    let internetReachable: Reachability
    let nc = NSNotificationCenter.defaultCenter()
    let kAddHomeError: String = "kAddHomeError"
    var allBiergarten = Array<BiergartenVO>()
    
    init() {
        self.internetReachable = Reachability.reachabilityForInternetConnection()
        internetReachable.startNotifier()
        
        var reachability: Reachability = Reachability.reachabilityForInternetConnection()
        var internetStatus:NetworkStatus = reachability.currentReachabilityStatus()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        let url = NSURL(string: "http://biergartenservice.appspot.com/platzerworld/biergarten/holebiergarten")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {response,data,error in
            if data != nil {
                
                let json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                
                if let statusesArray = json as? NSDictionary{
                    if let biergartenListe = statusesArray["biergartenListe"] as? NSArray{
                        for bier in biergartenListe {
                            
                            if let biergarten = bier as? NSDictionary{
                                
                                var id: Int16 = Int16(bier["id"]! as Int)
                                var name: String = bier["name"]! as String
                                var strasse: String = bier["strasse"]! as String
                                var plz: String = bier["plz"]! as String
                                var ort: String = bier["ort"]! as String
                                var url: String = bier["url"]! as String
                                var longitude: String = bier["longitude"]! as String
                                var latitude: String = bier["latitude"]! as String
                                var email: String = bier["email"]! as String
                                var telefon: String = bier["telefon"]! as String
                                var desc: String = bier["desc"]! as String
                                var favorit: Bool = bier["favorit"]! as Bool
                                
                                var biergartenModel: BiergartenVO = BiergartenVO(id: id, name:name, strasse:strasse, plz:plz, ort:ort, url:url, longitude:longitude, latitude:latitude, email:email, telefon:telefon, desc:desc, favorit: favorit)
                                
                                self.allBiergarten.append(biergartenModel)                                   }
                        }
                    }
                }
            }
            
            if error != nil {
                let alert = UIAlertView(title:"Oops!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
                alert.show()
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            self.nc.postNotificationName(Constants.notificationBiergartenLoaded(), object: nil)
        }
        
        
        var observer = notificationCenter.addObserverForName("gpl", object: nil, queue: mainQueue) { _ in
            print("gpl was here")
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name:"NotificationIdentifier", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication1:", name:"NotificationIdentifier1", object: nil)
        
        fetchNearbyPlaces()
        
    }
    
    dynamic private func methodOFReceivedNotication(notification: NSNotification){
        println("methodOFReceivedNotication")
    }
    
    @objc private func methodOFReceivedNotication1(notification: NSNotification){
        println("methodOFReceivedNotication1")
    }
    
    func getAllBiergarten() -> Array<BiergartenVO> {
        return self.allBiergarten
    }
    
    func fetchNearbyPlaces() {
        nc.postNotificationName("gpl", object: nil)
        nc.postNotificationName("NotificationIdentifier", object: nil)
        nc.postNotificationName("NotificationIdentifier1", object: nil)

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
