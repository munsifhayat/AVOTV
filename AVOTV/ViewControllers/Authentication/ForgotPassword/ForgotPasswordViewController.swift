//
//  ForgotPasswordViewController.swift
//  Construction
//
//  Created by Apple on 27/09/2019.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func validateData(){
        
        var shouldProceed = true
        var message = ""
        
        if (emailTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please enter your email address"
        }else if !Utility.isValidEmail(testStr: emailTextField.text!){
            shouldProceed = false
            message = "Please provide valid email address"
        }
        if shouldProceed {
            forgotPasswordAPICall()
        }else{
            Utility.showAlert(title: "Error", message: message)
        }
    }
    
}

// Buttons Tap Actions
extension ForgotPasswordViewController{
    
    @IBAction func didTapForgotPasswordButton(_ sender: UIButton) {
        view.endEditing(true)
        validateData()
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

// Web API's Calling

extension ForgotPasswordViewController{
    
    func forgotPasswordAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(BasicResponse.self, from: jsonData)
                
                if let code = decodable.code {
                    if code == "200", decodable.status == "true" {
                        Utility.showAlert(title: "Alert", message: decodable.message ?? "Email has been sent to your account", okTapped: {
                            let controller = ResetPasswordViewController()
                            controller.email = self.emailTextField.text!
                            self.navigationController?.pushViewController(controller, animated: true)
                        })
                    }
                    else {
                        Utility.showAlert(title: "Alert", message: decodable.message ?? "Something went wrong, please try again later.")
                    }
                }
                
            }  catch {
                Utility.showAlert(title: "Error!", message: "Something went wrong, please try again later.")
            }
            
        }
        
        let failureBlock:DefaultAPIFailureClosure = { error in
            self.stopLoading()
            Utility.showAlert(title: "Error!", message: error.localizedDescription)
        }
        
        let url = Route.forgetPassword.url()+"?Email=\(emailTextField.text!)"
        
//        let params = ["email":emailTextField.text!] as [String : Any]
        
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
}

