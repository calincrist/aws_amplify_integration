//
//  LoginViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import AWSMobileClient

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: Any) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text  else {
            print("Enter some values please.")
            return
        }
        
        print("\(username) and \(password)")
        
        AWSMobileClient.sharedInstance().signIn(username: username, password: password) {
            (signInResult, error) in
                if let error = error  {
                    print("There's an error : \(error.localizedDescription)")
                    print(error)
                    return
                }
            
                guard let signInResult = signInResult else {
                    return
                }
            
                switch (signInResult.signInState) {
                case .signedIn:
                    print("User is signed in.")
                    
                    DispatchQueue.main.async {
                        let mainViewController = MainViewController()
                        let navigationController = UINavigationController(rootViewController: mainViewController)
                        UIApplication.setRootView(navigationController)
                    }
                    
                case .newPasswordRequired:
                    print("User needs a new password.")
                default:
                    print("Sign In needs info which is not et supported.")
                }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let signUpViewController = SignUpViewController()
        let modalNavigationController = UINavigationController(rootViewController: signUpViewController)
        modalNavigationController.isNavigationBarHidden = true
        
        self.present(modalNavigationController, animated: true, completion: nil)
    }
    @IBAction func forgotPassword(_ sender: Any) {
        let resetPasswordViewController = ResetPasswordViewController()
        
        let modalNavigationController = UINavigationController(rootViewController: resetPasswordViewController)
        modalNavigationController.isNavigationBarHidden = true
        
        self.present(modalNavigationController, animated: true, completion: nil)
    }
}
