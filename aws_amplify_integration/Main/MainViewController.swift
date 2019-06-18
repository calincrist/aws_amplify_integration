//
//  MainViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSS3

class MainViewController: UIViewController {

    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
        
        let logOutBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                  target: self,
                                                  action: #selector(logOut(_:)))
        self.navigationItem.rightBarButtonItem = logOutBarButtonItem
    }

    @IBAction func uploadAttachment(_ sender: Any) {
        
        let data: Data = Data() // Data to be uploaded
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(data,
                                   bucket: "YourBucket",
                                   key: "YourFileName",
                                   contentType: "text/plain",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                    }
                                    return nil;
        }
    }
    
    @objc func logOut(_ sender: Any) {
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
