
import UIKit
import Alamofire

import UIKit

protocol APIErrorHandler {
    func handleErrorFromResponse(response: Dictionary<String,AnyObject>)
    func handleErrorFromError(error:NSError)
}

class APIHandler: NSObject {
    static let instance = APIHandler()
    internal var apiManager = APIManagerBase()
    
    private override init() { super.init() }
}

//MARK: - Error Handler
extension APIHandler {
    func getErrorMessage(_ result: Dictionary<String,AnyObject>) -> String {
        var message = "Unexpected error"
        if let m = result["Message"] as? String {
            message = m
        }
        if let r = result["Result"] as? NSDictionary {
            if let m = r["ErrorMessage"] as? String {
                message = m
            }
        }
        return message
    }
}

//MARK: - All APIs
extension APIHandler {
    
    
    func postRequest(route: String?, parameters: Parameters?, success:@escaping DefaultAPISuccessClosure, failure:@escaping DefaultAPIFailureClosure, errorPopup: Bool){
        
        //Cancel all other requests
        apiManager.stopAllrequests()
        
        if let route = URL(string: route ?? ""){
            apiManager.postRequestWith(route: route, params: parameters!, success: success, failure: failure, errorPopup: errorPopup)
        }
    }
    
    func postRequestWithMultipart(route: String?, parameters: Parameters?, success:@escaping DefaultAPISuccessClosure, failure:@escaping DefaultAPIFailureClosure, errorPopup: Bool){
        
        //Cancel all other requests
        apiManager.stopAllrequests()
        
        if let route = URL(string: route ?? ""){
            apiManager.postRequestWithMultipart(route: route, params: parameters!, success: success, failure: failure, errorPopup: errorPopup)
        }
    }
    
    
    func getRequest(route: String?, parameters: Parameters?, success:@escaping DefaultAPISuccessClosure, failure:@escaping DefaultAPIFailureClosure, errorPopup: Bool){
        
        //Cancel all other requests
        apiManager.stopAllrequests()
        
        if let route = route {
            apiManager.getRequestWith(route: route, parameters: parameters!, success: success, failure: failure, errorPopup: errorPopup)
        }
    }
    
    func getStringRequest(route: String?, parameters: Parameters?, success:@escaping DefaultAPIStringSuccessClosure, failure:@escaping DefaultAPIFailureClosure, errorPopup: Bool){
        
        //Cancel all other requests
        apiManager.stopAllrequests()
        
        if let route = route {
            apiManager.getStringRequestWith(route: route, parameters: parameters!, success: success, failure: failure, errorPopup: errorPopup)
        }
    }
    
}

