//
//  MasterViewController.swift
//  iBiergarten
//
//  Created by platzerworld on 17.01.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, BiergartenDetailViewControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var allFechtedBiergarten:[Biergarten] = []
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clearsSelectionOnViewWillAppear = false
        self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        let controllers = self.splitViewController!.viewControllers
        //self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        
        var dataFecher:DataFecher = DataFecher()
        self.activateNCBiergartenLoaded(dataFecher)
        dataFecher.fetchAllBiergarten()
        
    }
    
    func activateNCBiergartenLoaded(reachability:DataFecher) -> (){
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        var observer = notificationCenter.addObserverForName(Constants.notificationBiergartenLoaded(), object: nil, queue: mainQueue) { _ in
            
            let allBiergarten: Array<BiergartenVO> = reachability.getAllBiergarten()
            for biergarten in allBiergarten
            {
                print(biergarten.name)
            }
            
            self.allFechtedBiergarten  = self.fetchedResultsController.fetchedObjects! as! [Biergarten]
            self.detailViewController?.allBiergarten = self.allFechtedBiergarten
            self.detailViewController?.tmpAllBiergarten = self.allFechtedBiergarten
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func insertNewObject(sender: AnyObject) {
        var biergartenModel: BiergartenVO
        if(sender is UIBarButtonItem){
            biergartenModel = BiergartenVO()
            biergartenModel.id = 0815
            biergartenModel.name = "GPL_name"
            biergartenModel.strasse = "GPL_strasse"
            biergartenModel.plz = "GPL_plz"
            biergartenModel.ort = "GPL_ort"
            biergartenModel.url = "GPL_url"
            biergartenModel.longitude = "48.181051"
            biergartenModel.latitude = "11.586875"
            biergartenModel.email = "GPL_email"
            biergartenModel.telefon = "GPL_telefon"
            biergartenModel.desc = "GPL_desc"
            biergartenModel.favorit = true
            if let resultController = storyboard!.instantiateViewControllerWithIdentifier("biergrtenDetail") as? BiergartenDetailViewController {
                    resultController.biergartenVO = biergartenModel
                    resultController.delegate = self
                    presentViewController(resultController, animated: true, completion: nil)
                
                self.pushToCloud(biergartenModel)
            }

        }else{
            biergartenModel = (sender as! BiergartenVO)
        }
                
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newBiergartenManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! Biergarten
        self.updateBiergarten(newBiergartenManagedObject, biergartenModel: biergartenModel)
        
        
        
        var error: NSError? = nil
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            self.handleError(error)
        }
    }
    
    func pushToCloud(biergartenVO: BiergartenVO) -> (){
        var urlString = "http://gaejdo3.appspot.com/platzerworld/biergarten/addbiergarten?name=\(biergartenVO.name)&strasse=\(biergartenVO.name)&plz=\(biergartenVO.plz)&ort=\(biergartenVO.ort)&telefon=\(biergartenVO.telefon)&email=\(biergartenVO.email)&url=\(biergartenVO.url)&longitude=\(biergartenVO.longitude)&latitude=\(biergartenVO.latitude)&desc=\(biergartenVO.desc)&favorit=\(biergartenVO.favorit)"
        
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    func updateBiergarten(newBiergartenManagedObject:Biergarten, biergartenModel:BiergartenVO) -> (){
        newBiergartenManagedObject.id = biergartenModel.id
        newBiergartenManagedObject.name = biergartenModel.name
        newBiergartenManagedObject.strasse = biergartenModel.strasse
        newBiergartenManagedObject.plz = biergartenModel.plz
        newBiergartenManagedObject.ort = biergartenModel.ort
        newBiergartenManagedObject.url = biergartenModel.url
        newBiergartenManagedObject.longitude = biergartenModel.longitude
        newBiergartenManagedObject.latitude = biergartenModel.latitude
        newBiergartenManagedObject.email = biergartenModel.email
        newBiergartenManagedObject.telefon = biergartenModel.telefon
        newBiergartenManagedObject.desc = biergartenModel.desc
        newBiergartenManagedObject.favorit = biergartenModel.favorit
    }
    
    func handleError(error: NSError!) -> (){
        if error != nil {
            print("Unresolved error \(error), \(error?.description)")
            abort()
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Biergarten
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = (object, self.allFechtedBiergarten)
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] 
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                
            var error: NSError? = nil
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Biergarten
        cell.textLabel!.text = object.valueForKey("name")!.description
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName(Constants.BiergartenEntity(), inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
    	var error: NSError? = nil
    	do {
            try _fetchedResultsController!.performFetch()
        } catch let error1 as NSError {
            error = error1
            print("Unresolved error \(error), \(error?.description)")
    	     abort()
    	}
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    /*
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            default:
                return
        }
    }
*/

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */
    
    // MARK: - Types Controller Delegate
    func storeBiergarten(controller: BiergartenDetailViewController, biergarten: BiergartenVO) {
        
        dismissViewControllerAnimated(true, completion: nil)
    
    }

}

