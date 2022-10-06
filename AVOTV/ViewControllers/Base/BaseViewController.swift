
import UIKit
import NVActivityIndicatorView


class BaseViewController: UIViewController {
    
    var leftBarButtonItem : UIBarButtonItem?
    
    var rightBarButtonItem : UIBarButtonItem?

    var isSideMenuOpen = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        navigationController?.navigationBar.isHidden = true
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .left{
            if isSideMenuOpen{
                revealViewController().revealToggle(animated: true)
                isSideMenuOpen = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Update status bar style
        self.setNeedsStatusBarAppearanceUpdate()
        
        navigationItem.setHidesBackButton(true, animated: false)        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Update status bar style
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

  
extension BaseViewController {
    
    func setupColorNavBar(color: UIColor? = .white, navBgColor: UIColor? =  .white, title: String = "", isShowBorder:Bool = false, isRoundCorners: Bool = false){
        
        navigationController?.navigationBar.isHidden = false
        
        if let font = UIFont(name: "MADETOMMY-Medium", size: 21){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color!, NSAttributedString.Key.font:font]
            self.navigationController?.navigationBar.barStyle = color == .black ? .black : .default
        }
        
        navigationController?.navigationBar.isTranslucent = false
        
        if !isShowBorder{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
        else{
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationController?.navigationBar.backgroundColor = .clear
        }

        navigationController?.navigationBar.barTintColor = navBgColor
        
        if title != ""{
        navigationController?.navigationBar.topItem?.title = title
        }
        
    }
    
    func setupColorNavBarWithProfilePicture(color: UIColor? = .white, navBgColor: UIColor? =  .white,name : String, profileUrl : String){
        
        setupColorNavBar(color: color, navBgColor: navBgColor)
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: -4, width: 200, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 2, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setImage(url: profileUrl, placeholder: #imageLiteral(resourceName: "profile_placeholder"))
        imageView.cornerRadius = 20
        
        imageView.addTapGesture()
    
        let nameLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 150, height: 40))
        nameLabel.text = name.description
//        let font = FontName.ralewayMedium.relativeFont(withSize: 17.0)
//        nameLabel.font = font
        nameLabel.textColor = UIColor.white
        logoContainer.addSubview(nameLabel)
        logoContainer.addSubview(imageView)
        
        self.navigationItem.titleView = logoContainer
        
    }
    

    func setupTransparentNavBar(textColor: UIColor? = .white, title: String = ""){
         navigationController?.navigationBar.isHidden = false
        
//        if let font = UIFont(name: "Poppins-Medium", size: 17){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:textColor!]
            self.navigationController?.navigationBar.barStyle = .default
//        }
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = title
    }
    
    func setupTransparentNavBarWithLine(textColor: UIColor? = .black, title: String = ""){
        navigationController?.navigationBar.isHidden = false
        
        if let font = UIFont(name: "Poppins-Medium", size: 17){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:textColor!]
            self.navigationController?.navigationBar.barStyle = .default
        }
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.topItem?.title = title
    }
    
}

extension BaseViewController {
    
    func addBackButtonToNavBar(color: UIColor? = .white, backImage:UIImage? = #imageLiteral(resourceName: "back")){
        self.leftBarButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
        self.navigationItem.leftBarButtonItem?.tintColor = color

    }
    
    
    func addMenuButtonToNavBar(color: UIColor? = .white){
        self.leftBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "drawer_menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(toggleMenu))
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
        self.navigationItem.leftBarButtonItem?.tintColor = color
    }
    
    func addLogoutButtonToNavBar(color: UIColor? = .white, title:String = "LOGOUT"){
        self.rightBarButtonItem =  UIBarButtonItem(title:title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(doLogout))
        if let font = UIFont(name: "MADETOMMY-Medium", size: 14){
        self.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem?.tintColor = color
    }
    
    func addNotificationAddButtons(color: UIColor? = .white){
        
        let btnSearch = UIButton.init(type: .custom)
        btnSearch.setImage(#imageLiteral(resourceName: "plus-symbol"), for: .normal)
//        btnSearch.addTarget(self, action: #selector(doAdd), for: .touchUpInside)
        
        let btnEdit = UIButton.init(type: .custom)
        btnEdit.setImage(#imageLiteral(resourceName: "notification"), for: .normal)
//        btnEdit.addTarget(self, action: #selector(doNotification), for: .touchUpInside)
        
        let stackview = UIStackView.init(arrangedSubviews: [btnEdit, btnSearch])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 9
        
        let rightBarButton = UIBarButtonItem(customView: stackview)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.navigationItem.rightBarButtonItem?.tintColor = color
    }
    
}

extension BaseViewController {
    
    @objc func toggleMenu(){
        revealViewController().revealToggle(animated: true)
        isSideMenuOpen = !isSideMenuOpen
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func doLogout() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.logoutAPICall()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
        }))
        
        alert.modalPresentationCapturesStatusBarAppearance = true
        self.present(alert, animated: true)
    }
    
    @objc func logoutAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            
            self.stopLoading()
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let decodable = try JSONDecoder().decode(BasicResponse.self, from: jsonData)
                
                if let code = decodable.code {
                    if code == "200" {
                        AppStateManager.shared.markUserLogout()
                    }
                    else {
                        Utility.showAlert(title: "Error!", message: decodable.message ?? "Something went wrong, please try again later.")
                    }
                }
                
            }  catch {
                Utility.showAlert(title: "Error!", message: "Something went wrong, please try again later.")
            }
            
        }
        
        let failureBlock:DefaultAPIFailureClosure = { error in
            self.stopLoading()
            Utility.showAlert(title: "Error!", message: error.localizedDescription)
        }
        
        let url = Route.logout.url()
        
//        let token = AppStateManager.shared.fcmToken ?? "fcmToken"
        
//        let params = ["token" : token] as [String : Any]
        
//        print(params)
        
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
}
   

extension UIViewController: NVActivityIndicatorViewable {
    
    func startLoading(){
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
//        startAnimating(size, message: "Loading", type: NVActivityIndicatorType.ballSpinFadeLoader, color: Constants.dark_theme_color, textColor: Constants.dark_theme_color)
    }
    
    func stopLoading(){
        stopAnimating()
    }
}
