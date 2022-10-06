//
//  OnDemandTableViewCell.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 18/01/2022.
//

import UIKit

class OnDemandTableViewCell: UITableViewCell {

    var didTapVideo: ((_ selectedIndex:Int)->())?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var videosList = [VideoModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func cellForTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) -> OnDemandTableViewCell {
        let identifier = "OnDemandTableViewCell"
        tableView.register(UINib(nibName:"OnDemandTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OnDemandTableViewCell
        return cell
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 150, height: 170)
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 20
//        layout.minimumLineSpacing = 20
//        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
    }
    
}

// MARK: - Collection Delegate & DataSource
extension OnDemandTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = OnDemandCollectionViewCell.cellForCollectionView(collectionView, atIndexPath: indexPath)
        cell.videoThumbnail.clipsToBounds = true
        cell.videoThumbnail.layer.cornerRadius = 7
        cell.videoThumbnail.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        cell.videoThumbnail.setImage(url: videosList[indexPath.row].ImageUrl ?? "", placeholder: #imageLiteral(resourceName: "logo"))
        cell.descriptionLabel.text = videosList[indexPath.row].Description ?? ""
        cell.viewsCounterLabel.text = "\(videosList[indexPath.row].Views ?? "0")"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapVideo?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 170)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
