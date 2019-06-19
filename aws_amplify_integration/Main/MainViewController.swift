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
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
        
        let logOutBarButtonItem = UIBarButtonItem(title: "Log out",
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(logOut(_:)))
        self.navigationItem.rightBarButtonItem = logOutBarButtonItem
        
        self.imagePicker = ImagePicker(presentationViewController: self, delegate: self)
    }

    @IBAction func uploadAttachment(_ sender: Any) {
        imagePicker.present()
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

extension MainViewController: ImagePickerDelegate {
    func didSelectImage(_ image: UIImage?, withName imageName: String?) {
        
        guard let image = image else {
            return
        }
        
        // Data to be uploaded
        guard let data = image.pngData() as Data? else {
            return
        }
        
        print("imageName: \(imageName)")

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
                
                print("task: \(task)")
                print("error: \(progress)")
            })
        }

        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                
                print("task: \(task)")
                print("error: \(error)")
            })
        }

        let transferUtility = AWSS3TransferUtility.default() { (error) in
            print("AWSS3TransferUtility init error: \(error)")
        }
        

        transferUtility.uploadData(data,
                                   bucket: "awsamplifyintegrationbucket-dev",
                                   key: imageName ?? "example_image",
                                   contentType: "image/png",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }

                                    if let result = task.result {
                                        // Do something with uploadTask.
                                        print(result)
                                    }
                                    return nil;
        }
    }
}
