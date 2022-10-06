//
//  OnDemandCollectionViewCell.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 18/01/2022.
//

import UIKit

class OnDemandCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewsCounterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func cellForCollectionView(_ collectioView: UICollectionView, atIndexPath indexPath: IndexPath) -> OnDemandCollectionViewCell {
        let identifier = "OnDemandCollectionViewCell"
        collectioView.register(UINib(nibName:"OnDemandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        let cell = collectioView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OnDemandCollectionViewCell
        return cell
    }

}
