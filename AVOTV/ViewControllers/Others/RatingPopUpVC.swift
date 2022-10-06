//
//  PopUpVC.swift
//  Taskanize
//
//  Created by Zeeshan Tariq on 29/07/2020.
//  Copyright © 2020 Zeeshan Tariq. All rights reserved.
//

import UIKit
import Cosmos

protocol popUpwithSearchDelegate: class {
   
}

class RatingPopUpVC: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var ratigView: CosmosView!
    
    weak var delegate: popUpwithSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func didTapSubmit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension RatingPopUpVC: UISearchBarDelegate{
    
    
}
