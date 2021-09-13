//
//  AddLocationViewController.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/25.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
  
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var objectId: String?
    
    var locationTextFieldIsEmpty = true
    var linkTextFieldIsEmpty = true
    
    
    //life cyucle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
        buttonEnabled(false, button: findLocationButton)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func backAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func findLocation(_ sender: Any) {
    self.setLoading(true)
        let newLocation = locationTextField.text
        
        guard let url = URL(string: self.linkTextField.text!)
        ,UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Website link is incorrect:", title: "Invalid link")
            self.setLoading(false)
            return
        }
        worldPosition(newLocation: newLocation ?? "")
}

    
    // Position//
    
    private func worldPosition (newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                self.setLoading(false)
                
            } else {
                var location: CLLocation?
            
            if let marker = newMarker, marker.count > 0 {
                location = marker.first?.location
                }
                
        if let location = location {
            self.loadNewLocation(location.coordinate)
            
        } else {
            self.showAlert(message: "Please try again", title: "Location Invalid")
            self.setLoading(false)
            print ("An error occured")
                }
            }
        }
    }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
                let controller = storyboard?.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as! FinishAddLocationViewController
                controller.studentInformation = buildStudentInformation(coordinate)
                self.navigationController?.pushViewController(controller, animated: true)
                
            }

    private func buildStudentInformation(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        
        var studentInfo = [
            "uniqueKey": UdacityClient.Auth.key,
            "firstName": UdacityClient.Auth.firstName,
            "lastName": UdacityClient.Auth.lastName,
            "mapString": locationTextField.text!,
            "mediaURL": linkTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
        ] as [String: AnyObject]

        if let objectId = objectId {
            studentInfo["objectId"] = objectId as AnyObject
            print(objectId)
        }
        return StudentInformation(studentInfo)
    
}

    func setLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.buttonEnabled(false, button: self.findLocationButton) }
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.buttonEnabled(true, button: self.findLocationButton)
                    }
                }
                DispatchQueue.main.async {
                    self.locationTextField.isEnabled = !loading
                    self.linkTextField.isEnabled = !loading
                    self.findLocationButton.isEnabled = !loading
                }
                
            }
        
        // TextFields
        
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == locationTextField {
                let currentText = locationTextField.text ?? ""
                guard let rangeString = Range (range, in: currentText)
                    else {
                        return false
                }
                
                let updatedText = currentText.replacingCharacters(in: rangeString, with: string)
                if updatedText.isEmpty && updatedText == "" {
                    locationTextFieldIsEmpty = true
                } else {
                    locationTextFieldIsEmpty = false
                    
                }
            }
    
            
            if textField == linkTextField {
                let currentText = linkTextField.text ?? ""
                guard let rangeString = Range(range, in: currentText)
                    else {
                        return false
                }
                let updatedText = currentText.replacingCharacters(in: rangeString, with: string)
                if updatedText.isEmpty && updatedText == "" {
                    linkTextFieldIsEmpty = true
                } else {
                    linkTextFieldIsEmpty = false
                }
            }
            
            if locationTextFieldIsEmpty == false && linkTextFieldIsEmpty == false {
                buttonEnabled(true, button: findLocationButton)
            } else {
                buttonEnabled(false, button: findLocationButton)
            }
            return true
}
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonEnabled (false, button: findLocationButton)
        if textField == locationTextField {
            locationTextFieldIsEmpty = true
        }
        if textField == linkTextField {
            linkTextFieldIsEmpty = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as?
            UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            findLocation(findLocationButton as Any)
        }
    return true
        }

    
    
    }
    


