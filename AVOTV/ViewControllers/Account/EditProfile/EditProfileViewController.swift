//
//  EditProfileViewController.swift
//  Taskanize
//
//  Created by Zeeshan Tariq on 30/06/2020.
//  Copyright © 2020 Zeeshan Tariq. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    
    var profileData: LoginUserData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorNavBar(color: UIColor(named: "primary_white")!, navBgColor: UIColor.black)
        title = "Edit Profile"
        addBackButtonToNavBar(color: UIColor(named: "primary_white")!)
        
        genderTextField.delegate = self
        dobTextField.delegate = self
        
        profileData = AppStateManager.shared.loggedInUser
        setProfileData()
    }
    
    
    func setProfileData(){
        if let userData = profileData{
            nameTextField.text = userData.name ?? ""
            genderTextField.text = userData.gender ?? "Male"
            dobTextField.text = Utility.getFormattedDateString(userData.dateofbirth ?? "", format: "MM/dd/yyyy")
        }
    }
    
    func validateData(){
        
        var shouldProceed = true
        var message = ""
        
        if (nameTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please enter your name"
        }
        else if (genderTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please select your gender"
        }
        else if (dobTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please select your date of birth"
        }
        
        if shouldProceed {
            updateProfileApiCall()
        }else{
            Utility.showAlert(title: "Error", message: message)
        }
    }
    
    
    @IBAction func didTapUpdateButton(_ sender: UIButton) {
        view.endEditing(true)
        
        validateData()
        
    }
    
}


// MARK: - API's Calling

extension EditProfileViewController{
    
    func updateProfileApiCall()
    {
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(BasicResponse.self, from: jsonData)
                
                if let status = decodable.code {
                    if status == "200", decodable.status == "true" {
                        
                        Utility.showAlert(title: "Alert", message: "Profile updated successfully.", okTapped: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    else{
                        Utility.showAlert(title: "Error", message: decodable.message ?? "Something went wrong, please try again later.")
                    }
                }
                
            }  catch {
                Utility.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
        
        let failureBlock:DefaultAPIFailureClosure = { error in
            self.stopLoading()
            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        let url = Route.update_Profile.url()
        
        let params = ["Name": nameTextField.text!,
                      "Gender": genderTextField.text!,
                      "DateOfBirth": dobTextField.text!
                     ] as [String : Any]
        
        
        APIHandler.instance.postRequest(route: url, parameters: params, success: successBlock, failure: failureBlock, errorPopup: true)
    }
}



// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    
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
extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
