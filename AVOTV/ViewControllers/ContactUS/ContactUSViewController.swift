//
//  ContactUSViewController.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 12/06/2021.
//

import UIKit

class ContactUSViewController: BaseViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fbLabel: UILabel!
    @IBOutlet weak var instaLabel: UILabel!
    @IBOutlet weak var youtubeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var contactUsList: ContactUS?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorNavBar(color: UIColor(named: "primary_white")!, navBgColor: UIColor.black)
        addBackButtonToNavBar(color: UIColor(named: "primary_white")!)
        
        title = "Contact us"
        
        emailLabel.text = ""
        fbLabel.text = ""
        instaLabel.text = ""
        youtubeLabel.text = ""
        addressLabel.text = ""

        getContactUsDetailsAPICall()
    }

    
    func setData() {
        
        if let data = contactUsList {
            
            if !(data.Email?.isEmpty ?? true) {
                emailLabel.text = data.Email ?? ""
            }
            
            if !(data.Facebook?.isEmpty ?? true) {
                fbLabel.text = data.Facebook ?? ""
            }
            
            if !(data.Instagram?.isEmpty ?? true) {
                instaLabel.text = data.Instagram ?? ""
            }
            
            if !(data.Youtube?.isEmpty ?? true) {
                youtubeLabel.text = data.Youtube ?? ""
            }
            
            if !(data.Address?.isEmpty ?? true) {
                addressLabel.text = data.Address ?? ""
            }
            
        }
    }
    
    
    @IBAction func didTapButton(_ sender:UIButton) {
//        switch sender.tag {
//        case 0:
//            if let url = URL(string: "https://www.hackingwithswift.com") {
//                UIApplication.shared.open(url)
//            }
//        default:
//            break
//        }
    }
    
}


extension ContactUSViewController {
    
    func getContactUsDetailsAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(GetContactUsResponse.self, from: jsonData)
                
                if let code = decodable.code{
                    if code == "200", decodable.status == "true" {
                        if let data = decodable.data{
                            self.contactUsList = data
                            self.setData()
                        }
                    }
                    else{
                        Utility.showAlert(title: "Alert", message: decodable.message ?? "Something went wrong, please try again later.")
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
        
        let url = "https://api.commec.tv/api/v1/contactus"   //Route.ContactUS.url()
        
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }

}
