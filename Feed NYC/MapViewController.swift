//
//  ViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GoogleMaps
import NVActivityIndicatorView

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // view and manager to operate with map
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var marker: GMSMarker!
    var button: UIButton!
    var facilityForTappedMarker = Facility()
    
    var currentDeviceLocationLatitude = 0.0
    var currentDeviceLocationLongitude = 0.0
    
    // closest location to current location
    var closestFacility: Facility?
    var distanceInMetersForClosestFacility = 0.0
    
    // data store for all facility objects
    let store = FacilityDataStore.sharedInstance
    
    // Animation in center when loading map
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBigRedButton()
        self.store.readInTextFile()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.createMapView()
        self.addLoadingAnimation()
        // completion block, wait when all markers created
        self.setupMarkers { completion in
            if completion {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.activityIndicator.stopAnimation()
                })
            }
        }

        self.view.addSubview(mapView)
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            self.view.addSubview(button)
        }
        self.view.addSubview(activityIndicator)
        
        mapView.delegate = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.findClosestLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // finds the closest facility to current user location
    // puts closest location to the propert "closestFacility" and the distance to it in "distanceInMetersForClosestFacility"
    func findClosestLocation() {
        
        let currentLocation: CLLocation = CLLocation.init(latitude: self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude)
        var minDistance: Double = 100000000000.0
        var distanceInMeters = 0.0
        // go through all locations and find the closest one
        for i in 0..<store.facilities.count {
            let location = CLLocation.init(latitude: self.store.facilities[i].latitude, longitude: self.store.facilities[i].longitude)
            distanceInMeters = currentLocation.distanceFromLocation(location)
            if minDistance > distanceInMeters {
                minDistance = distanceInMeters
                self.closestFacility = self.store.facilities[i]
                self.distanceInMetersForClosestFacility = minDistance
            }
            self.store.facilities[i].distanceFromCurrentLocation = distanceInMeters * 0.000621371
        }
    }
    
    // MARK: -Displays all the pins on map
    func setupMarkers(completion:(Bool) -> ()) {
        self.activityIndicator.startAnimation()
        
        for i in 0..<self.store.facilities.count {
            let currentFacility = self.store.facilities[i]
            let position = CLLocationCoordinate2DMake(currentFacility.latitude, currentFacility.longitude)
            let marker = GMSMarker(position: position)
            marker.icon = GMSMarker.markerImageWithColor(UIColor.flatRedColor())
            marker.title = currentFacility.name
            
            let featureSet: Set<String> = Set(currentFacility.featureList)
            marker.snippet = featureSet.joinWithSeparator(". ") + "\n" + currentFacility.phoneNumber
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                marker.map = self.mapView
                if currentFacility.featureList.contains("Food Pantry") && currentFacility.featureList.contains("Soup Kitchen") {
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.flatPurpleColor())
                } else if currentFacility.featureList.contains("Food Pantry") {
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.flatGreenColorDark())
                }
                
                marker.infoWindowAnchor = CGPointMake(0.4, 0.3)
            })
        }
        completion(true)
    }
    
    func createMapView() {
        
        let camera : GMSCameraPosition
        let smallerRect = CGRectMake(0, Constants.navBarHeight, self.view.bounds.width, self.view.bounds.height - Constants.navBarHeight)
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            if let managerLocation = locationManager.location {
                self.currentDeviceLocationLatitude = managerLocation.coordinate.latitude
                self.currentDeviceLocationLongitude = managerLocation.coordinate.longitude
            }
            
            // setting map with current location ≥coordinats in the middle
            camera = GMSCameraPosition.cameraWithLatitude(self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude, zoom: Constants.defaultZoomLevel)
            
            self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
            self.mapView.myLocationEnabled = true
            // button in right low corner that makes current location in the middle
            self.mapView.settings.myLocationButton = true
            self.view.addSubview(button)
            //self.mapView.addSubview(button)
        }
        else {

            camera = GMSCameraPosition.cameraWithLatitude(40.758896, longitude: -73.985130, zoom: Constants.midtownZoomLevel)
           
            self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
            self.mapView.myLocationEnabled = false
        
            // button in right low corner that makes current location in the middle
            self.mapView.settings.myLocationButton = false
            button.removeFromSuperview()
            //  }
        }
    
        // button in right low corner that makes current location in the middle
        //self.mapView.settings.myLocationButton = true
        //self.view.subviews.forEach { view in
        //    print(view.frame.origin)
        //}
        
    }

    // Sets properties of "get nearby help" button
    func addBigRedButton() {
        button = UIButton()
        button.setTitle("FIND NEAREST", forState: .Normal)
        button.setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
        button.backgroundColor = UIColor.flatNavyBlueColor().lightenByPercentage(0.1)
        button.addTarget(self, action: #selector(MapViewController.helpButtonTapped(_:)), forControlEvents: .TouchUpInside)
        button.frame = CGRectMake(170, 450, 220, 30)
        button.layer.cornerRadius = 11.5 //Rounded edge of button: 20 is a semi-circle
        button.layer.borderColor = UIColor.flatBlackColor().CGColor
        
        //UIScreen.mainScreen().bounds.size.width / 2.0
        button.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.height - 80)
        // width is 295
        //153 490 295 40
    }
    
    func helpButtonTapped(sender: UIButton!) {
        let cenkersStoryboard = UIStoryboard(name: "CenkersStoryboard", bundle: nil)
        
        let detailVC = cenkersStoryboard.instantiateViewControllerWithIdentifier("CenkersDetailViewController") as! CenkersDetailViewController
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            if let managerLocation = locationManager.location {
                self.currentDeviceLocationLatitude = managerLocation.coordinate.latitude
                self.currentDeviceLocationLongitude = managerLocation.coordinate.longitude
            }
        }
        //call the function that updates the closest facility property before using the facility
        self.findClosestLocation()
        
        if let closestFacility = self.closestFacility {
            detailVC.facilityToDisplay = closestFacility
        }
        else {
            print("could not unwrap the closest facility")
        }
        
        self.presentViewController(detailVC, animated: true, completion: nil)
    }
    
    // Sets properties of loading animation while markers are generated
    func addLoadingAnimation() {
        //        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        //        self.activityIndicator.color = UIColor.blackColor()
        //        self.activityIndicator.center = view.center
        //        self.activityIndicator.startAnimating()
        let animationFrame = CGRectMake(self.mapView.frame.midX - Animation.halfSizeOffset, self.mapView.frame.midY - Animation.halfSizeOffset,
                                        Animation.width, Animation.height)
        
        self.activityIndicator = NVActivityIndicatorView(frame: animationFrame,
                                                         type: NVActivityIndicatorType.BallScaleRippleMultiple,
                                                         color: UIColor.whiteColor(),
                                                         padding: 0.0)
        
    }
    //       NVActivityIndicatorType.BallScaleRippleMultiple
    // ALSO  NVActivityIndicatorType.BallClipRotateMultiple  is great!

}

