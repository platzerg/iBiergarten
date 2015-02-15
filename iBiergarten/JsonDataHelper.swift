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
        
        let results =
        super.context.countForFetchRequest(fetchRequest,
            error: &error)
        
        if (results == 0) {
            
            var fetchError: NSError? = nil
            
            if let results =
                super.context.executeFetchRequest(fetchRequest,
                    error: &fetchError) {
                        for object in results {
                            let team = object as Biergarten
                            super.context.deleteObject(team)
                        }
            }
            
            super.saveContext()
            self.importJSONSeedData()
        }
    }


    func importJSONSeedData() {
        let jsonURL = NSBundle.mainBundle().URLForResource("Biergarten", withExtension: "json")
        let jsonData = NSData(contentsOfURL: jsonURL!)
        
        var error: NSError? = nil
        let json : AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        let entity = NSEntityDescription.entityForName("Biergarten", inManagedObjectContext: super.context)
        
        
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
        println("Imported \(json.count) Biergarten")
    }

}
