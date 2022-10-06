

enum Route: String {

    case register_token = "register_token"
    
    case login = "login"
    
    case signup = "register"
    
    case logout = "logout"

    case forgetPassword = "forget_password"
    
    case update_Password = "users/ForgotPassword/UpdatePassword"
    
    case update_Profile = "profile/update"
    
    case get_ActiveDevices = "active/devices"
    
    case deviceLogout = "active/devices/logout"
        
    case get_Categories = "category/getall"
    
    case get_AllChannels = "channels/getall"
    
    case update_ChannelViewCount = "channels/update_view_count"
    
    case get_OnDemandVideos = "ondemand/getall"
    
    case update_VideoViewCount = "ondemand/update_view_count"

    case get_ChannelById = "channels/ByCategoryId"
    
    case privayPolicy = "pages/privacy_policy"
    
    case termsCondition = "pages/terms_of_service"
    
    case aboutUS = "pages/about"
    
    case ContactUS = "contactus"
    
        
    func url() -> String{
        return Constants.baseURL + self.rawValue
    }
}
