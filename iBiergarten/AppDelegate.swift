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
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

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
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
            NSNotificationCenter.defaultCenter().postNotificationName("UserAuthCallbackNotification", object: url, userInfo: nil)
            return true
        }
        return true
    }
    
    func initController(){
        let splitViewController = self.window!.rootViewController as UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
        
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        let masterNavigationController = splitViewController.viewControllers[0] as UINavigationController
        let masterViewController = masterNavigationController.topViewController as MasterViewController
        masterViewController.managedObjectContext = coreDataHelper.context
    }
    
    func initDatabase() -> Bool {
        self.jsonDataHelper.importJSONSeedDataIfNeeded()
        return true
    }
    
    func initGoogleAPI() {
        GMSServices.provideAPIKey(Constants.googleMapsApiKey())
    }
    
    func initFlickr(){
        FlickrKit.sharedFlickrKit().initializeWithAPIKey("73767299b91be4b2db8d67de99d1da66", sharedSecret: "75e53598d548f2f3")
    }
    
    func application(application: UIApplication!, handleActionWithIdentifier identifier:String!, forLocalNotification notification:UILocalNotification!,
        completionHandler: (() -> Void)!){
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

    // MARK: - Split view
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
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
        
        var thirdAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        thirdAction.identifier = "THIRD_ACTION"
        thirdAction.title = "Third Action"
        
        thirdAction.activationMode = UIUserNotificationActivationMode.Background
        thirdAction.destructive = false
        thirdAction.authenticationRequired = false
        
        
        // category
        
        var firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = Constants.identifierFirstCategory()
        
        let defaultActions:NSArray = [firstAction, secondAction, thirdAction]
        let minimalActions:NSArray = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions, forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of all our categories
        
        let categories:NSSet = NSSet(objects: firstCategory)
        
        
        
        let types:UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge
        
        let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
    }

}

