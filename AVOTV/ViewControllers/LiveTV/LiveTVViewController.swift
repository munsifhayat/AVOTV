//
//  LiveTVViewController.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 14/06/2021.
//

import UIKit

class LiveTVViewController: BaseViewController {

    @IBOutlet weak var videoPlayer: AVOVideoPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var currentDayTimeLabel: UILabel!
    @IBOutlet weak var timeProgressView: UIProgressView!
    @IBOutlet weak var timeProgressIndicatorView: UIView!
    @IBOutlet weak var timeProgressIndicatorViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var channelTableView: UITableView!
    @IBOutlet weak var timeView: UIView!

    var channelCounter = 1
    
    var channelsDataList = [CategoryModel]()
    
    var selectedChannelIndexPath: IndexPath!
    
    var isFirstLoad = true
    
    var shouldPlay = true
    var shouldPlayerRemove = true
        
    private var clockTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColorNavBar(color: UIColor(named: "primary_white")!, navBgColor: UIColor.black, title: "")
        addMenuButtonToNavBar(color: UIColor(named: "primary_white")!)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        channelTableView.delegate = self
        channelTableView.dataSource = self
        
        titleLabel.text = ""
        startTimeLabel.text = ""
        currentDayTimeLabel.text = ""
        descriptionLabel.text = ""
        viewsCountLabel.text = ""
        timeView.isHidden = true
        
        selectedChannelIndexPath = IndexPath(row: -1, section: -1)
        
        getAllChannelsAPICall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        shouldPlayerRemove = true
        if isFirstLoad {
            isFirstLoad = false
            videoPlayerSetup()
        }
        else if shouldPlay {
//            videoPlayer.playVideo()
        }
        
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if shouldPlayerRemove {
//            videoPlayer.dismissVideo()
            videoPlayer.removeFromSuperview()
        }
        else {
            videoPlayer.pauseVideo()
        }
        
        clockTimer?.invalidate()
        clockTimer = nil
    }
    
    func videoPlayerSetup() {
        videoPlayer.isLiveStream = true
        //        videoPlayer.videoLink = "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v"
        videoPlayer.ownerViewController = self
        
        videoPlayer.didTapRewindButton = { [weak self] in
            
            if let weakSelf = self {
                weakSelf.updateSelectedIndexPath(isForward: false)
                
                weakSelf.setSelectedChannelData()
                
                weakSelf.channelTableView.reloadData()
            }
        }
        
        videoPlayer.didTapForwardButton = { [weak self] in
            
            if let weakSelf = self {
                weakSelf.updateSelectedIndexPath(isForward: true)
                
                weakSelf.setSelectedChannelData()
                
                weakSelf.channelTableView.reloadData()
            }
        }
        
        videoPlayer.didTapInfoButton = { [weak self] in
            
            if let weakSelf = self {
                Utility.showAlert(title: "Channel's Info", message: weakSelf.channelsDataList[weakSelf.selectedChannelIndexPath.section].Channels[weakSelf.selectedChannelIndexPath.row].Description ?? "")
            }
        }
        
        videoPlayer.didVideoInFullScreen = { [weak self] in
            
            if let weakSelf = self {
                weakSelf.shouldPlayerRemove = false
                weakSelf.shouldPlay = false
            }
        }
        
        videoPlayer.didPassed1Minute = { [weak self] in
            
            if let weakSelf = self {
                weakSelf.updateViewCountAPICall(channelId: weakSelf.channelsDataList[weakSelf.selectedChannelIndexPath.section].Channels[weakSelf.selectedChannelIndexPath.row].Id ?? "-1")
            }
        }
    }
    
    
    func isEnableForwardButton()->Bool {
        if selectedChannelIndexPath.section != channelsDataList.count-1 {
            return true
        }
        else {
            return selectedChannelIndexPath.row < channelsDataList[selectedChannelIndexPath.section].Channels.count-1
        }
        
    }
    
    func isEnableRewindButton()->Bool {
        if selectedChannelIndexPath.section > 0 {
            return true
        }
        else {
            if selectedChannelIndexPath.row == channelsDataList[selectedChannelIndexPath.section].Channels.count-1 {
                return false
            }
            else {
                return true
            }
        }
    }
    
    func updateSelectedIndexPath(isForward:Bool) {
        if isForward {
            if selectedChannelIndexPath.row < channelsDataList[selectedChannelIndexPath.section].Channels.count-1 {
                selectedChannelIndexPath.row += 1
            }
            else {
                if selectedChannelIndexPath.section < channelsDataList.count-1 {
                    selectedChannelIndexPath.section += 1
                    if channelsDataList[selectedChannelIndexPath.section].Channels.count > 0 {
                        selectedChannelIndexPath.row = 0
                    }
                    else {
                        updateSelectedIndexPath(isForward: true)
                    }
                }
            }
        }
        else {
            if selectedChannelIndexPath.section <= channelsDataList.count-1 {
                if selectedChannelIndexPath.row > 0 {
                    selectedChannelIndexPath.row -= 1
                }
                else {
                    selectedChannelIndexPath.section -= 1
                    selectedChannelIndexPath.row = channelsDataList[selectedChannelIndexPath.section].Channels.count-1
                }
            }
        }
    }
    
    func setSelectedChannelData() {
        videoPlayer.videoLink = channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row].ChannelUrl ?? ""

        videoPlayer.enableRewindButton(isEnable: isEnableRewindButton())
        videoPlayer.enableForwardButton(isEnable: isEnableForwardButton())
        
        titleLabel.text = channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row].Name ?? ""
        ///startTimeLabel.text = "\(getCurrentDayName())   \(channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row].TimeFrom ?? "") - \(channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row].TimeTo ?? "") "
        setTimeFrame()
        ///currentDayTimeLabel.text = channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row].TimeZone ?? ""
        setCurrentDayTime()
        descriptionLabel.text = channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row].Description ?? ""
        viewsCountLabel.text = "\(channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row].Views ?? "0") Views"
        
