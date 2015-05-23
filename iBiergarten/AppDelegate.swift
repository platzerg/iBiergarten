//
//  AppDelegate.swift
//  iBiergarten
//
//  Created by platzerworld on 17.01.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var coreDataHelper = CoreDataHelper()
    lazy var jsonDataHelper = JsonDataHelper()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.initGoogleAPI()
        self.initController()
        self.initNotification()
        self.initDatabase()
        self.initFlickr()
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        let scheme: String = url.scheme!
        if("flickr391994024204840" == scheme) {
            NSNotificationCenter.defaultCenter().postNotificationName("UserAuthCallbackNotification", object: url, userInfo: nil)
            return true
        }
        return true
    }
    
    func initController(){
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        splitViewController.delegate = self
        
        // MASTER-VIEW
        let leftNavController = splitViewController.viewControllers.first as! UINavigationController
        let masterViewController = leftNavController.topViewController as! MasterViewController
        masterViewController.managedObjectContext = coreDataHelper.context
        
        // DETAIL-VIEW
        let rightNavController = splitViewController.viewControllers.last as! UINavigationController
        let detailViewController = rightNavController.topViewController as! DetailViewController
        
        // SPLIT-VIEW
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        
        // HANDLE DEVICE-IPAD
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            splitViewController.preferredDisplayMode = .AllVisible // PrimaryHidden
            splitViewController.preferredPrimaryColumnWidthFraction = 0.4
            splitViewController.maximumPrimaryColumnWidth = 512
        }
    }
    
    func initDatabase() -> Bool {
        self.jsonDataHelper.importJSONSeedDataIfNeeded()
        return true
    }
    
    func initGoogleAPI() {
        GMSServices.provideAPIKey(Constants.googleMapsApiKey())
    }
    
    func initFlickr(){
        //FlickrKit.sharedFlickrKit().initializeWithAPIKey("73767299b91be4b2db8d67de99d1da66", sharedSecret: "75e53598d548f2f3")
    }
    
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if (identifier == Constants.identifierFirstAction()){
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.actionOnePressed(), object: nil)
        }else if (identifier == Constants.identifierSecondAction()){
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.actionTwoPressed(), object: nil)
        }
        completionHandler()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        coreDataHelper.saveContext()
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        
        coreDataHelper.saveContext()
    }
    
    func initNotification (a: Void ) -> (Void){
        // Actions
        var firstAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = Constants.identifierFirstAction()
        firstAction.title = "First Action"
        
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        var secondAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = Constants.identifierSecondAction()
        secondAction.title = "Second Action"
        
        secondAction.activationMode = UIUserNotificationActivationMode.Foreground
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        // category
        
        var firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = Constants.identifierFirstCategory()
        
        let defaultActions:NSArray = [firstAction, secondAction]
        let minimalActions:NSArray = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions as! [AnyObject], forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions as! [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of all our categories
        
        let categories:NSSet = NSSet(objects: firstCategory)
        
        let types:UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge
    
        let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories as Set<NSObject>)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController where topAsDetailController.detailItem.detailItem == nil {
                // If there's no session, then we only want to show the primary. This is the
                // only case where we return true. Remember, returning true means we've handled
                // the collapse -- in this case, we've handled it by doing nothing! :]
                return true
            }
            
            // Otherwise, we want the default behavior of pushing whatever's on the secondary
            // onto the primary. In that case, we should make sure the primary's navigation
            // bar is displayed if it's a navigation controller.
            if let primaryAsNavController = primaryViewController as? UINavigationController {
                primaryAsNavController.setNavigationBarHidden(false, animated: false)
            }
        }
        
        // Returning false means we want the split view controller to handle the collapse.
        // In this app with its navigation controllers on both the primary and secondary,
        // it will simply push everything on the secondary onto the primary.
        return false
    }
}

