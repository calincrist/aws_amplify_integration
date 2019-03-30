//
//  ConfirmSignUpViewController.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 27/03/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import AWSMobileClient

class ConfirmSignUpViewController: UIViewController {

    @IBOutlet weak var verificationCodeTextField: UITextField!
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
    
    func resendSignUpHandler(result: SignUpResult?, error: Error?) {
        if let error = error {
            print("\(error)")
            return
        }
        
        guard let signUpResult = result else {
            return
        }
        
        let message = "A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) at \(signUpResult.codeDeliveryDetails!.destination!)"
        let alert = UIAlertController(title: "Code Sent",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            //Cancel Action
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func resendCode(_ sender: Any) {
        guard let username = self.username else {
            print("No username")
            return
        }
        
        AWSMobileClient.sharedInstance().resendSignUpCode(username: username,
                                                          completionHandler: resendSignUpHandler)
    }
    
    func handleConfirmation(signUpResult: SignUpResult?, error: Error?) {
        if let error = error {
            print("\(error)")
            return
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
            print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
        case .unknown:
            print("Unexpected case")
        }
    }
    
    @IBAction func confirmSignUp(_ sender: Any) {
        
        guard let verificationCode = verificationCodeTextField.text,
            let username = self.username else {
            print("No username")
            return
        }
        
        AWSMobileClient.sharedInstance().confirmSignUp(username: username,
                                                       confirmationCode: verificationCode,
                                                       completionHandler: handleConfirmation)
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
