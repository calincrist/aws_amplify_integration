//
//  MainViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import AWSMobileClient

class MainViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logOut(_ sender: Any) {
        AWSMobileClient.sharedInstance().signOut() { error in
            if let error = error {
                print(error)
                return
            }
        }
        
        
        let loginViewController = LoginViewController()
        UIApplication.setRootView(loginViewController)
    }
    
}