// MARK: - CLLocationManagerDelegate

extension MapViewController {
    
    // 2 authorization status for the application (can I get access to your location?)
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
        // if user aggried access to his/he location coordinats
        if status == .AuthorizedWhenInUse {
            
            // ask for updates on the user’s location
            locationManager.startUpdatingLocation()
            
            // current user location latitude and longitude
            if let managerLocation = manager.location {
                self.currentDeviceLocationLatitude = managerLocation.coordinate.latitude
                self.currentDeviceLocationLongitude = managerLocation.coordinate.longitude
            }
            //calling the function that updates the singleton with current coordinates
            self.updateCurrentLocation()
            let camera = GMSCameraPosition.cameraWithLatitude(self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude, zoom: Constants.defaultZoomLevel)
            mapView.camera = camera
            mapView.myLocationEnabled = true
            
            // button in right low corner that makes current location in the middle
            self.mapView.settings.myLocationButton = true
            
            self.view.addSubview(button)
            //self.mapView.addSubview(button)
        }
        if status == .Denied {
            // Let them know they need to allow location!
            let camera = GMSCameraPosition.cameraWithLatitude(40.758896, longitude: -73.985130, zoom: Constants.midtownZoomLevel)
            mapView.camera = camera
            mapView.myLocationEnabled = false
            showLocationAlert()
            // button in right low corner that makes current location in the middle
            self.mapView.settings.myLocationButton = false
            
            button.removeFromSuperview()
        }
        
    }
    
    //function to set the current coordinates to singleton's (datastore) currenLocationCoordinates property
    func updateCurrentLocation() {
        let currentCoordinates = CLLocationCoordinate2D(latitude: self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude)
        
//        store.currentLocationCoordinates = currentCoordinates
    }
    
    // this function moves blue marker on the map with user movement,
    // constantly updating new user location and move map accordingly, so blue marker always in the middle of the view
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: Constants.defaultZoomLevel, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker)-> Bool {
        if marker != mapView.selectedMarker {
            mapView.selectedMarker = marker
        }
        return true
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let customInfoWindow : CustomInfoWindow!
        customInfoWindow = CustomInfoWindow(frame: CGRect(x: 0, y: 0, width: 230, height: 150))
        //NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil)[0] as! CustomInfoWindow
        customInfoWindow.nameButtonLabel.setTitle("\(marker.title!)\n\n\(marker.snippet!)", forState: .Normal)
        
        mapView.camera = GMSCameraPosition(target: marker.position, zoom: 13, bearing: 0, viewingAngle: 0)
        return customInfoWindow
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        self.facilityForTappedMarker = self.findFacilityForMarker(marker)
        performSegueWithIdentifier("detailSegue", sender: mapView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destinationViewController as! CenkersDetailViewController
            detailVC.facilityToDisplay = self.facilityForTappedMarker
        }
    }
    
    func findFacilityForMarker(marker: GMSMarker) -> Facility {
        let facilities = store.facilities.filter{ $0.name == marker.title && $0.latitude == marker.layer.latitude && $0.longitude == marker.layer.longitude}
        return facilities[0]
    }
    
    func showLocationAlert() {
        let alert = UIAlertController(title: "Location Permission", message: "Please allow our app to see your location while in use so we can serve you better. You can change the permissions in your phone's settings.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(OKAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}

