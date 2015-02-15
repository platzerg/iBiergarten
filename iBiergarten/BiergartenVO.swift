//
//  Biergarten.swift
//  iBiergarten
//
//  Created by platzerworld on 13.02.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import Foundation

class BiergartenVO {
    var id: Int16
    var name: String
    var strasse: String
    var plz: String
    var ort: String
    var url: String
    var longitude: String
    var latitude: String
    var email: String
    var telefon: String
    var desc: String
    var favorit: Bool

    init(){
        self.id = 0
        self.name = ""
        self.strasse = ""
        self.plz = ""
        self.ort = ""
        self.url = ""
        self.longitude = ""
        self.latitude = ""
        self.email = ""
        self.telefon = ""
        self.desc = ""
        self.favorit = false
    }
    
    init(id:Int16, name:String, strasse:String, plz:String, ort:String, url:String, longitude:String, latitude:String, email:String, telefon:String, desc:String, favorit:Bool ){
        self.id = id
        self.name = name
        self.strasse = strasse
        self.plz = plz
        self.ort = ort
        self.url = url
        self.longitude = longitude
        self.latitude = latitude
        self.email = email
        self.telefon = telefon
        self.desc = desc
        self.favorit = favorit
    }
    
}
