//
//  AccountViewController.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 12/06/2021.
//

import UIKit

class AccountViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var activeDevicesButton: UIButton!
    @IBOutlet weak var purchasesButton: UIButton!
    
    let controllers  = [ProfileViewController(nibName: "ProfileViewController", bundle: .main), DevicesViewController(), PurchasesViewController()]
//    var frame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorNavBar(color: UIColor(named: "primary_white")!, navBgColor: UIColor.black, title: "Account")
        addMenuButtonToNavBar(color: UIColor(named: "primary_white")!)
        addLogoutButtonToNavBar(color: UIColor(named: "secondary_white")!)
        
//        setupScreens()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        setupScreens()
    }
    
    override func viewDidLayoutSubviews() {
        setupScreens()
    }
    
    func setupScreens() {
        
        for index in 0..<controllers.count {
            
            var frame = CGRect.zero
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = CGSize(width: UIScreen.main.bounds.width, height: scrollView.frame.size.height)
            
            let controller = controllers[index]
            
            if index == 0, let profileController = controller as? ProfileViewController {
                profileController.didEditProfile = {
                    let vc = EditProfileViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            let view  =  controller.view
            view?.frame = frame
            self.scrollView.addSubview(view ?? UIView())
        }

        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(controllers.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
        
//        scrollView.layoutIfNeeded()
//        for family: String in UIFont.familyNames
//        {
//            print(family)
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
    }
    
    
    @IBAction func didTapTabButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            profileButton.setBackgroundImage(#imageLiteral(resourceName: "tab_active"), for: .normal)
            activeDevicesButton.setBackgroundImage(nil, for: .normal)
            purchasesButton.setBackgroundImage(nil, for: .normal)
            let contentOffSet = CGPoint(x: scrollView.frame.size.width * CGFloat(sender.tag), y: 0)
            scrollView.setContentOffset(contentOffSet, animated: true)
        case 1:
            profileButton.setBackgroundImage(nil, for: .normal)
            activeDevicesButton.setBackgroundImage(#imageLiteral(resourceName: "tab_active"), for: .normal)
            purchasesButton.setBackgroundImage(nil, for: .normal)
            let contentOffSet = CGPoint(x: scrollView.frame.size.width * CGFloat(sender.tag), y: 0)
            scrollView.setContentOffset(contentOffSet, animated: true)
        case 2:
            profileButton.setBackgroundImage(nil, for: .normal)
            activeDevicesButton.setBackgroundImage(nil, for: .normal)
            purchasesButton.setBackgroundImage(#imageLiteral(resourceName: "tab_active"), for: .normal)
            let contentOffSet = CGPoint(x: scrollView.frame.size.width * CGFloat(sender.tag), y: 0)
            scrollView.setContentOffset(contentOffSet, animated: true)
        default:
            break
        }
    }
    
}


extension AccountViewController: UIScrollViewDelegate  {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        
        switch Int(pageNumber) {
        case 0:
            profileButton.setBackgroundImage(#imageLiteral(resourceName: "tab_active"), for: .normal)
            activeDevicesButton.setBackgroundImage(nil, for: .normal)
            purchasesButton.setBackgroundImage(nil, for: .normal)
        case 1:
            profileButton.setBackgroundImage(nil, for: .normal)
            activeDevicesButton.setBackgroundImage(#imageLiteral(resourceName: "tab_active"), for: .normal)
            purchasesButton.setBackgroundImage(nil, for: .normal)
        case 2:
            profileButton.setBackgroundImage(nil, for: .normal)
            activeDevicesButton.setBackgroundImage(nil, for: .normal)
            purchasesButton.setBackgroundImage(#imageLiteral(resourceName: "tab_active"), for: .normal)
        default:
            break
        }
    }
}
