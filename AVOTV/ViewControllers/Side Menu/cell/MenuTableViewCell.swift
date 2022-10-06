//
//  MenuTableViewCell.swift
//  InstructorHub
//
//  Created by Apple on 07/08/2019.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var switchBtn: UISwitch!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    static func cellForTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> MenuTableViewCell {
        let identifier = "MenuTableViewCell"
        tableView.register(UINib(nibName:"MenuTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MenuTableViewCell
        return cell
    }
    
}
