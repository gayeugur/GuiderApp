//
//  ViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 5.10.2023.
//

import UIKit
import Firebase
//g@gmail.com 123457


class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var rePasswordText: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var isLogin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func isLoginHidden() {
        usernameText.isHidden = true
        rePasswordText.isHidden = true
        isLogin = true
    }
    
    private func isNotUser() {
        usernameText.isHidden = false
        rePasswordText.isHidden = false
        isLogin = false
    }
    
    private func setup() {
        segmentedControl.setTitle("Sign In", forSegmentAt: 0)
        segmentedControl.setTitle("Sign Up", forSegmentAt: 1)
        isLoginHidden()
        nextButton.layer.cornerRadius = 20
    }

    @IBAction func segmentedAction(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0 :
            isLoginHidden()
        case 1 :
            isNotUser()
        default:
            print("Default case")
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if isLogin {
            
            if mailText.text != "" && passwordText.text != "" {
                
                Auth.auth().signIn(withEmail: mailText.text!, password: passwordText.text!) { (authdata, error) in
                    if error != nil {
                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")

                    } else {
                        print("successs")
                        self.performSegue(withIdentifier:"toHomePage" , sender: nil)
                        
                    }
                }
                
                
            } else {
                makeAlert(titleInput: "Error!", messageInput: "Username/Password?")

            }
            
        } else {
            if mailText.text != "" && passwordText.text != "" && rePasswordText.text != "" && passwordText.text == rePasswordText.text {
                Auth.auth().createUser(withEmail: mailText.text!, password: passwordText.text!) { (authdata, error) in
                    
                    if error != nil {
                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        print("successs")
                        self.performSegue(withIdentifier:"toHomePage" , sender: nil)
                      
                        
                    }
                }
                
            } else {
                makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
            }
        }
      
    }
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
    }
    
    
}

