//
//  UIViewController.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import UIKit
extension UIViewController {
    

    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityClient.logout { success, error in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func buttonEnabled(_ enabled: Bool, button: UIButton) {
        if enabled {
            button.isEnabled = true
            
        } else {
            
            button.isEnabled = false
        }
    }
    //Alerts
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController (title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
}
    
    //open links
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url)
            else {
                showAlert(message: "Cannot open link", title: "Invalid URL")
                return
        }
}
}
