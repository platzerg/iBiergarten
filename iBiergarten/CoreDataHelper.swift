
import CoreData

class CoreDataHelper {
  let context:NSManagedObjectContext
  let psc:NSPersistentStoreCoordinator
  let model:NSManagedObjectModel
  let store:NSPersistentStore?

  init() {
    //1
    let bundle = NSBundle.mainBundle()
    let modelURL =
    bundle.URLForResource(Constants.iBiergartenIdentifier(), withExtension:"momd")
    model = NSManagedObjectModel(contentsOfURL: modelURL!)!
    
    //2
    psc = NSPersistentStoreCoordinator(managedObjectModel:model)
    
    //3
    context = NSManagedObjectContext()
    context.persistentStoreCoordinator = psc
    
    
    
    let options = [NSMigratePersistentStoresAutomaticallyOption: true]
    //4
    
    let fileManager = NSFileManager.defaultManager()
    
    let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) 
    
    let documentsURL = urls[0]
    let storeURL = documentsURL.URLByAppendingPathComponent(Constants.iBiergartenIdentifier())

    
    var error: NSError? = nil
    do {
      store = try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
    } catch let error1 as NSError {
      error = error1
      store = nil
    }
    
    if store == nil {
      print("Error adding persistent store: \(error)")
      abort()
    }
    
  }
    
    func getDocumentsUrl() -> NSURL{
        let documentsURL = applicationDocumentsDirectory()
        let storeURL =
        documentsURL.URLByAppendingPathComponent(Constants.iBiergartenIdentifier())
        return storeURL
    }
  
  func saveContext() {
    var error: NSError? = nil
    if context.hasChanges {
      do {
        try context.save()
      } catch let error1 as NSError {
        error = error1
        print("Could not save: \(error), \(error?.userInfo)")
      }
    }
  }

  func applicationDocumentsDirectory() -> NSURL {
    let fileManager = NSFileManager.defaultManager()
    
    let urls = fileManager.URLsForDirectory(.DocumentDirectory,
      inDomains: .UserDomainMask) 
    
    return urls[0]
  }
  
}