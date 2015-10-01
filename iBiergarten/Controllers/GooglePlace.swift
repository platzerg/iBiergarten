//
//  GooglePlace.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class GooglePlace {
  
  let name: String
  let address: String
  let coordinate: CLLocationCoordinate2D
  let placeType: String
  let photoReference: String?
  var photo: UIImage?
  
  init(name: String, adress: String, coordinate: CLLocationCoordinate2D, placeType: String){
    self.name = name
    self.address = adress
    self.coordinate = coordinate
    self.placeType = placeType
    self.photoReference = ""
    self.photo = nil
  }
    
  init(dictionary:NSDictionary, acceptedTypes: [String])
  {
    name = dictionary["name"] as! String
    address = dictionary["vicinity"] as! String
    
    let location = dictionary["geometry"]?["location"] as! NSDictionary
    let lat = location["lat"] as! CLLocationDegrees
    let lng = location["lng"] as! CLLocationDegrees
    coordinate = CLLocationCoordinate2DMake(lat, lng)
    
    if let photos = dictionary["photos"] as? NSArray {
      let photo = photos.firstObject as! NSDictionary
      photoReference = photo["photo_reference"] as? String
    }else{
        photoReference = ""
    }
    
    var foundType = "restaurant"
    let possibleTypes = acceptedTypes.count > 0 ? acceptedTypes : ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant", "biergarten"]
    for type in dictionary["types"] as! [String] {
      if possibleTypes.contains(type) {
        foundType = type
        break
      }
    }
    placeType = foundType
  }
}
