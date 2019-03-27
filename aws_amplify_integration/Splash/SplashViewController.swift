//
//  SplashViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import KeychainAccess

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Check if user availability
        if AppDelegate.keychain!["token"] != nil {
            // Show home page
            let mainViewController = MainViewController()
            UIApplication.setRootView(mainViewController)
        } else {
            // Show login page
            let loginViewController = LoginViewController()
            UIApplication.setRootView(loginViewController)
        }
    }

}
