//
//  ErrorMessage.swift
//  Locumotive
//
//  Created by zeeshantariq on 5/24/19.
//

import Foundation


struct ErrorMessage {
    private init() {}
    
    static let network = NeworkAlerts()
}


struct NeworkAlerts {
    fileprivate init() {}
    
    var noNetwork: String {
        return Strings.noNetwork.localized
    }
    var timeOut: String {
        return Strings.timeOut.localized
    }
    var errorOccured: String {
        return Strings.errorOccured.localized
    }
    var badRequest: String {
        return Strings.badRequest.localized
    }
}
