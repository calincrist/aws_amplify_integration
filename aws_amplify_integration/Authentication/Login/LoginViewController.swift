//
//  LoginViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
