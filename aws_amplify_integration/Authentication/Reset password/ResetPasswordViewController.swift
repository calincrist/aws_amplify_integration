//
//  ResetPasswordViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import AWSMobileClient

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitUsername(_ sender: Any) {
        
        guard let username = usernameTextField.text else {
            print("No username")
            return
        }
        
        AWSMobileClient.sharedInstance().forgotPassword(username: username) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    let alert = UIAlertController(title: "Code sent", message: "Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { _ in
                        let newPasswordViewController = NewPasswordViewController(username: username)
                        self.navigationController?.pushViewController(newPasswordViewController, animated: true)
                    })
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                default:
                    print("Error: Invalid case.")
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
