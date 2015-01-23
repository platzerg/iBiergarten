//
//  PlaceMarker.swift
//  Feed Me
//
//  Created by Brian Moakley on 10/24/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import Foundation

class PlaceMarker: GMSMarker {
  // 1
  let place: GooglePlace
  
  // 2
  init(place: GooglePlace) {
    self.place = place
    super.init()
    
    position = place.coordinate
    icon = UIImage(named: place.placeType+"_pin")
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = kGMSMarkerAnimationPop
  }
}