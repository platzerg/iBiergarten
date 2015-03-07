
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
    
    
    
    let options =
    [NSMigratePersistentStoresAutomaticallyOption: true]
    //4
    
    let fileManager = NSFileManager.defaultManager()
    let urls = fileManager.URLsForDirectory(.DocumentDirectory,
        inDomains: .UserDomainMask) as! [NSURL]
    
    

    
    var error: NSError? = nil
    store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil,
      URL: urls[0], options: options, error:&error)
    
    if store == nil {
      println("Error adding persistent store: \(error)")
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
    if context.hasChanges && !context.save(&error) {
      println("Could not save: \(error), \(error?.userInfo)")
    }
  }

  func applicationDocumentsDirectory() -> NSURL {
    let fileManager = NSFileManager.defaultManager()
    
    let urls = fileManager.URLsForDirectory(.DocumentDirectory,
      inDomains: .UserDomainMask) as! [NSURL]
    
    return urls[0]
  }
  
  }













