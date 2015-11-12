//
//  DetailViewController.swift
//  iBiergarten
//
//  Created by platzerworld on 17.01.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    var searchedTypes = ["biergarten", "beergarden"]
    
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        locationManager.delegate = nil
    }
    
    var allBiergarten:[Biergarten] = []
    var selectedBiergarten: Biergarten?
    
    var tmpAllBiergarten:[Biergarten] = [] {
        didSet {
            for biergarten in allBiergarten {
                constructMarker(biergarten)
            }
        }
    }

    
    var detailItem: (detailItem: AnyObject?, allItems: AnyObject?) {
        didSet {
            if let detail: AnyObject = self.detailItem.detailItem {
                self.selectedBiergarten = self.detailItem.detailItem as? Biergarten            }
            
            if let detail: AnyObject = self.detailItem.allItems {
                self.allBiergarten = self.detailItem.allItems as! [Biergarten]
            }
        }
    }
    
    
    var randomLineColor: UIColor {
        get {
            let randomRed = CGFloat(drand48())
            let randomGreen = CGFloat(drand48())
            let randomBlue = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }
    }
    
    var mapRadius: Double {
        get {
            let region = mapView.projection.visibleRegion()
            let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
            let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
          
            //return max(horizontalDistance, verticalDistance)*5.5
            return 50000;
        }
    }
    
    @IBAction func refreshPlaces(sender: AnyObject) {
        fetchNearbyPlaces(mapView.camera.target)
    }
    
    @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeSatellite
        default:
            mapView.mapType = mapView.mapType
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.clear()
        initLocationManager()
        var marker: PlaceMarker?
        if let detailItem: AnyObject = self.detailItem.detailItem{
            let biergarten: Biergarten = self.detailItem.detailItem as! Biergarten
            
            marker = constructMarker(biergarten)
            
        }
        
        for biergarten in allBiergarten {
            constructMarker(biergarten)
        }
        
        if let marker = marker{
            mapView.selectedMarker = marker
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView.clear()
    }
    
    func initLocationManager() -> () {
        if (locationManager.delegate == nil) {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            mapView.delegate = self
        }
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
      
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                let marker = PlaceMarker(place: place)
                marker.map = self.mapView
            }
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error
            in
            if let address = response?.firstResult() {
                let lines = address.lines as! [String]
            }
        }
    }
    
    func constructMarker(biergarten:Biergarten) -> (PlaceMarker){
        let latString = biergarten.latitude.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let lonString = biergarten.longitude.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let place: GooglePlace = GooglePlace(name: biergarten.name, adress: biergarten.strasse, coordinate: CLLocationCoordinate2DMake(CLLocationDegrees((latString as NSString).doubleValue), CLLocationDegrees((lonString as NSString).doubleValue)), placeType: "biergarten")
        let marker = PlaceMarker(place: place)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        return marker
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Types Segue" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! TypesTableViewController
            controller.selectedTypes = searchedTypes
            controller.delegate = self
        }
    }
    
}

extension DetailViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first! as? CLLocation {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}

extension DetailViewController: GMSMapViewDelegate{
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        let googleMarker = mapView.selectedMarker as! PlaceMarker
        dataProvider.fetchDirectionsFrom(mapView.myLocation.coordinate, to: googleMarker.place.coordinate) {optionalRoute in
            if let encodedRoute = optionalRoute {
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = self.mapView
                line.strokeColor = self.randomLineColor
                mapView.selectedMarker = nil
            }
        }
    }
    
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as! PlaceMarker
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            infoView.nameLabel.text = placeMarker.place.name
            if let photo = placeMarker.place.photo {
                infoView.placePhoto.image = photo
            } else {
                infoView.placePhoto.image = UIImage(named: "biergarten_pin")
            }
            
            return infoView
        } else {
            return nil
        }
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
        mapView.selectedMarker = nil
        return false
    }

}

extension DetailViewController: TypesTableViewControllerDelegate{
    func makeFinish(controller: TypesTableViewController) {
        searchedTypes = controller.selectedTypes.sort()
        dismissViewControllerAnimated(true, completion: nil)
    }
}


