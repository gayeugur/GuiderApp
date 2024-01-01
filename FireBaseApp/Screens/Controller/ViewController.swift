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
    
    //MARK: @IBOUTLET
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var rePasswordText: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: PROPERTIES
    var isLogin = true
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        mailText.text = "gayeugur00@gmail.com"
        passwordText.text = "123123"
    }
    
    //MARK: PRIVATE FUNCTION
    private func isLoginHidden() {
        rePasswordText.isHidden = true
        isLogin = true
        nextButton.setTitle("Sign In", for: .normal)
    }
    
    private func isNotUser() {
        rePasswordText .isHidden = false
        isLogin = false
        nextButton?.setTitle("Sign Up", for: .normal)
    }
    
    private func setup() {
        segmentedControl.setTitle("Sign In", forSegmentAt: 0)
        segmentedControl.setTitle("Sign Up", forSegmentAt: 1)
        isLoginHidden()
        nextButton?.layer.cornerRadius = 20
        nextButton?.setTitle("Sign In", for: .normal)
    }
    
    //MARK: @IBACTION
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
            if let mail = mailText.text, let password = passwordText.text {
                
                Auth.auth().signIn(withEmail: mail, password: password) { (authdata, error) in
                    if error != nil {
                        Constant.makeAlert(on: self, titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                        
                    } else {
                        let user = User(password: password, mail: mail)
                        UserManager.shared.setUser(user: user)
                        print("successs")
                        self.performSegue(withIdentifier:"toHome" , sender: nil)
                    }
                }
                
                
            } else {
                Constant.makeAlert(on: self, titleInput: "Error!", messageInput: "Username/Password?")
                
            }
            
        } else {
            if let mail = mailText.text, let password = passwordText.text, let rePassword = rePasswordText.text, password == rePassword {
                Auth.auth().createUser(withEmail: mail, password: password) { (authdata, error) in
                    
                    if error != nil {
                        Constant.makeAlert(on: self, titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        self.performSegue(withIdentifier:"toHome" , sender: nil)
                    }
                }
                
            } else {
                Constant.makeAlert(on: self, titleInput: "Error!", messageInput: "Username/Password?")
            }
        }
        
    }
    
    
}

