import UIKit
import Alamofire

typealias DefaultAPIFailureClosure = (NSError) -> Void
typealias DefaultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultAPIStringSuccessClosure = (String) -> Void
typealias DefaultBoolResultAPISuccesClosure = (Bool) -> Void

class APIManagerBase: NSObject {
    
    var alamoFireManager : Session!
    let defaultRequestHeader = ["Content-Type" : "application/x-www-form-urlencoded"]
    let otherRequestHeader = ["Authorization": "bearer"]
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(Constants.apiRequestTimeoutInterval)
        configuration.timeoutIntervalForResource = TimeInterval(Constants.apiRequestTimeoutInterval)
        alamoFireManager = Alamofire.Session(configuration: configuration)
    }
}

extension APIManagerBase {
    
    func getHeaders () -> Dictionary<String,String> {
        return ["Content-Type" : "application/json"]
    }
    
    func getAuthorizationHeader () -> HTTPHeaders {
        
        if AppStateManager.shared.isUserLoggedIn {
            let token = AppStateManager.shared.authToken
            if token != "" {
                return ["Accept" : "application/json", "Authorization": token]
            }else{
                return ["Accept" : "application/json" ]
            }
        }
        else{
            return [ "Accept" : "application/json" ]
        }    
    }
    
    func getUrl(forRoute route: String, params:Parameters? = nil) -> URL? {
        if let components: NSURLComponents  = NSURLComponents(string: (Constants.baseURL+route)){
            if let params = params {
                var queryItems = [URLQueryItem]()
                for (key,value) in params {
                    queryItems.append(URLQueryItem(name:key,value: value as? String))
                }
                components.queryItems = queryItems
            }
            
            return components.url
        }
        return nil
    }
}

extension APIManagerBase {
    func showErrorMessage(error: Error){
        
        switch (error as NSError).code {
            
        // Ignore if request is Cancelled or badrequest
        case -999, 4:
            break
        case -1001:
            Utility.showAlert(title: Strings.error.localized, message: ErrorMessage.network.timeOut)
        case -1009:
            Utility.showAlert(title: Strings.error.localized, message: ErrorMessage.network.noNetwork)
        case -1005:
            Utility.showAlert(title: Strings.error.localized, message: ErrorMessage.network.noNetwork)
        default:
            Utility.showAlert(title: Strings.error.localized, message: (error as NSError).localizedDescription)
        }
    }
    
    func stopAllrequests(){
        self.alamoFireManager.session.getAllTasks { (tasks) in
            tasks.forEach { $0.cancel() }
        }
    }
}

extension APIManagerBase {
    
    func getRequestWith(route: String, parameters: Parameters,
                        success:@escaping DefaultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure,
                        errorPopup: Bool){
        print(route)
        if !(NetworkReachabilityManager.init(host: "www.apple.com")?.isReachable)! {
            
            print("internet not reachable")
            let error = NSError(domain: "no internet connection", code: 500, userInfo: nil)
            
            failure(error)
            return
        }
        
        AF.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON { response in
            
            print(response)
            switch response.result
            {
            case .success:
                //Success
                
                
                print(response.value as! Dictionary<String, AnyObject>)
                
                success(response.value as! Dictionary<String, AnyObject>)
                
                break
                
            case .failure(_):
                failure(response.error! as NSError)
                break
            }
        }
    }
    
    func getStringRequestWith(route: String, parameters: Parameters,
                        success:@escaping DefaultAPIStringSuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure,
                        errorPopup: Bool){
        print(route)
        if !(NetworkReachabilityManager.init(host: "www.apple.com")?.isReachable)! {
            
            print("internet not reachable")
            let error = NSError(domain: "no internet connection", code: 500, userInfo: nil)
            
            failure(error)
            return
        }
        
        AF.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON { response in
            
            print(response)
            switch response.result
            {
            case .success:
                //Success
                
                if let stringResp = response.value as? String {
                    print(response.value as! String)
                    
                    success(stringResp)
                }
                
                break
                
            case .failure(_):
                failure(response.error! as NSError)
                break
            }
        }
    }
    
    
    func postRequestWith(route: URL, params:Parameters, success:@escaping DefaultAPISuccessClosure, failure:@escaping DefaultAPIFailureClosure, errorPopup: Bool) {
        print(route)
        if !(NetworkReachabilityManager.init(host: "www.apple.com")?.isReachable)! {
            
            print("internet not reachable")
            let error = NSError(domain: "no internet connection", code: 500, userInfo: nil)
            
            failure(error)
            return
        }
        
        AF.request(route, method: .post, parameters: params,encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON { response in
            
            print(response)
            switch response.result
            {
            case .success:
                
                //Success
                if let responseData = response.value as? Dictionary<String, AnyObject>{
                    success(responseData)
                }
                if let rData = response.value as? NSString{
                    let data:Dictionary<String, AnyObject> = ["message":rData]
                    success(data)
                }
                
                break
            case .failure(_):
                failure(response.error! as NSError)
                break
            }
        }
    }
    
    
    func deleteRequestWith(route: URL, params:Parameters, success:@escaping DefaultAPISuccessClosure, failure:@escaping DefaultAPIFailureClosure, errorPopup: Bool) {
        
        if !(NetworkReachabilityManager.init(host: "www.apple.com")?.isReachable)! {
            
            print("internet not reachable")
            let error = NSError(domain: "no internet connection", code: 500, userInfo: nil)
            
            failure(error)
            return
        }
        print(getAuthorizationHeader())
        AF.request(route, method: .delete, parameters: params,encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON { response in
            
            switch response.result
            {
            case .success:
                
                //Success
                success(response.value as! Dictionary<String, AnyObject>)
                break
                
            case .failure(_):
                failure(response.error! as NSError)
                break
            }
        }
    }
    
    func putRequestWith(route: URL,params: Parameters,
                        success:@escaping DefaultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure,
                        errorPopup: Bool){
        
        if !(NetworkReachabilityManager.init(host: "www.apple.com")?.isReachable)! {
            
            print("internet not reachable")
            let error = NSError(domain: "no internet connection", code: 500, userInfo: nil)
            
            failure(error)
            return
        }
        
        AF.request(route, method: .put, parameters: params, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
            response in
            
            switch response.result
            {
            case .success:
                
                //Success
                success(response.value as! Dictionary<String, AnyObject>)
                break
                
            case .failure(_):
                failure(response.error! as NSError)
                break
            }
        }
    }
    
    
    func postRequestWithMultipart(route: URL,params: Parameters,
                                  success:@escaping DefaultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure,
                                  errorPopup: Bool)
    {
        
        if !(NetworkReachabilityManager.init(host: "www.apple.com")?.isReachable)! {
            
            print("internet not reachable")
            let error = NSError(domain: "no internet connection", code: 500, userInfo: nil)
            
            failure(error)
            return
        }
        
        let URLSTR = try! URLRequest(url: route.absoluteString, method: .post, headers: getAuthorizationHeader())
        
        AF.upload(multipartFormData: { multipart in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'_'HH-mm-ss"
            
            for (key , value) in params {
                
                if let data:Data = value as? Data {
                    let dateString = dateFormatter.string(from: Date())
                    let imageName = "\(key)_\(dateString).png"
                    multipart.append(data, withName: key, fileName: imageName, mimeType: "image/jpeg")
                }
                else{
                    multipart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, with: URLSTR).responseJSON(completionHandler: { response in
            
            switch response.result
            {
            case .success:
                
                //Success
                success(response.value as! Dictionary<String, AnyObject>)
                break
                
            case .failure(_):
                failure(response.error! as NSError)
                break
            }
        })
    }
}
