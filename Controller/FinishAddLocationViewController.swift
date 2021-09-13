//
//  FinishAddLocationViewController.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/25.
//


import Foundation
import UIKit
import MapKit

class FinishAddLocationViewController: UIViewController, MKMapViewDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var finish: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var studentInformation: StudentInformation?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let studentLocation = studentInformation {
            let studentLocation = Location (
                createdAt: studentLocation.createdAt ?? "",
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                latitude: studentLocation.latitude!,
                longitude: studentLocation.longitude!,
                mapString: studentLocation.mapString!,
                mediaURL: studentLocation.mediaURL!,
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey!,
                updatedAt: studentLocation.updatedAt ?? ""
            )
            showLocations(location: studentLocation)
        
        }
    }
    
    
    @IBAction func finishAddLocation(_ sender: UIButton) {
        self.setLoading(true)
        if let studentLocation = studentInformation {
            if UdacityClient.Auth.objectId == "" {
                UdacityClient.addStudentLocation(information: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self.setLoading(true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                            self.setLoading(false)
                        }
                    }
                }
                
            }else{
                let alertVC =  UIAlertController(title: "", message: "Location is already posted, would you like to update your location?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    UdacityClient.updateStudentLocation(information: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.setLoading(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                                self.setLoading(false)
                            }
                        }
            }
                }))
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:  { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        self.setLoading(false)
                        alertVC.dismiss(animated: true, completion: nil)
                        
                    }
                    }))
            }
        }
    }
                
                func showLocations(location: Location) {
                    mapView.removeAnnotations(mapView.annotations)
                    if let coordinate = extractCoordinates(location: location) {
                        let annotation = MKPointAnnotation()
                        annotation.title = location.locationLabel
                        annotation.subtitle = location.mediaURL ?? ""
                        annotation.coordinate = coordinate
                        mapView.addAnnotation(annotation)
                        mapView.showAnnotations(mapView.annotations, animated: true)
                        
                    }
                }
                
                    func extractCoordinates(location: Location) -> CLLocationCoordinate2D? {
                        if let lat = location.latitude, let lon = location.longitude {
                            return CLLocationCoordinate2DMake(lat, lon)
                        }
                        return nil
                    }
                
                func setLoading(_ loading: Bool) {
                    if loading {
                        DispatchQueue.main.async {
                            self.activityIndicator.startAnimating()
                            self.buttonEnabled(false, button: self.finish)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.buttonEnabled(true, button: self.finish)
                        }
                    }
                    DispatchQueue.main.async {
                        self.finish.isEnabled = !loading
                    }
                }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    
}
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.canOpenURL(URL(string: toOpen)!)
            }
        }
    }
        
    
}
