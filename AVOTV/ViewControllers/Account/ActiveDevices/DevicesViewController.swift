//
//  DevicesViewController.swift
//  Construction
//
//  Created by Apple on 27/11/2019.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import UIKit
import Alamofire

class DevicesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    
    var activeDevices_List = [Device]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshPage), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "refresh_Data"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        getActiveDevicesAPICall()
    }
    
    
    @objc func refreshPage(sender:AnyObject) {
        refreshControl.beginRefreshing()
        getActiveDevicesAPICall()
    }
    
}

extension DevicesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
}

extension DevicesViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeDevices_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DeviceTableViewCell.cellForTableView(tableView, atIndexPath: indexPath)
        let deviceData = activeDevices_List[indexPath.row]
        cell.deviceImageView.image = deviceData.DeviceType == DeviceType.Phone ? #imageLiteral(resourceName: "smartphone_device") : #imageLiteral(resourceName: "laptop_device")
        cell.deviceNameLabel.text = deviceData.DeviceName ?? ""
        cell.locationLabel.text = (deviceData.City ?? "") + ", " + (deviceData.Country ?? "")
        cell.statusView.isHidden = false
        cell.didLogoutPressed = { [weak self] in
            if self != nil{
                self?.deviceLogoutAPICall(deviceId: deviceData.Id ?? "-1")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let titleLabel = UILabel()
        let yAxis = (tableView.frame.height / 2 ) - 65
        titleLabel.frame = CGRect.init(x: 0.0, y: yAxis, width: tableView.frame.width - 7.0, height: 50.0)
        view.addSubview(titleLabel)
        view.backgroundColor = .clear

        titleLabel.text = "No active device(s) yet!"

        if let font = UIFont(name: "MADETOMMY-Medium", size: 17){
            titleLabel.font = font
        }
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(named: "primary_white")!

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return activeDevices_List.count == 0 ? tableView.frame.height - 40 : 0
    }
    
}


// Web API's Calling

extension DevicesViewController{
    
    func getActiveDevicesAPICall() {
        
       if !refreshControl.isRefreshing{
            startLoading()
        }
        
        let successBlock:DefaultAPISuccessClosure = { response in
            self.refreshControl.endRefreshing()
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(GetDevicesResponse.self, from: jsonData)
                
                if let code = decodable.code {
                    if code == "200", decodable.status == "true" {
                        if let activeDevices = decodable.data{
                            self.activeDevices_List  = activeDevices
                            self.tableView.reloadData()
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
            self.refreshControl.endRefreshing()
            self.stopLoading()
            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
                
        let url = Route.get_ActiveDevices.url()
                
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
    func deviceLogoutAPICall(deviceId: String){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(BasicResponse.self, from: jsonData)
                
                if let code = decodable.code {
                    if code == "200", decodable.status == "true" {
                        self.getActiveDevicesAPICall()
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
        
        let url = Route.deviceLogout.url()
        
        
        let params = ["Id" : deviceId] as [String : Any]
        
//        print(params)
        
        APIHandler.instance.postRequest(route: url, parameters: params, success: successBlock, failure: failureBlock, errorPopup: true)
    }
}
