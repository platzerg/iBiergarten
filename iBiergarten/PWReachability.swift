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
        }
        
        //notificationCenter.addObserver(<#observer: AnyObject#>, selector: <#Selector#>, name: <#String?#>, object: <#AnyObject?#>)
        
        fetchNearbyPlaces()
    }
    
    func fetchNearbyPlaces() {
        nc.postNotificationName("gpl", object: nil)
    }
    
}
