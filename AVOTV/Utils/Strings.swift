//
//  Strings.swift
//  Locumotive
//
//  Created by zeeshantariq on 5/24/19.
//

import Foundation


enum Strings: String {
    
    case error = "Error"
    
    //MARK: - Error Messages
    case noNetwork = "Internet connection seems to be offline"
    case timeOut = "time_out"
    case errorOccured = "error_occured"
    case badRequest = "bad_request"
    case locationDenied = "location_denied"
    case locationDeniedMsg = "location_denied_msg"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}
