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
    @IBOutlet weak var userNameTextField: UITextField!
    
    //MARK: PROPERTIES
    var isLogin = true
    let userModel = UserModel()
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        mailText.text = "gayeugur00@gmail.com"
        passwordText.text = "123123"
    }
    
    //MARK: PRIVATE FUNCTION
    private func isLoginHidden() {
        rePasswordText.isHidden = true
        userNameTextField.isHidden = true
        isLogin = true
        nextButton.setTitle("Sign In", for: .normal)
    }
    
    private func isNotUser() {
        rePasswordText .isHidden = false
        userNameTextField.isHidden = false
        isLogin = false
        nextButton?.setTitle("Sign Up", for: .normal)
    }
    
    private func setup() {
        segmentedControl.setTitle("Sign In", forSegmentAt: 0)
        segmentedControl.setTitle("Sign Up", forSegmentAt: 1)
        isLoginHidden()
        nextButton?.layer.cornerRadius = 20
        nextButton?.setTitle("Sign In", for: .normal)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: @IBACTION
    @IBAction func segmentedAction(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0 :
            isLoginHidden()
        case 1 :
            isNotUser()
        default:
            Helper.makeAlert(on: self,
                             titleInput: ConstantMessages.errorTitle,
                             messageInput: ConstantMessages.serviceError)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if isLogin {
            if let mail = mailText.text, let password = passwordText.text {
                userModel.setUserWithAllInformation(email: mail, password: password) { result in
                    switch result {
                    case .success(let user):
                        if user.isActive ?? false {
                            
                            Helper.makeAlert(on: self,
                                             titleInput: ConstantMessages.errorTitle,
                                             messageInput: ConstantMessages.isActiveError)
                            return
                        }
                        UserManager.shared.setUser(user: user)
                        self.setStatus()
                        
                    case .failure(let error):
                        Helper.makeAlert(on: self,
                                         titleInput: ConstantMessages.errorTitle,
                                         messageInput: error.localizedDescription)
                    }
                }
                
            } else {
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: ConstantMessages.loginError)
                
            }
            
        } else {
            if let mail = mailText.text,
               let password = passwordText.text,
               let rePassword = rePasswordText.text,
               password == rePassword,
               let userName = userNameTextField.text {
                Auth.auth().createUser(withEmail: mail, password: password) { (authdata, error) in
                    
                    if error != nil {
                        Helper.makeAlert(on: self,
                                         titleInput: ConstantMessages.errorTitle,
                                         messageInput: error?.localizedDescription ?? ConstantMessages.genericError)
                    } else {
                        let user = User(username:userName, password: password , mail: mail)
                        UserManager.shared.setUser(user: user)
                        self.userModel.updateActiveStatus(isActive: true) {
                            result in
                            switch result {
                            case .success(_):
                                self.userModel.addUser(user: user)
                                self.performSegue(withIdentifier:"toHome" , sender: nil)
                            case .failure(_):
                                Helper.makeAlert(on: self,
                                                 titleInput: ConstantMessages.errorTitle,
                                                 messageInput: error?.localizedDescription ?? ConstantMessages.genericError)
                            }
                        }
            
                    }
                }
                
            } else {
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: ConstantMessages.isActiveError)
            }
        }
        
    }
    
    
    func setStatus() {
        userModel.updateActiveStatus(isActive: true) { result in
            switch result {
            case .success(_):
                self.performSegue(withIdentifier:"toHome", sender: nil)
            case .failure(let error):
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: error.localizedDescription)
            }
            
        }
    }
    
}

