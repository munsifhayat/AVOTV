//
//  ChannelTableViewCell.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 15/06/2021.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var playingStatusImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func cellForTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> ChannelTableViewCell {
        let identifier = "ChannelTableViewCell"
        tableView.register(UINib(nibName:"ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChannelTableViewCell
        return cell
    }
    
    func setData(){
        
    }
    
}


