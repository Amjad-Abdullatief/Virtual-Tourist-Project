//
//  ViewController.swift
//  VirtualTouristProject1
//
//  Created by AMJAD - on 06/04/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var footer: UIView!
    
    // MARK: - Variables
    var pinAnnotation: MKPointAnnotation? = nil
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        footer.isHidden = true
        
        if let pins = loadAllPins() {
            showPins(pins)
        }
    }
    
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PhotoAlbumVC {
            guard let pin = sender as? Pin else {
                return
            }
            let controller = segue.destination as! PhotoAlbumVC
            controller.pin = pin
        }
    }
    
  
    
    @IBAction func addPinGesture(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        if sender.state == .began {
            
            pinAnnotation = MKPointAnnotation()
            pinAnnotation!.coordinate = locationCoordinate
            
            print("\(#function) Coordinate: \(locationCoordinate.latitude),\(locationCoordinate.longitude)")
            
            mapView.addAnnotation(pinAnnotation!)
            
        } else if sender.state == .changed {
            pinAnnotation!.coordinate = locationCoordinate
        } else if sender.state == .ended {
            
            _ = Pin(
                latitude: pinAnnotation!.coordinate.latitude,
                longitude: pinAnnotation!.coordinate.longitude,
                context: CoreDataStack.shared().context
            )
            save()
            
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        footer.isHidden = !editing
    }
    
   
    
    private func loadAllPins() -> [Pin]? {
        var pins: [Pin]?
        do {
            try pins = CoreDataStack.shared().fetchAllPins(entityName: "Pin")
        } catch {
            print("\(#function) error:\(error)")
            
        }
        return pins
    }
    
    private func loadPin(latitude: String, longitude: String) -> Pin? {
        let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
        var pin: Pin?
        do {
            try pin = CoreDataStack.shared().fetchPin(predicate, entityName: "Pin")
        } catch {
            print("\(#function) error:\(error)")
            
        }
        return pin
    }
    
    func showPins(_ pins: [Pin]) {
        for pin in pins where pin.latitude != nil && pin.longitude != nil {
            let annotation = MKPointAnnotation()
            let lat = pin.latitude
            let lon = pin.longitude
            annotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
}

extension MapViewController {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }
        
        mapView.deselectAnnotation(annotation, animated: true)
        print("\(#function) lat \(annotation.coordinate.latitude) lon \(annotation.coordinate.longitude)")
        let lat = String(annotation.coordinate.latitude)
        let lon = String(annotation.coordinate.longitude)
        if let pin = loadPin(latitude: lat, longitude: lon) {
            if isEditing {
                mapView.removeAnnotation(annotation)
                CoreDataStack.shared().context.delete(pin)
                save()
                return
            }
            performSegue(withIdentifier: "showAlbum", sender: pin)
        }
    }
    
}