//        updateViewCountAPICall(channelId: channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row].Id ?? "-1")
        
        updateRrecentlyWatchedList(channel: channelsDataList[selectedChannelIndexPath.section].Channels[selectedChannelIndexPath.row])
        
        channelCounter = 1
    }
    
    func startTimer() {
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        setCurrentDayTime()
        setTimeFrame()
    }
    
    func setCurrentDayTime() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayInWeek = dateFormatter.string(from: date)
        
        let timeString = Utility.getFormattedDateString(date, format: "hh:mm a")
        currentDayTimeLabel.text = "\(dayInWeek) \(timeString)"
    }
    
    func setTimeFrame() {
        var startTime = ""
        var endTime = ""
        
        let dateComponents = NSCalendar.current.dateComponents([.minute], from: Date())
        
        let minutes = dateComponents.minute ?? 30
        if minutes > 30 {
            let minuteDiff = minutes - 30
            let earlyDate = Calendar.current.date(byAdding: .minute, value: -minuteDiff, to: Date()) ?? Date()
            startTime = Utility.getFormattedDateString(earlyDate, format: "hh:mm a")
            
            let afterDate = Calendar.current.date(byAdding: .minute, value: 30, to: earlyDate) ?? Date()
            endTime = Utility.getFormattedDateString(afterDate, format: "hh:mm a")
            
            let progress:Float = Float(minutes - 30) / 30.0
            timeProgressView.progress = progress
            
            timeProgressIndicatorViewXConstraint.constant = (timeProgressView.frame.width * CGFloat(progress)) - 3
        }
        else {
            let earlyDate = Calendar.current.date(byAdding: .minute, value: -minutes, to: Date()) ?? Date()
            startTime = Utility.getFormattedDateString(earlyDate, format: "hh:mm a")
            
            let afterDate = Calendar.current.date(byAdding: .minute, value: 30, to: earlyDate) ?? Date()
            endTime = Utility.getFormattedDateString(afterDate, format: "hh:mm a")
            
            let progress:Float = Float(minutes) / 30.0
            timeProgressView.progress = progress
            
            timeProgressIndicatorViewXConstraint.constant = (timeProgressView.frame.width * CGFloat(progress)) - 3
        }
        
        startTimeLabel.text = startTime
        endTimeLabel.text = endTime
    }
    
    func updateRrecentlyWatchedList(channel: ChannelModel) {
        if var recentlyWatchedList = AppStateManager.shared.recentlyWatchedList {
            for obj in recentlyWatchedList.Channels {
                if channel.Id == obj.Id {
                    return
                }
            }
            if recentlyWatchedList.Channels.count == 3 {
                recentlyWatchedList.Channels.remove(at: 2)
            }
            
            recentlyWatchedList.Channels.insert(channel, at: 0)
            AppStateManager.shared.recentlyWatchedList = recentlyWatchedList
        }
        else {
            var recentlyWatchedList = CategoryModel()
            recentlyWatchedList.CategoryName = "Recently Watched"
            recentlyWatchedList.Channels.append(channel)
            AppStateManager.shared.recentlyWatchedList = recentlyWatchedList
        }
    }
    
}


