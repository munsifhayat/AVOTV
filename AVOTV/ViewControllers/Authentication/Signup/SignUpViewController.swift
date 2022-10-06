//
//  LogInViewController.swift
//  Taskanize
//
//  Created by Zeeshan on 7/9/19.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderTextField.delegate = self
        dobTextField.delegate = self
    }
    
    func validateData(){
        
        var shouldProceed = true
        var message = ""
        
        if (nameTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please enter your name"
        }
        else if (emailTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please enter your email address"
        }
        else if !Utility.isValidEmail(testStr: emailTextField.text!){
            shouldProceed = false
            message = "Please provide valid email address"
        }
//        else if (genderTextField.text?.isEmpty)! {
//            shouldProceed = false
//            message = "Please select your gender"
//        }
//        else if (dobTextField.text?.isEmpty)! {
//            shouldProceed = false
//            message = "Please select your date of birth"
//        }
        else if (passwordTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please enter your password"
        }
        else if (passwordTextField.text?.count ?? 0 < 8) {
            shouldProceed = false
            message = "The password must be at least 8 characters long"
        }
        else if (confirmPasswordTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please confirm your password"
        }
        else if (confirmPasswordTextField.text! != passwordTextField.text!) {
            shouldProceed = false
            message = "Password doesn't matched"
        }
        
        if shouldProceed {
            signUpAPICall()
        }else{
            Utility.showAlert(title: "Error", message: message)
        }
    }
    
}

// Buttons Tap Actions
extension SignUpViewController{
    
    @IBAction func didTapLogInButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        view.endEditing(true)
        validateData()
    }
    
}


// MARK: - API's Calling

extension SignUpViewController{
    
    func signUpAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(BasicResponse.self, from: jsonData)
                
                if let status = decodable.code {
                    if status == "200", decodable.status == "true" {
                        Utility.showAlert(title: "Alert", message: decodable.message ?? "You have been registerd successfully.", okTapped: {
                            self.navigationController?.popViewController(animated: true)
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
        
        let url = Route.signup.url()
        
//        let token = AppStateManager.shared.fcmToken ?? "fcmToken"
        
        let params = ["Email":emailTextField.text!,
                      "Password":passwordTextField.text!,
                      "Name": nameTextField.text!,
//                      "Gender": "", //genderTextField.text!,
//                      "DateOfBirth": "", //dobTextField.text!,
                      ] as [String : Any]
                
        print(params)
        APIHandler.instance.postRequest(route: url, parameters: params, success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
}



// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == dobTextField {
            dobTextField.tag = 1
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            datePickerView.maximumDate = Date()
            
            if #available(iOS 13.4, *) {
                datePickerView.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            dobTextField.addTarget(self, action: #selector(handleDoneButton(sender:)), for: .editingDidEnd)
        }
        
        else if textField == genderTextField {
            genderTextField.tag = 0
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            textField.inputView = pickerView
            genderTextField.addTarget(self, action: #selector(handleDoneButton(sender:)), for: .editingDidEnd)
        }
        
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dobTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleDoneButton(sender: UITextField) {
        
        if sender.text?.isEmpty ?? false {
            if sender.tag == 1 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                dobTextField.text = dateFormatter.string(from: Date())
            }
            else {
                genderTextField.text = "Male"
            }
        }
    }
    
}



// MARK: - UIPickerViewDelegation
extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
 
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return row == 0 ? "Male" : "Female"
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        genderTextField.text = row == 0 ? "Male" : "Female"
    }
    
}
