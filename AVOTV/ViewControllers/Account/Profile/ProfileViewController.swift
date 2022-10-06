//
//  ProfileViewController.swift
//  Taskanize
//
//  Created by Zeeshan Tariq on 30/06/2020.
//  Copyright © 2020 Zeeshan Tariq. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: BaseViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var profileData: LoginUserData?
    
    var didEditProfile: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileData = AppStateManager.shared.loggedInUser
        setProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        getProfileDataAPICall()
    }

    func setProfileData(){
        if let userData = profileData{
            nameTF.text = userData.name ?? ""
            emailTF.text = userData.email ?? ""
            genderTF.text = userData.gender ?? "N/A"
            if userData.dateofbirth != nil {
                dobTF.text = Utility.getFormattedDateString(userData.dateofbirth ?? "", format: "MM/dd/yyyy")
            }
            else {
                dobTF.text = "N/A"
            }
            passwordTF.text = "1233424"
        }
    }
    
    @IBAction func updateProfileTapped(_: UIButton)
    {
        self.didEditProfile?()
        
    }
    
}

// MARK: - API's Calling

extension ProfileViewController{
    
//    func getProfileDataAPICall(){
//
//        startLoading()
//
//        let successBlock:DefaultAPISuccessClosure = { response in
//
//            self.stopLoading()
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                let decodable = try JSONDecoder().decode(GetProfileResponse.self, from: jsonData)
//
//                if let status = decodable.status{
//                    if status == 200{
//                        if let profileData = decodable.data{
//                            AppStateManager.shared.profileData = profileData
//                            self.profileData = profileData
//                            AppStateManager.shared.loggedInUser?.name = profileData.na ?? ""
//                            AppStateManager.shared.loggedInUser?.profile_pic = profileData.profile_pic ?? ""
//                            self.setProfileData()
//                        }
//                    }
//                    else if status == 401{
//                        Utility.showAlert(title: "Error", message: decodable.msg ?? "Something went wrong, please try again later.")
//                    }
//                    else{
//                        Utility.showAlert(title: "Error", message: "Something went wrong, please try again later.")
//                    }
//                }
//
//            }  catch {
//                Utility.showAlert(title: "Error", message: "Something went wrong, please try again later.")
//            }
//
//        }
//
//        let failureBlock:DefaultAPIFailureClosure = { error in
//            self.stopLoading()
//            Utility.showAlert(title: "Error", message: error.localizedDescription)
//        }
//
//        let url = Route.get_Profile.url()
//
//        let params: Parameters = [:]
//
//        APIHandler.instance.getRequest(route: url, parameters: params, success: successBlock, failure: failureBlock, errorPopup: true)
//    }
    
}

