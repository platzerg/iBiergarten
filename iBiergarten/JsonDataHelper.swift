//
//  JsonDataHelper.swift
//  iBiergarten
//
//  Created by platzerworld on 15.02.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import CoreData

class JsonDataHelper : CoreDataHelper {
    
    func importJSONSeedDataIfNeeded() {
        
        let fetchRequest = NSFetchRequest(entityName: "Biergarten")
        var error: NSError? = nil
        
        let results = super.context.countForFetchRequest(fetchRequest, error: &error)
        
        if (results == 0) {
            
            var fetchError: NSError? = nil
            
            do {
                let results =
                    try super.context.executeFetchRequest(fetchRequest)
                    for object in results {
                        let team = object as! Biergarten
                        super.context.deleteObject(team)
                    }
            } catch let error as NSError {
                fetchError = error
            }
            
            super.saveContext()
            self.importJSONSeedData()
        }
    }


    func importJSONSeedData() {
        let jsonURL = NSBundle.mainBundle().URLForResource("Biergarten", withExtension: "json")
        let jsonData = NSData(contentsOfURL: jsonURL!)
        
        var error: NSError? = nil
        let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
        
        let entity = NSEntityDescription.entityForName("Biergarten", inManagedObjectContext: super.context)
        
        
        if let statusesArray = json as? NSDictionary{
            if let biergartenListe = statusesArray["biergartenListe"] as? NSArray{
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
                        
                        let newBiergartenManagedObject = Biergarten(entity: entity!, insertIntoManagedObjectContext: super.context)
                        
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
                }
            }
        }
        super.saveContext()
    }
}
