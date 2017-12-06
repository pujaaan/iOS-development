//
//  ViewController.swift
//  ParentsMapkit
//
//  Created by Admin on 2017-11-21.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil
    var locationManager: CLLocationManager?
    let dayCares = ["Daycare 1 : 3644 39 St NE, Calgary : (403) 280-4444 : daycare2.jpg", "Daycare 2 : 5703 24 Ave NE, Calgary : (403) 125-4567 : daycare1.jpg", "Daycare3 : 985 McPherson Rd NE, Calgary: (403) 457-9810 : daycare1.jpg", "Daycare 4: 115 2 Ave SW #200, Calgary : (403) 262-4433 : daycare2.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
        
        mapView?.delegate = self
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.delegate = self
        
        // Initialization the table view controller
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // create a search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Configure the UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        centerMap(address: "Calgary")
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager!.startUpdatingLocation()
        } else {
            locationManager!.requestWhenInUseAuthorization()
        }
        self.mapView.isUserInteractionEnabled = true
        
        for elem in dayCares{
            let elemSplit = elem.split(separator:":")
            let name = String(elemSplit[0])
            let location = String(elemSplit[1])
           putCircle(address: location, name: name)
            
        }
        
        
        let unlockButton = UIButton(type: .roundedRect)
        unlockButton.setTitle("\(dayCares.count) Daycares found with vacancies", for: .normal)
        unlockButton.titleLabel?.lineBreakMode = .byWordWrapping
        unlockButton.titleLabel?.textAlignment = .center
        unlockButton.setTitleColor(UIColor.white, for: .normal)
        unlockButton.layer.cornerRadius = 12
        unlockButton.backgroundColor = UIColor.blue.withAlphaComponent(0.9)
        unlockButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(unlockButton)
        NSLayoutConstraint.activate([
            unlockButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            unlockButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant : -16),
            unlockButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64),
            //unlockButton.widthAnchor.constraint(equalToConstant: 180),
            unlockButton.heightAnchor.constraint(equalToConstant: 75)
            ])
        unlockButton.addTarget(self, action: #selector(viewButtonPressed(sender:)), for: .touchUpInside)
        setupUserTrackingButtonAndScaleView()
    }
    
    @objc func viewButtonPressed(sender: UIButton){
        let payAlert = UIAlertController(title: "Payment Required", message: "You need to pay to view the daycares. Do you want to proceed?", preferredStyle: UIAlertControllerStyle.alert)
        self.present(payAlert, animated:  true, completion:  nil)
        payAlert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {action in
            for elem in self.dayCares{
                let overlays = self.mapView.overlays
                self.mapView.removeOverlays(overlays)
                let elemSplit = elem.split(separator:":")
                if(elemSplit.count >= 4){
                    let name = String(elemSplit[0])
                    let location = String(elemSplit[1])
                    let number = String(elemSplit[2])
                    let image = String(elemSplit[3])
                    self.putMarker(address: String(location), name: String(name), phone: String(number), image : String(image))
                }
            }
            
            sender.isHidden = true
        }))
        payAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
    }


    func setupUserTrackingButtonAndScaleView() {
        mapView.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
    }
    
    func centerMap(address : String) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if(error == nil){
                let placemarks = placemarks
                let location = placemarks?.first?.location
                let regionRadius: CLLocationDistance = 5000
                let coordinateRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, regionRadius, regionRadius)
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                
            }
            else {
                // handle no location found
                return
            }
            
            
        }
    }
    func putCircle(address : String, name: String){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if(error == nil){
                let placemarks = placemarks
                let location = placemarks?.first?.location
                let circle = MKCircle(center: (location?.coordinate)!, radius: 500)
                circle.title = name
                self.mapView.add(circle)
            }
            else {
                // handle no location found
                return
            }
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    func putMarker(address : String, name: String, phone : String, image: String) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if(error == nil){
                let placemarks = placemarks
                let location = placemarks?.first?.location
                let annotation = childcareAnnotation(coordinate: (location?.coordinate)!)
                
                annotation.image = UIImage(named: image.trimmingCharacters(in: .whitespacesAndNewlines))
                
                annotation.name = name
                annotation.address = address
                annotation.phone = phone
                self.mapView.addAnnotation(annotation)
            }
            else {
                // handle no location found
                return
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        if annotation is MKPointAnnotation{
            
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.orange
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            pinView?.leftCalloutAccessoryView = button
            return pinView
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationCustom(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "pindrop.png")
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        if view.annotation is MKPointAnnotation{
            return
        }
        
        // 2
        let childcareAnnotation = view.annotation as! childcareAnnotation
        let calloutView = Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)?.first as! CustomView
        calloutView.childcareName.text = childcareAnnotation.name
        calloutView.childcareAddress.text = childcareAnnotation.address
        calloutView.childcarePhone.text = childcareAnnotation.phone
        calloutView.childcareImage.image = childcareAnnotation.image
        let button = UIButton(frame: calloutView.childcarePhone.frame)
        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationCustom.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    @objc func callPhoneNumber(sender: UIButton)
    {
        let v = sender.superview as! CustomView
        if let url = URL(string: "tel://\(v.childcarePhone.text!)"), UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url)
        }
    }
    
    
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            return
        case .restricted:
            return
        case .denied:
            return
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000, 5000)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }

    
}
extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        for anno: MKAnnotation in mapView.annotations{
            if(anno is MKPointAnnotation){
                mapView.removeAnnotation(anno)
            }
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

