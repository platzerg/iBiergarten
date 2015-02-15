//
//  Biergarten.swift
//  iBiergarten
//
//  Created by platzerworld on 15.02.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import Foundation
import CoreData

class Biergarten: NSManagedObject {

    @NSManaged var desc: String
    @NSManaged var email: String
    @NSManaged var favorit: Bool
    @NSManaged var id: Int16
    @NSManaged var latitude: String
    @NSManaged var longitude: String
    @NSManaged var name: String
    @NSManaged var ort: String
    @NSManaged var plz: String
    @NSManaged var strasse: String
    @NSManaged var telefon: String
    @NSManaged var url: String

}
