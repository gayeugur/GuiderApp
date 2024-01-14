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
    }
    
    //MARK: PRIVATE FUNCTION
    private func initUI() {
        saveButton.layer.cornerRadius = 12
        mailView.layer.cornerRadius = 24
        self.title = "Settings"
        mailLabel.text = UserManager.shared.currentUser?.mail
        tabBarController?.tabBar.isHidden = false
    }
    
    private func checkPasswordValidate() -> Bool {
        if newPassword.text?.count ?? 0 == 6 {
            return true
        }
        return false
    }
    
    private func resetInformation() {
        self.oldPassword.text = ""
        self.newPassword.text = ""
        self.reNewPassword.text = ""
    }
    
    //MARK: @IBACTION
    @IBAction func saveAction(_ sender: Any) {
        if let oldPass = oldPassword.text {
            if oldPass != UserManager.shared.currentUser?.password {
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput:ConstantMessages.oldPasswordError)
            } else if (!checkPasswordValidate()) {
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: ConstantMessages.lenghtPasswordError)
            } else if reNewPassword.text != newPassword.text {
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: ConstantMessages.rePasswordError)
            } else {
                viewModel.updateUserPassword(newPassword: newPassword.text ?? "") { result in
                    switch result {
                    case .success:
                        Helper.makeAlert(on: self,
                                         titleInput: ConstantMessages.successTitle,
                                         messageInput: ConstantMessages.successDetail)
                        self.resetInformation()
                    case .failure(let error):
                        Helper.makeAlert(on: self,
                                         titleInput: ConstantMessages.errorTitle,
                                         messageInput: error.localizedDescription)
                    }
                }
            }
        } else {
            Helper.makeAlert(on: self,
                             titleInput: ConstantMessages.errorTitle,
                             messageInput: ConstantMessages.genericLoginError)
        }
    }
    
}

