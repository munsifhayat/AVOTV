
import Foundation


class AppStateManager: NSObject {
    
    let defaults = UserDefaults.standard
    
    static let shared = AppStateManager()
    
    var profileData: ProfileModel?
    
    var notifBarButton: UIBarButtonItem = UIBarButtonItem()
    
    private override init() {
        
        super.init()
    }
    
    var loggedInUser: LoginUserData?{
        
        set{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                defaults.set(encoded, forKey: "SavedUser")
                defaults.synchronize()
            }
        }
        
        get{
            if let savedUser = defaults.object(forKey: "SavedUser") as? Data {
                let decoder = JSONDecoder()
                if let loadedUser = try? decoder.decode(LoginUserData.self, from: savedUser) {
                    return loadedUser
                }
            }
            return nil
        }
    }
    
    
    var isUserLoggedIn:Bool{
        
        set{
            defaults.set(newValue, forKey: "isSignIn")
            defaults.synchronize()
        }
        
        get{
            return defaults.bool(forKey: "isSignIn")
        }
    }
    
    var authToken:String{
        set{
            defaults.set(newValue, forKey: "authToken")
            defaults.synchronize()
        }
        
        get{
            return defaults.string(forKey: "authToken") ?? ""
        }
    }
    
    
//    func getUserId()-> String{
//        if let id = loggedInUser?.id{
//            return id
//        }
//        return "-1"
//    }
    
    var fcmToken:String?{
        
        set{
            defaults.set(newValue, forKey: "fcmToken")
            defaults.synchronize()
        }
        
        get{
            return defaults.string(forKey: "fcmToken")
        }
    }
    
    var recentlyWatchedList: CategoryModel?{
        
        set{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                defaults.set(encoded, forKey: "recent_Channels")
                defaults.synchronize()
            }
        }
        
        get{
            if let savedChannels = defaults.object(forKey: "recent_Channels") as? Data {
                let decoder = JSONDecoder()
                if let loadedChannels = try? decoder.decode(CategoryModel.self, from: savedChannels) {
                    return loadedChannels
                }
            }
            return nil
        }
    }
    
  
    
    
    func markUserLogout(){
        removeUser()
        defaults.set(false, forKey: "isSignIn")
        defaults.removeObject(forKey: "AuthToken")
//        defaults.removeObject(forKey: "fcmToken")
        defaults.synchronize()
        Constants.APP_DELEGATE.loadLogInController()
    }
    
    
    func removeUser() {
        defaults.removeObject(forKey: "SavedUser")
    }
    
}

