//
//  OnDemandViewController.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 15/06/2021.
//

import UIKit

class OnDemandViewController: BaseViewController {
    
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var videoPlayer: AVOVideoPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var videosList = [VideoModel]()
    
    var playingIndex = -1
    
    var isFirstLoad = true
    
    var shouldPlayerRemove = true
    var shouldPlay = true

    override func viewDidLoad() {
        super.viewDidLoad()

        setupColorNavBar(color: UIColor(named: "primary_white")!, navBgColor: UIColor.black, title: "On Demand")
        addBackButtonToNavBar(color: UIColor(named: "primary_white")!)
        
        title = "On Demand Videos"
        
        videoCollectionView.delegate  = self
        videoCollectionView.dataSource = self
        
        titleLabel.text = ""
        descriptionLabel.text = ""
        viewsCountLabel.text = ""
        
//        getAllChannelsAPICall()
        
        if videosList.count > 0 {
            
            self.updateViewCountAPICall(videoId: videosList[playingIndex].Id ?? -1)
            
            self.videoPlayer.videoLink = videosList[playingIndex].VideoUrl ?? ""
            self.videoPlayer.enableRewindButton(isEnable: false)
            self.videoPlayer.enableForwardButton(isEnable: self.playingIndex != self.videosList.count-1)
            
            self.titleLabel.text = self.videosList[self.playingIndex].Name ?? ""
            self.descriptionLabel.text = self.videosList[self.playingIndex].Description ?? ""
            self.viewsCountLabel.text = "\(self.videosList[self.playingIndex].Views ?? "0") Views"
        }
        
        videoCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        shouldPlayerRemove = true
        if isFirstLoad {
            isFirstLoad = false
            videoPlayerSetup()
        }
        else if shouldPlay {
            videoPlayer.playVideo()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if shouldPlayerRemove {
            videoPlayer.removeFromSuperview()
        }
        else {
            videoPlayer.pauseVideo()
        }
    }
    
    func videoPlayerSetup() {
//        videoPlayer.videoLink = "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v"
        videoPlayer.ownerViewController = self
        
        videoPlayer.didTapRewindButton = {
            self.playingIndex -= 1
            
            self.updateViewCountAPICall(videoId: self.videosList[self.playingIndex].Id ?? -1)
            
            self.videoPlayer.enableRewindButton(isEnable: self.playingIndex > 0)
            self.videoPlayer.enableForwardButton(isEnable: self.playingIndex != self.videosList.count-1)
            self.videoPlayer.videoLink = self.videosList[self.playingIndex].VideoUrl ?? ""
            self.titleLabel.text = self.videosList[self.playingIndex].Name ?? ""
            self.descriptionLabel.text = self.videosList[self.playingIndex].Description ?? ""
            self.viewsCountLabel.text = "\(self.videosList[self.playingIndex].Views ?? "0") Views"

            self.videoCollectionView.reloadData()
        }
        
        videoPlayer.didTapForwardButton = {
            self.playingIndex += 1
            
            self.updateViewCountAPICall(videoId: self.videosList[self.playingIndex].Id ?? -1)
            
            self.videoPlayer.enableRewindButton(isEnable: self.playingIndex > 0)
            self.videoPlayer.enableForwardButton(isEnable: self.playingIndex != self.videosList.count-1)
            self.videoPlayer.videoLink = self.videosList[self.playingIndex].VideoUrl ?? ""
            self.titleLabel.text = self.videosList[self.playingIndex].Name ?? ""
            self.descriptionLabel.text = self.videosList[self.playingIndex].Description ?? ""
            self.viewsCountLabel.text = "\(self.videosList[self.playingIndex].Views ?? "0") Views"
            
            self.videoCollectionView.reloadData()
        }
        
        videoPlayer.didTapInfoButton = {
            Utility.showAlert(title: "Video's Info", message: self.videosList[self.playingIndex].Description ?? "")
        }
        
        videoPlayer.didVideoInFullScreen = {
            self.shouldPlayerRemove = false
            self.shouldPlay = false
        }
        
        videoPlayer.didPassed1Minute = {
            
        }
    }
    
}


// MARK: - CollectionView Delegate & DataSource
extension OnDemandViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = VideoCollectionViewCell.cellForCollectionView(collectionView, atIndexPath: indexPath)
        cell.playImagView.image = #imageLiteral(resourceName: "play_video")
        cell.videoThumbnail.setImage(url: videosList[indexPath.row].ImageUrl ?? "", placeholder: #imageLiteral(resourceName: "logoSP"))
        if playingIndex == indexPath.row {
            cell.playImagView.image = #imageLiteral(resourceName: "pause")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCells:CGFloat = 3.0
        let width = videoCollectionView.frame.size.width / noOfCells - 7
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playingIndex = indexPath.row
        
        updateViewCountAPICall(videoId: videosList[playingIndex].Id ?? -1)
        
        videoPlayer.enableRewindButton(isEnable: playingIndex > 0)
        videoPlayer.enableForwardButton(isEnable: playingIndex != videosList.count-1)
        videoPlayer.videoLink = videosList[playingIndex].VideoUrl ?? ""
        titleLabel.text = videosList[playingIndex].Name ?? ""
        descriptionLabel.text = videosList[playingIndex].Description ?? ""
        viewsCountLabel.text = "\(videosList[playingIndex].Views ?? "0") Views"
        collectionView.reloadData()
    }
    
}


// Web API's Calling

extension OnDemandViewController {
    
//    func getAllChannelsAPICall(){
//
//        startLoading()
//
//        let successBlock:DefaultAPISuccessClosure = { response in
//            self.stopLoading()
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                let decodable = try JSONDecoder().decode(GetVideosResponse.self, from: jsonData)
//
//                if let code = decodable.code{
//                    if code == 200{
//                        if let videos = decodable.data{
//                            self.videosList = videos
//
//                            if videos.count > 0 {
//                                self.playingIndex = 0
//
//                                self.updateViewCountAPICall(videoId: videos[0].Id ?? -1)
//
//                                self.videoPlayer.videoLink = videos[0].VideoUrl ?? ""
//                                self.videoPlayer.enableRewindButton(isEnable: false)
//                                self.videoPlayer.enableForwardButton(isEnable: self.playingIndex != self.videosList.count-1)
//
//                                self.titleLabel.text = self.videosList[self.playingIndex].Name ?? ""
//                                self.descriptionLabel.text = self.videosList[self.playingIndex].Description ?? ""
//                                self.viewsCountLabel.text = "\(self.videosList[self.playingIndex].Views ?? 0) Views"
//                            }
//
//                            self.videoCollectionView.reloadData()
//                        }
//                    }
//                    else{
//                        Utility.showAlert(title: "Alert", message: decodable.message ?? "Something went wrong, please try again later.")
//                    }
//                }
//
//            }  catch {
//                Utility.showAlert(title: "Error", message: error.localizedDescription)
//            }
//
//        }
//
//        let failureBlock:DefaultAPIFailureClosure = { error in
//            self.stopLoading()
//            Utility.showAlert(title: "Error", message: error.localizedDescription)
//        }
//
//        let url = Route.get_OnDemandVideos.url()
//
//        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
//    }
    
    func updateViewCountAPICall(videoId:Int){
        
//        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
//            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(BasicResponse.self, from: jsonData)
                
                if let code = decodable.code {
                    if code == "200" {
                    }
                }
            }  catch {
//                Utility.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
        
        let failureBlock:DefaultAPIFailureClosure = { error in
//            self.stopLoading()
//            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        let url = Route.update_VideoViewCount.url()
        
        let fcmToken = AppStateManager.shared.fcmToken ?? "fcmToken"
        
        let params = ["VideoId":videoId,
                      "FCMToken": fcmToken] as [String : Any]
        
        APIHandler.instance.postRequest(route: url, parameters: params, success: successBlock, failure: failureBlock, errorPopup: true)
    }
}
