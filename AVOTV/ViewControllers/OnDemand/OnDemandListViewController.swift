//
//  OnDemandListViewController.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 18/01/2022.
//

import UIKit

class OnDemandListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var onDemandDataList = [OnDemandCategoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorNavBar(color: UIColor(named: "primary_white")!, navBgColor: UIColor.black, title: "On Demand")
        addMenuButtonToNavBar(color: UIColor(named: "primary_white")!)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getAllVideossAPICall()
    }
    
}

extension OnDemandListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated:false)
    }
}

extension OnDemandListViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return onDemandDataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = OnDemandTableViewCell.cellForTableView(tableView, atIndexPath: indexPath)
        cell.videosList = onDemandDataList[indexPath.section].OnDemands
        cell.setupCollectionView()
        cell.collectionView.contentOffset = .zero
        
        cell.didTapVideo = { index in
            let controller = OnDemandViewController(nibName: "OnDemandViewController", bundle: nil)
            controller.videosList = self.onDemandDataList[indexPath.section].OnDemands
            controller.playingIndex = index
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 5.0, y: 20.0, width: tableView.frame.width - 85, height: 36)
        view.addSubview(titleLabel)
        view.backgroundColor = self.view.backgroundColor
        
        titleLabel.text = onDemandDataList[section].CategoryName ?? ""  //"BBL 2021 best moments"
        
        if let font = UIFont.init(name: "MADETOMMY-Medium", size: 17){
            titleLabel.font = font
        }
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(named: "primary_white")!

        let viewAllBtn = UIButton()
        viewAllBtn.frame = CGRect.init(x: tableView.frame.width - 85, y: 23, width: 70, height: 30)
        viewAllBtn.cornerRadius = 3
        viewAllBtn.backgroundColor = UIColor.init(named: "nav_color")
        view.addSubview(viewAllBtn)
        
        viewAllBtn.setTitle("View All", for: .normal)
        
        if let font = UIFont.init(name: "MADETOMMY-Medium", size: 14){
            viewAllBtn.titleLabel?.font = font
        }
        viewAllBtn.setTitleColor(UIColor.init(named: "primary_White"), for: .normal)
        viewAllBtn.addTarget(self, action: #selector(viewAllPressed), for: .touchUpInside)
        viewAllBtn.tag = section
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    @objc func viewAllPressed(sender: UIButton) {
        let controller = OnDemandViewController(nibName: "OnDemandViewController", bundle: nil)
        controller.videosList = onDemandDataList[sender.tag].OnDemands
        controller.playingIndex = 0
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// Web API's Calling
extension OnDemandListViewController {
    
    func getAllVideossAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(GetVideosResponse.self, from: jsonData)
                
                if let code = decodable.code {
                    if code == "200", decodable.status == "true" {
                        if let data = decodable.data{
                            self.onDemandDataList = data
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
            self.stopLoading()
            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        let url = Route.get_OnDemandVideos.url()
        
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
}
