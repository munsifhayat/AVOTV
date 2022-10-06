//
//  DeviceTableViewCell.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 12/06/2021.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!

    var didLogoutPressed:(()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func cellForTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> DeviceTableViewCell {
        let identifier = "DeviceTableViewCell"
        tableView.register(UINib(nibName:"DeviceTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DeviceTableViewCell
        return cell
    }
    
    func setData(){
        
    }
    
    @IBAction func didTapSignoutButton(_ sender: UIButton) {
        didLogoutPressed?()
    }
}
