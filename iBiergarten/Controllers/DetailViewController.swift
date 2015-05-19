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
    var biergartenDic = [Int16: PlaceMarker]()

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var allBiergarten:[Biergarten] = [] {
        didSet {
            self.prepareView()
        }
    }

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
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
        if let detailItem: AnyObject = self.detailItem{
            constructMarker(self.detailItem as! Biergarten)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func prepareView() -> (){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        buildMarker()
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
    
    func buildMarker(){
        for biergarten in allBiergarten {
            constructMarker(biergarten)
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
    
    func constructMarker(biergarten:Biergarten) -> (){
        let latString = biergarten.latitude.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let lonString = biergarten.longitude.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var place: GooglePlace = GooglePlace(name: biergarten.name, adress: biergarten.strasse, coordinate: CLLocationCoordinate2DMake(CLLocationDegrees((latString as NSString).doubleValue), CLLocationDegrees((lonString as NSString).doubleValue)), placeType: "biergarten")
        let marker = PlaceMarker(place: place)
        
        marker.appearAnimation = kGMSMarkerAnimationPop

        marker.map = self.mapView
        let id: Int16 = Int16(biergarten.id)
        println(id)
        biergartenDic[biergarten.id] = marker
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Types Segue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = segue.destinationViewController.topViewController as! TypesTableViewController
            controller.selectedTypes = searchedTypes
            controller.delegate = self
        }
    }
    
    func configureView() {
        if let detail: AnyObject = self.detailItem {
            var myBiergarten: Biergarten = self.detailItem as! Biergarten
            println(myBiergarten)
        }
    }
    
}

extension DetailViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
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
        searchedTypes = sorted(controller.selectedTypes)
        dismissViewControllerAnimated(true, completion: nil)
    }
}


