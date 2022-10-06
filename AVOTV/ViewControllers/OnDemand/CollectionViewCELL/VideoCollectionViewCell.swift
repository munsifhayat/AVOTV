//
//  VideoCollectionViewCell.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 15/06/2021.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var playImagView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func cellForCollectionView(_ collectioView: UICollectionView, atIndexPath indexPath: IndexPath) -> VideoCollectionViewCell {
        let identifier = "VideoCollectionViewCell"
        collectioView.register(UINib(nibName:"VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        let cell = collectioView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! VideoCollectionViewCell
        return cell
    }
    
    func setData(title: String) {
        
    }

}