// MARK: - TableView Delegate
extension LiveTVViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        selectedChannelIndexPath = indexPath
        DispatchQueue.main.async {
            self.setSelectedChannelData()
            tableView.reloadData()
        }
        
    }
}

// MARK: - TableView DataSource
extension LiveTVViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return channelsDataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelsDataList[section].Channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChannelTableViewCell.cellForTableView(tableView, atIndexPath: indexPath)
       
        let channelData = channelsDataList[indexPath.section].Channels[indexPath.row]
        cell.nameLabel.text = channelData.Name ?? ""
        cell.playingStatusImageView.image = #imageLiteral(resourceName: "play")
        cell.noLabel.text = channelData.Id ?? ""//"- 00\(channelCounter)"
        cell.channelImageView.setImage(url: channelData.ImageUrl ?? "", placeholder: #imageLiteral(resourceName: "splash"))
        if indexPath == selectedChannelIndexPath {
            cell.playingStatusImageView.image = #imageLiteral(resourceName: "now_playing")
        }
//        channelCounter += 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 11, y: 0, width: tableView.frame.width, height: 40)
        titleLabel.backgroundColor = .clear
        view.addSubview(titleLabel)
        view.backgroundColor = .clear///UIColor(named: "nav_color")!
        view.backgroundColor = self.view.backgroundColor

        titleLabel.text = channelsDataList[section].CategoryName ?? ""  //"MORE ENTERTAINMENT CHANNELS"

        if let font = UIFont(name: "MADETOMMY-Medium", size: 17) {
            titleLabel.font = font
        }
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(named: "secondary_white")!

        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let titleLabel = UILabel()
        let yAxis = (tableView.frame.height / 2 ) - 65
        titleLabel.frame = CGRect.init(x: 4.0, y: yAxis, width: tableView.frame.width - 30, height: 50.0)
        view.addSubview(titleLabel)
        view.backgroundColor = .clear

        titleLabel.text = "No channel(s) yet!"

        if let font = UIFont(name: "MADETOMMY-Medium", size: 17){
            titleLabel.font = font
        }
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(named: "primary_white")!

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return channelsDataList.count == 0 ? tableView.frame.height - 40 : 0
    }
    
}


// Web API's Calling

extension LiveTVViewController{
    
    func getAllChannelsAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(GetChannelsResponse.self, from: jsonData)
                
                if let code = decodable.code {
                    if code == "200", decodable.status == "true" {
                        if let channels = decodable.data {
                            self.channelsDataList = channels
                            
                            if let recentlyWatchedList = AppStateManager.shared.recentlyWatchedList {
                                self.channelsDataList.insert(recentlyWatchedList, at: 0)
                            }
                            
                            if channels.count > 0, channels[0].Channels.count > 0 {
                                self.selectedChannelIndexPath = IndexPath(row: 0, section: 0)
                                
                                self.timeView.isHidden = false

                                self.setSelectedChannelData()
                                
                                self.view.layoutIfNeeded()
                            }
                            
                            self.channelTableView.reloadData()
                            self.startTimer()
                        }
                    }
                    else{
                        Utility.showAlert(title: "Alert", message: decodable.message ?? "Something went wrong, please try again later.")
                    }
                }
                
            }  catch {
                Utility.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
        
        let failureBlock:DefaultAPIFailureClosure = { error in
            self.stopLoading()
            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        let url = Route.get_AllChannels.url()
        
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
    
    func updateViewCountAPICall(channelId: String){
        
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
        
        let url = Route.update_ChannelViewCount.url()
        
        let fcmToken = AppStateManager.shared.fcmToken ?? "fcmToken"
        
        let params = ["ChannelId":channelId,
                      "FCMToken": fcmToken] as [String : Any]
        
        APIHandler.instance.postRequest(route: url, parameters: params, success: successBlock, failure: failureBlock, errorPopup: true)
    }
}


