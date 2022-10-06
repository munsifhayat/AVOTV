//
//  SideMenuViewController.swift
//  Construction
//
//  Created by Apple on 03/09/2019.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import UIKit
import Alamofire

class SideMenuViewController:  BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let menuTitles = ["Live TV", "On Demand", "Account" ,"Terms of Service", "Privacy Policy", "Contact Us", "Rate Us"]
        
    let icons:[UIImage] = [#imageLiteral(resourceName: "live_tv"),#imageLiteral(resourceName: "on_demand"),#imageLiteral(resourceName: "account"),#imageLiteral(resourceName: "terms_of_service"),#imageLiteral(resourceName: "privacy_policy"),#imageLiteral(resourceName: "contact_us"),#imageLiteral(resourceName: "rate_us")]
    
    var tapGesture = UITapGestureRecognizer()
    var swipeLeftGesture = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        revealViewController().frontViewController.view.alpha = 0.55
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture))
        revealViewController().frontViewController.view.addGestureRecognizer(tapGesture)
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeftGesture.direction = .left
        revealViewController().frontViewController.view.addGestureRecognizer(swipeLeftGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        revealViewController().frontViewController.view.alpha = 1.0
        revealViewController().frontViewController.view.gestureRecognizers?.removeAll()
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer? = nil) {
        revealViewController().revealToggle(animated: true)
    }
    
    @objc func handleSwipeGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .left {
            revealViewController().revealToggle(animated: true)
        }
    }
    
}


extension SideMenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
//        lastSelection = indexPath
//        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated:false)
        redirect(index: indexPath.row, table: tableView)
    }
}

extension SideMenuViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuTableViewCell.cellForTableView(tableView, atIndexPath: indexPath)
        
        cell.titleLabel.text = menuTitles[indexPath.row]
        cell.iconImageView.image = icons[indexPath.row]
                
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
}


extension SideMenuViewController{
    
    func redirect(index:Int, table: UITableView){
        
        if let navController = revealViewController().frontViewController as? UINavigationController {
                                    
            switch index {
            case 0:
                if (navController.topViewController as? LiveTVViewController) != nil {
                    revealViewController().revealToggle(animated: true)
                }
                else if let vc = navController.topViewController as? OnDemandViewController {
                    vc.videoPlayer.removeFromSuperview()
                    let controller = LiveTVViewController(nibName: "LiveTVViewController", bundle: nil)
                    Constants.APP_DELEGATE.changeRootController(controller)
                }
                else {
                    let controller = LiveTVViewController(nibName: "LiveTVViewController", bundle: nil)
                    Constants.APP_DELEGATE.changeRootController(controller)
                }
                
            case 1:
                if AppStateManager.shared.isUserLoggedIn {
                    if let vc = navController.topViewController as? LiveTVViewController {
                        vc.videoPlayer.removeFromSuperview()
                        let controller = OnDemandListViewController(nibName: "OnDemandListViewController", bundle: nil)
                        Constants.APP_DELEGATE.changeRootController(controller)
                    }
                    else if let _ = navController.topViewController as? AccountViewController {
                        let controller = OnDemandListViewController(nibName: "OnDemandListViewController", bundle: nil)
                        Constants.APP_DELEGATE.changeRootController(controller)
                    }
                }
                else {
                    if let vc = navController.topViewController as? LiveTVViewController {
                        vc.shouldPlayerRemove = false
                    }
                    else if let vc = navController.topViewController as? OnDemandViewController {
                        vc.shouldPlayerRemove = false
                    }
                    let controller = LogInViewController(nibName: "LogInViewController", bundle: nil)
                    controller.isPresentedVC = true
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .fullScreen
                    let presentedController = navController.topViewController
                    nav.modalPresentationCapturesStatusBarAppearance = true
                    presentedController?.present(nav, animated: true, completion: nil)
                }
                revealViewController().revealToggle(animated: true)
            case 2:
                if AppStateManager.shared.isUserLoggedIn {
                    if let vc = navController.topViewController as? LiveTVViewController {
                        vc.videoPlayer.removeFromSuperview()
                    }
                    if let vc = navController.topViewController as? OnDemandViewController {
                        vc.videoPlayer.removeFromSuperview()
                    }
                    let controller = AccountViewController(nibName: "AccountViewController", bundle: nil)
                    Constants.APP_DELEGATE.changeRootController(controller)
                }
                else {
                    if let vc = navController.topViewController as? LiveTVViewController {
                        vc.shouldPlayerRemove = false
                    }
                    else if let vc = navController.topViewController as? OnDemandViewController {
                        vc.shouldPlayerRemove = false
                    }
                    let controller = LogInViewController(nibName: "LogInViewController", bundle: nil)
                    controller.isPresentedVC = true
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .fullScreen
                    let presentedController = navController.topViewController
                    nav.modalPresentationCapturesStatusBarAppearance = true
                    presentedController?.present(nav, animated: true, completion: nil)
                }
                revealViewController().revealToggle(animated: true)
            case 3:
                if let vc = navController.topViewController as? LiveTVViewController {
                    vc.shouldPlayerRemove = false
                }
                else if let vc = navController.topViewController as? OnDemandViewController {
                    vc.shouldPlayerRemove = false
                }
                revealViewController().revealToggle(animated: true)
                let controller = PrivacyPolicyViewController(nibName: "PrivacyPolicyViewController", bundle: nil)
                controller.pageType = .terms
                navController.pushViewController(controller, animated: true)
            case 4:
                if let vc = navController.topViewController as? LiveTVViewController {
                    vc.shouldPlayerRemove = false
                }
                else if let vc = navController.topViewController as? OnDemandViewController {
                    vc.shouldPlayerRemove = false
                }
                revealViewController().revealToggle(animated: true)
                let controller = PrivacyPolicyViewController(nibName: "PrivacyPolicyViewController", bundle: nil)
                controller.pageType = .privacy
                navController.pushViewController(controller, animated: true)
            case 5:
                if let vc = navController.topViewController as? LiveTVViewController {
                    vc.shouldPlayerRemove = false
                }
                else if let vc = navController.topViewController as? OnDemandViewController {
                    vc.shouldPlayerRemove = false
                }
                revealViewController().revealToggle(animated: true)
                let controller = ContactUSViewController(nibName: "ContactUSViewController", bundle: nil)
                navController.pushViewController(controller, animated: true)
            case 6:
                if let vc = navController.topViewController as? LiveTVViewController {
                    vc.videoPlayer?.pauseVideo()
                    vc.shouldPlayerRemove = false
                    vc.shouldPlay = false
                }
                else if let vc = navController.topViewController as? OnDemandViewController {
                    vc.videoPlayer?.pauseVideo()
                    vc.shouldPlayerRemove = false
                    vc.shouldPlay = false
                }
                revealViewController().revealToggle(animated: true)
                let controller = RatingPopUpVC(nibName: "RatingPopUpVC", bundle: nil)
                controller.modalPresentationStyle = .overCurrentContext
                controller.modalTransitionStyle = .crossDissolve
                let presentedController = navController.topViewController
                controller.modalPresentationCapturesStatusBarAppearance = true
                presentedController?.present(controller, animated: true, completion: nil)
            default:
                break
            }
        }
    }
}
