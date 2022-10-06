//
//  CategoryCollectionViewCell.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 15/06/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func cellForCollectionView(_ collectioView: UICollectionView, atIndexPath indexPath: IndexPath) -> CategoryCollectionViewCell {
        let identifier = "CategoryCollectionViewCell"
        collectioView.register(UINib(nibName:"CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        let cell = collectioView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCollectionViewCell
        return cell
    }
    
    func setData(title: String) {
        
    }
}
