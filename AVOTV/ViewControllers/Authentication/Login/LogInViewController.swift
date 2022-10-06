//
//  LogInViewController.swift
//  Taskanize
//
//  Created by Zeeshan on 7/9/19.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import UIKit
import CoreLocation

class LogInViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isPresentedVC = false
    
    let locationManager = CLLocationManager()
    var location: CLLocation?

    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var city: String = "unknown"
    var country: String = "unknown"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPresentedVC {
            setupTransparentNavBar()
            addBackButtonToNavBar(backImage: #imageLiteral(resourceName: "cross"))
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if authStatus == .denied || authStatus == .restricted {
            // add any alert or inform the user to to enable location services
        }
        
        // here you can call the start location function
        startLocationManager()
    }
    
    override func goBack() {
        dismiss(animated: true, completion: nil)
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
        }else if (passwordTextField.text?.isEmpty)! {
            shouldProceed = false
            message = "Please enter your password"
        }
        
        if shouldProceed {
            loginAPICall()
        }else{
            Utility.showAlert(title: "Error", message: message)
        }
    }
    
    func startLocationManager() {
        // always good habit to check if locationServicesEnabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print the error to see what went wrong
        print("didFailwithError\(error)")
        // stop location manager if failed
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // if you need to get latest data you can get locations.last to check it if the device has been moved
        let lastLocation = locations.last!
        
        // here check if no need to continue just return still in the same place
        if lastLocation.horizontalAccuracy < 0 {
            return
        }
        // if it location is nil or it has been moved
        if location == nil || location!.horizontalAccuracy > lastLocation.horizontalAccuracy {
            
            location = lastLocation
            // stop location manager
            stopLocationManager()
            
            // Here is the place you want to start reverseGeocoding
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                // always good to check if no error
                // also we have to unwrap the placemark because it's optional
                // I have done all in a single if but you check them separately
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    self.placemark = placemark.last
                }
                // a new function where you start to parse placemarks to get the information you need
                self.parsePlacemarks()
            })
        }
    }
    
    func parsePlacemarks() {
        // here we check if location manager is not nil using a _ wild card
        if let _ = location {
            // unwrap the placemark
            if let placemark = placemark {
                // wow now you can get the city name. remember that apple refers to city name as locality not city
                // again we have to unwrap the locality remember optionalllls also some times there is no text so we check that it should not be empty
                if let city = placemark.locality, !city.isEmpty {
                    // here you have the city name
                    // assign city name to our iVar
                    self.city = city
                }
                // the same story optionalllls also they are not empty
                if let country = placemark.country, !country.isEmpty {
                    
                    self.country = country
                }
            }
            
        } else {
            // add some more check's if for some reason location manager is nil
        }
        
    }
    
}

// Buttons Tap Actions
extension LogInViewController{

    @IBAction func didTapSkipButton(_ sender: UIButton) {
        view.endEditing(true)
        AppStateManager.shared.isUserLoggedIn = false
        Constants.APP_DELEGATE.loadHomeController()
    }
    
    @IBAction func didTapLogInButton(_ sender: UIButton) {
        view.endEditing(true)
        validateData()
    }
    
    @IBAction func didTapForgetPassButton(_ sender: UIButton) {
        let controller = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        let controller = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


// MARK: - API's Calling

extension LogInViewController{
    
    func loginAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(LoginModal.self, from: jsonData)
                
                print(response)
                
                if let code = decodable.code {
                    if code == "200", decodable.status == "true" {
                        if let user = decodable.data, let token = user.token {
                            AppStateManager.shared.loggedInUser = user
                            AppStateManager.shared.authToken =  "Bearer " + token
                            AppStateManager.shared.isUserLoggedIn = true
                            // Constants.APP_DELEGATE.registerToken()
                            Constants.APP_DELEGATE.loadHomeController()
                        }
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
        
        let url = Route.login.url()
        
        let fcmToken = AppStateManager.shared.fcmToken ?? "fcmToken"
        
        let params = ["Email":emailTextField.text!,
                      "Password":passwordTextField.text!,
                      "City":city,
                      "Country": country,
                      "DeviceType":"Phone",
                      "DeviceName": UIDevice().model,
                      "FcmToken": fcmToken] as [String : Any]
                
        print(params)
        APIHandler.instance.postRequest(route: url, parameters: params, success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
}
