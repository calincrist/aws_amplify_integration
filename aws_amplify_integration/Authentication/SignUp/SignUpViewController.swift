//
//  SignUpViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import AWSMobileClient

class SignUpViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func signUpHandler(signUpResult: SignUpResult?, error: Error?) {
        
        if let error = error {
            if let error = error as? AWSMobileClientError {
                switch(error) {
                case .usernameExists(let message):
                    print(message)
                default:
                    break
                }
            }
            print("There's an error on signup: \(error.localizedDescription), \(error)")
        }
        
        guard let signUpResult = signUpResult else {
            return
        }
        
        switch(signUpResult.signUpConfirmationState) {
        case .confirmed:
            print("User is signed up and confirmed.")
            
            DispatchQueue.main.async {
                let mainViewController = MainViewController()
                UIApplication.setRootView(mainViewController)
            }
            
        case .unconfirmed:
            let alert = UIAlertController(title: "Code sent",
                                          message: "Confirmation code sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) to: \(signUpResult.codeDeliveryDetails!.destination!)",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { _ in
                guard let username = self.usernameTextField.text else {
                    return
                }
                let confirmSignupViewController = ConfirmSignUpViewController(username: username)
                self.navigationController?.pushViewController(confirmSignupViewController, animated: true)
            })
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        case .unknown:
            print("Unexpected case")
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        guard let fullName = fullNameTextField.text,
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text else {
            return
        }
        
        AWSMobileClient.sharedInstance().signUp(username: username,
                                                password: password,
                                                userAttributes: ["email" : email, "name": fullName],
                                                completionHandler: signUpHandler);
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
