//
//  SettingsViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 31.10.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var reNewPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var mailLabel: UILabel!
    
    //MARK: PROPERTIES
    let viewModel = UserModel()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: PRIVATE FUNCTION
    private func initUI() {
        saveButton.layer.cornerRadius = 12
        mailView.layer.cornerRadius = 24
        self.title = "Settings"
        mailLabel.text = UserManager.shared.currentUser?.mail
    }
    
    private func checkPasswordValidate() -> Bool {
        if newPassword.text?.count ?? 0 == 6 {
            return true
        }
        return false
    }
    
    
    //MARK: @IBACTION
    @IBAction func saveAction(_ sender: Any) {
        if let oldPass = oldPassword.text {
            if oldPass != UserManager.shared.currentUser?.password {
                Constant.makeAlert(on: self, titleInput: "Error", messageInput: "Not same password") // eski şifre ve yazılan eski şifre şifre farklı
            } else if (!checkPasswordValidate()) {
                Constant.makeAlert(on: self, titleInput: "Error", messageInput: "Your password should be 6 character")
            } else if reNewPassword.text != newPassword.text {
                Constant.makeAlert(on: self, titleInput: "Error", messageInput: "Check the information you entered")
            } else {
                viewModel.updateUserPassword(newPassword: newPassword.text ?? "") { result in
                    switch result {
                    case .success:
                        Constant.makeAlert(on: self, titleInput: "Success", messageInput: "")
                        self.oldPassword.text = ""
                        self.newPassword.text = ""
                        self.reNewPassword.text = ""
                    case .failure(let error):
                        Constant.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
                    }
                }
            }
        } else {
            Constant.makeAlert(on: self, titleInput: "Error", messageInput: "Check the information you entered")
        }
    }
    
}

