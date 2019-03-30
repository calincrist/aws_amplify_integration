//
//  NewPasswordViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import AWSMobileClient

class NewPasswordViewController: UIViewController {
    
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var username: String?
    
    init(username: String, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.username = username
        super.init(nibName:nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func verifyCode(_ sender: Any) {
        
        guard let username = username,
            let newPassword = newPasswordTextField.text,
            let confirmationCode = verificationCodeTextField.text else {
            return
        }
        
        AWSMobileClient.sharedInstance().confirmForgotPassword(username: username,
                                                               newPassword: newPassword,
                                                               confirmationCode: confirmationCode) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .done:
                    self.dismiss(self)
                default:
                    print("Error: Could not change password.")
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
