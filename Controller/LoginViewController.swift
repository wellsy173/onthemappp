//
//  LoginViewController.swift
//  On the Mapp
//
//  Created by Simon Wells on 2020/11/20.
//

import Foundation


import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let signUpUrl = UdacityClient.Endpoints.udacitySignUp.url
    var emailTextFieldIsEmpty = true
    var passwordTextFieldIsEmpty = true

    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signUpButton: UIButton!
    //Mark: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
        buttonEnabled(false, button: loginButton)
        let loginButtonFB = FBLoginButton()
        loginButtonFB.center = view.center
        view.addSubview(loginButtonFB)
        DispatchQueue.global().async {
        if let token = AccessToken.current, !token.isExpired {
            loginButtonFB.permissions = ["public_profile", "email"]
        
                    // User is logged in, do work such as go to next view controller.
                }
            }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    emailTextField.text = ""
    passwordTextField.text = ""
    buttonEnabled(true, button: loginButton)
        
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleRequestTokenResponse (success: Bool, error: Error?) {
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) -> Void {
        setLoggingIn(false)
        if success {
                performSegue(withIdentifier: "login", sender: nil)
        } else {
            DispatchQueue.main.async {
                self.showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
                self.activityIndicator.startAnimating()
            self.buttonEnabled(false, button: self.loginButton)
        }else{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.emailTextField.isEnabled = !loggingIn
                self.passwordTextField.isEnabled = !loggingIn
                self.loginButton.isEnabled = !loggingIn
    }
        }
            }
    
    
    @IBAction func signUp(_ sender: Any) {
        setLoggingIn(true)
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
    }
    
    func showLoginFailure(message: String) {
            let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let currentText = emailTextField.text ?? ""
            guard let rangeString = Range(range, in: currentText)
                else {
                    return false }
            let updatedText = currentText.replacingCharacters(in: rangeString, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                emailTextFieldIsEmpty = true
            } else {
                emailTextFieldIsEmpty = false
                }
            }
        
        if textField == passwordTextField {
        let currentText = passwordTextField.text ?? ""
        guard let rangeString = Range(range, in: currentText)
            else {
                return false }
        let updatedText = currentText.replacingCharacters(in: rangeString, with: string)
        
        if updatedText.isEmpty && updatedText == "" {
            passwordTextFieldIsEmpty = true
        } else {
            passwordTextFieldIsEmpty = false
        
    }
    
}
        if emailTextFieldIsEmpty == false && passwordTextFieldIsEmpty == false {
            buttonEnabled(true, button: loginButton)
        } else {
            buttonEnabled(false, button: loginButton)
        }
        
        return true
        
    }
        
        
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            buttonEnabled(false, button: loginButton)
            if textField == emailTextField {
                emailTextFieldIsEmpty = true
            }
            if textField == passwordTextField {
                passwordTextFieldIsEmpty = true
            }
            return true

}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as?
            UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginTapped(loginButton as Any)
            
    
        }
        return true
    }
        
}
