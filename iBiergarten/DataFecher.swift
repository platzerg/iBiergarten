//
//  DataFecher.swift
//  iBiergarten
//
//  Created by platzerworld on 19.05.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import Foundation
import CoreData

class DataFecher{
    var allBiergarten = Array<BiergartenVO>()
    
    func fetchAllBiergarten() {
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        let url = NSURL(string: Constants.biergartenURL())
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {response,data,error in
            if data != nil {
                
                let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                
                if let statusesArray = json as? NSDictionary{
                    if let biergartenListe = statusesArray[Constants.jsonKeyForBiergartenListe()] as? NSArray{
                        for bier in biergartenListe {
                            
                            if let biergarten = bier as? NSDictionary{
                                let id: Int16 = Int16(bier[Constants.jsonKeyForId()]! as! Int)
                                let name: String = bier[Constants.jsonKeyForName()]! as! String
                                let strasse: String = bier[Constants.jsonKeyForStrasse()]! as! String
                                let plz: String = bier[Constants.jsonKeyForPlz()]! as! String
                                let ort: String = bier[Constants.jsonKeyForOr()]! as! String
                                let url: String = bier[Constants.jsonKeyForUrl()]! as! String
                                let longitude: String = bier[Constants.jsonKeyForLongitude()]! as! String
                                let latitude: String = bier[Constants.jsonKeyForLatitude()]! as! String
                                let email: String = bier[Constants.jsonKeyForEmail()]! as! String
                                let telefon: String = bier[Constants.jsonKeyForTelefon()]! as! String
                                let desc: String = bier[Constants.jsonKeyForDescription()]! as! String
                                let favorit: Bool = bier[Constants.jsonKeyForFavorit()]! as! Bool
                                
                                let biergartenModel: BiergartenVO = BiergartenVO(id: id, name:name, strasse:strasse, plz:plz, ort:ort, url:url, longitude:longitude, latitude:latitude, email:email, telefon:telefon, desc:desc, favorit: favorit)
                                
                                self.allBiergarten.append(biergartenModel)
                            }
                        }
                    }
                }
            }
            
            self.handleError(error)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            notificationCenter.postNotificationName(Constants.notificationBiergartenLoaded(), object: nil)
        }
        
        
        
        /*
        var observer = notificationCenter.addObserverForName("gpl", object: nil, queue: mainQueue) { _ in
        print("gpl was here")
        
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name:"NotificationIdentifier", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication1:", name:"NotificationIdentifier1", object: nil)
        
        fetchNearbyPlaces()
        doOne()
        */
    }
    
    func handleError(error: NSError!) -> (){
        if error != nil {
            let alert = UIAlertView(title:"Oops!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
            alert.show()
        }
    }
    
    func getAllBiergarten() -> Array<BiergartenVO> {
        return self.allBiergarten
    }
    
    /*
    dynamic private func methodOFReceivedNotication(notification: NSNotification){
    println("methodOFReceivedNotication")
    }
    
    @objc private func methodOFReceivedNotication1(notification: NSNotification){
    println("methodOFReceivedNotication1")
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
    dateComp.month = 05;
    dateComp.day = 02;
    dateComp.hour = 17;
    dateComp.minute = 12;
    dateComp.timeZone = NSTimeZone.systemTimeZone()
    
    var calender:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var date:NSDate = calender.dateFromComponents(dateComp)!
    
    
    var notification:UILocalNotification = UILocalNotification()
    notification.category = "FIRST_CATEGORY"
    notification.alertBody = "Hi, I am a notification"
    notification.fireDate = date
    
    var notification1:UILocalNotification = UILocalNotification()
    notification1.category = "FIRST_CATEGORY"
    notification1.alertBody = "Hi, I am a lokal"
    notification1.fireDate = date
    
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    UIApplication.sharedApplication().scheduleLocalNotification(notification1)
    
    }
    
    
    func drawAShape(notification:NSNotification){
    var view:UIView = UIView(frame:CGRectMake(10, 10, 100, 100))
    view.backgroundColor = UIColor.redColor()
    
    
    }
    func showAMessage(notification:NSNotification){
    var message:UIAlertController = UIAlertController(title: "A Notification Message", message: "Hello there", preferredStyle: UIAlertControllerStyle.Alert)
    message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    
    }
    */
}
