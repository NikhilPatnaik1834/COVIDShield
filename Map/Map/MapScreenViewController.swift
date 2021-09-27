//
//  MapScreenViewController.swift
//  Map
//
//  Created by Nikhil Patnaik on 23/04/2020.
//  Copyright © 2020 Nikhil Patnaik. All rights reserved.
//

//This is the working copy, the only issue is the flickering
//14062020 22:00

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import GeoFire

class MapScreenViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 100
    var ref: DatabaseReference!
    var geoFire: GeoFire?
    var dotAnnotationArray = [String : MKAnnotation]()
    var dotColor: String?
    var dot = ""
    var mapUserID = ""
    var coordinateID = ""
    var data = Data()
    var circle = MKCircle()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("Users"))
        checkLocationServices()
        ref.child("Users").child(mapUserID).child("userID").setValue(mapUserID)
        ref.child("Users").child(mapUserID).child("dot").setValue(dot)
        coordinateID = mapUserID
        self.mapView.tintColor = UIColor.blue
    }
    
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        circleRadius(location: location)
        
        geoFire!.setLocation(location, forKey: coordinateID)
        let query = geoFire?.query(at: location, withRadius: 0.05)
        
        query?.observe(.keyEntered, with: {key, location, snapshot  in
            
            if(key != self.coordinateID){
                
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.data.dot = dictionary["dot"] as? String
                    self.data.userID = dictionary["userID"] as? String
                    self.dotColor = self.data.dot!
                }
                
                for i in self.dotAnnotationArray{
                    if i.key  == self.data.userID{
                        self.mapView?.removeAnnotation(i.value as MKAnnotation)
                    }
                }
                
                let dotAnnotation = MKPointAnnotation()
                dotAnnotation.coordinate = location.coordinate
                dotAnnotation.title = self.dotColor
                self.mapView?.addAnnotation(dotAnnotation as MKAnnotation)
                self.dotAnnotationArray[key] = dotAnnotation
            }
            
        })
        
        for i in dotAnnotationArray{
            mapView?.removeAnnotation(i.value)
        }
        
        query?.observe(.keyExited, with: { key, location, snapshot in
            if(key != self.coordinateID){
                let dotAnnotation = self.dotAnnotationArray[key] as? MKPointAnnotation
                if let dotAnnotation = dotAnnotation {
                    self.mapView?.removeAnnotation(dotAnnotation as MKAnnotation)
                }
            }
        })
    
        query?.observe(.keyMoved, with: { key, location, snapshot in
            if(key != self.coordinateID){
                let dotAnnotation = self.dotAnnotationArray[key] as? MKPointAnnotation
                UIView.animate(withDuration: 3.0, animations: {
                    dotAnnotation?.coordinate = location.coordinate
                })
            }
        })
        
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
    }
    
    func circleRadius(location: CLLocation){
        self.mapView.removeOverlay(circle)
        circle = MKCircle(center: location.coordinate, radius: CLLocationDistance(40))
        UIView.animate(withDuration: 3.0, animations: {
            self.circle = self.circle
        })
        self.mapView.addOverlay(circle)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
            circle.fillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            circle.lineWidth = 1
            return circle
    }
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomPinAnnotationView") as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(
                annotation: annotation,
                reuseIdentifier: "CustomPinAnnotationView")
        }
        
        if let userAnnotation = annotation as? MKUserLocation {
          userAnnotation.title = ""
          return nil
        }
        
        
        if annotation.title == "reddot"{
            pinView?.pinTintColor = UIColor.red
            //pinView?.image = UIImage(named: "reddot")
        }else if annotation.title == "yellowdot"{
            pinView?.pinTintColor = UIColor.yellow
            //pinView?.image = UIImage(named: "yellowdot")
        }else if annotation.title == "greendot"{
            pinView?.pinTintColor = UIColor.green
            //pinView?.image = UIImage(named: "greendot")
        }

        pinView?.annotation = annotation

        return pinView
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
}

