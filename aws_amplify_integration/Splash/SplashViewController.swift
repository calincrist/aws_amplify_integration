//
//  SplashViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import KeychainAccess
import AWSMobileClient

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            guard let userState = userState else {
                return
            }
            
            print("The user is \(userState.rawValue).")
            
            // Check if user availability
            switch userState {
            case .signedIn:
                // Show home page
                let mainViewController = MainViewController()
                UIApplication.setRootView(mainViewController)
                break
                
            default:
                // Show login page
                let loginViewController = LoginViewController()
                UIApplication.setRootView(loginViewController)
                break
            }
        }
    }
}
