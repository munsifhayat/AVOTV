//
//  UserModel.swift
//  Taskanize
//
//  Created by Apple on 05/08/2019.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import Foundation
import UIKit

struct UserModel: Codable {
    
    let email: String?
    let dateofbirth : String?
    let gender : String?
    let name : String?
    let token : String?
    
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case dateofbirth = "dateofbirth"
        case gender = "gender"
        case name = "name"
        case token = "token"
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let dob = try? values.decode(String.self, forKey: .dateofbirth)
//        dateofbirth = dob ?? ""
//        let genderVal  = try? values.decode(String.self, forKey: .gender)
//        gender = genderVal ?? ""
//        
//        name = try values.decode(String.self, forKey: .name)
//        token = try values.decode(String.self, forKey: .token)
//    }
//    
    
}


struct ProfileModel: Codable {

    let active : String?
    let banned : String?
    let created_on : String?
    let deleted : String?
    let display_name : String?
    let display_on_dashboard : String?
    let email : String?
    let firstname : String?
    let id : String?
    let last_ip : String?
    let lastLogin : String?
    let lastname : String?
    let mobile_country_code : String?
    let mobile_iso2 : String?
    let mobile_number : String?
    let modified_on : String?
    let password_hash : String?
    let profile_pic : String?
    let reset_hash : String?
    let role_id : String?
    let role_name : String?
    let username : String?

}
