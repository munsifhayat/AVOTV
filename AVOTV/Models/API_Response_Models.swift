//
//  File.swift
//  Construction
//
//  Created by Apple on 11/10/2019.
//  Copyright © 2019 Zeeshan. All rights reserved.
//

import Foundation

struct BasicResponse: Codable {
    
    let code : String?
    let message : String?
    let status : String?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case status = "status"
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        code = try values.decodeIfPresent(Int.self, forKey: .code)
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        status = try values.decodeIfPresent(Bool.self, forKey: .status)
//    }
    
}

struct LoginResponse: Codable {
    
    let code : String?
    let data : UserModel?
    let message : String?
    let status : String?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data
        case message = "message"
        case status = "status"
    }
    
}


struct GetProfileResponse: Codable {
    let status : Int?
    let msg : String?
    let data : ProfileModel?
}

struct GetCategoriesResponse: Codable {
    
    let code : Int?
    let data : [CategoryModel]?
    let message : String?
    let status : Bool?
    
}


struct GetChannelsResponse: Codable {
    let code : String?
    let data : [CategoryModel]?
    let message : String?
    let status : String?
}

struct GetVideosResponse: Codable {
    let code : String?
    let data : [OnDemandCategoryModel]?
    let message : String?
    let status : String?
}

struct GetDevicesResponse: Codable {
    let code : String?
    let status : String?
    let message : String?
    let data : [Device]?
}

struct GetContactUsResponse: Codable {
    let code : String?
    let status : String?
    let message : String?
    let data : ContactUS?
}
