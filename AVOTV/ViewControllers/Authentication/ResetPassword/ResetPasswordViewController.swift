//
//  ResetPasswordViewController.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 03/07/2021.
//

import UIKit

class ResetPasswordViewController: BaseViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTransparentNavBar()
        addBackButtonToNavBar()
    }
    
    
    func validateData(){
        
        var shouldProceed = true
        var message = ""
        
        if (codeTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please enter the code you received via email"
        }
//        else if (emailTextField.text?.isEmpty)! {
//            shouldProceed = false
//            message = "Please enter your email address"
//        }
//        else if !Utility.isValidEmail(testStr: emailTextField.text!){
//            shouldProceed = false
//            message = "Please provide valid email address"
//        }
        else if (passwordTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please enter your password"
        }
        else if (confirmPasswordTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please re-enter your password"
        }
        else if (confirmPasswordTextField.text! != passwordTextField.text!) {
            shouldProceed = false
            message = "Password doesn't matched"
        }
        
        if shouldProceed {
            resetPasswordAPICall()
        }else{
            Utility.showAlert(title: "Error", message: message)
        }
    }
    

    @IBAction func didTapResetPassButton(_ sender: UIButton) {
        view.endEditing(true)
        validateData()
    }
    
}


// MARK: - API's Calling

extension ResetPasswordViewController{
    
    func resetPasswordAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(BasicResponse.self, from: jsonData)
                
                if let status = decodable.code{
                    if status == "200", decodable.status == "true" {
                        Utility.showAlert(title: "Alert", message: decodable.message ?? "Your password has been reset successfully.", okTapped: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    else {
                        Utility.showAlert(title: "Error!", message: decodable.message ?? "Something went wrong, please try again later.")
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
        
        let url = Route.forgetPassword.url()
                
        let params = ["Code": codeTextField.text!,
                      "Email": email,/// emailTextField.text!,
                      "Password":passwordTextField.text!] as [String : Any]
                
        print(params)
        APIHandler.instance.postRequest(route: url, parameters: params, success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
}
