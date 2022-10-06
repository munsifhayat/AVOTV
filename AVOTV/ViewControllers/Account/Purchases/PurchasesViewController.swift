//
//  PurchasesViewController.swift
//  Construction
//
//  Created by Apple on 27/11/2019.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import UIKit
import Alamofire

class PurchasesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    
    var purchases_List = [CategoryModel]()
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        getPurchasesAPICall()
        
    }
    
    
    @objc func refreshPage(sender:AnyObject) {
        refreshControl.beginRefreshing()
//        getPurchasesAPICall()
    }
    
}

extension PurchasesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
}

extension PurchasesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DeviceTableViewCell.cellForTableView(tableView, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let titleLabel = UILabel()
        let yAxis = (tableView.frame.height / 2 ) - 65
        titleLabel.frame = CGRect.init(x: 7.0, y: yAxis, width: tableView.frame.width - 7.0, height: 50.0)
        view.addSubview(titleLabel)
        view.backgroundColor = .clear

        titleLabel.text = "No purchase(s) yet!"

        if let font = UIFont(name: "MADETOMMY-Medium", size: 17){
            titleLabel.font = font
        }
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(named: "primary_white")!

        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return purchases_List.count == 0 ? tableView.frame.height - 40 : 0
    }
    
}


// Web API's Calling

extension PurchasesViewController {
    
    func getPurchasesAPICall(){
        
       if !refreshControl.isRefreshing{
            startLoading()
        }
        
        let successBlock:DefaultAPISuccessClosure = { response in
            self.refreshControl.endRefreshing()
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(GetCategoriesResponse.self, from: jsonData)
                
                if let code = decodable.code {
                    if code == 200{
                        if let purchases = decodable.data{
                            self.purchases_List  = purchases
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
                
        let url = Route.get_AllChannels.url()
                
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
}
