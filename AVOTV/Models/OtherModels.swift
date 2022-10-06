//
//  OtherModels.swift
//  Taskanize
//
//  Created by Zeeshan Tariq on 27/06/2020.
//  Copyright © 2020 Zeeshan Tariq. All rights reserved.
//

import Foundation

struct CategoryModel: Codable {
    
    var Id : String?
    var CategoryName : String?
    var Channels: [ChannelModel] = [ChannelModel]()

    init() {
        Id = "-1"
        CategoryName = ""
        Channels = [ChannelModel]()
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let Id_Int = try? values.decode(Int.self, forKey: .Id)
        let Id_String = try? values.decode(String.self, forKey: .Id)
        Id = Id_String ?? Id_Int?.description
        
        CategoryName = try values.decode(String.self, forKey: .CategoryName)
        Channels = try values.decode([ChannelModel].self, forKey: .Channels)
    }
}

struct OnDemandCategoryModel: Codable {
    
    var Id : String?
    var CategoryName : String?
    var OnDemands: [VideoModel] = [VideoModel]()

    init() {
        Id = "-1"
        CategoryName = ""
        OnDemands = [VideoModel]()
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let Id_Int = try? values.decode(Int.self, forKey: .Id)
        let Id_String = try? values.decode(String.self, forKey: .Id)
        Id = Id_String ?? Id_Int?.description
        
        CategoryName = try values.decode(String.self, forKey: .CategoryName)
        OnDemands = try values.decode([VideoModel].self, forKey: .OnDemands)
    }
}


struct ChannelModel: Codable {
    let CategoryId : String?
    let CategoryName : String?
    let Description : String?
    let ChannelUrl : String?
    let Id : String?
    let ImageUrl : String?
    let Name : String?
//    let TimeZone : String?
    let TimeFrom : String?
    let TimeTo : String?
    let Views : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let Id_Int = try? values.decode(Int.self, forKey: .Id)
        let Id_String = try? values.decode(String.self, forKey: .Id)
        Id = Id_String ?? Id_Int?.description
        
        CategoryId = try values.decode(String.self, forKey: .CategoryId)
        CategoryName = try values.decode(String.self, forKey: .CategoryName)
        Description = try values.decode(String.self, forKey: .Description)
        ChannelUrl = try values.decode(String.self, forKey: .ChannelUrl)
        ImageUrl = try values.decode(String.self, forKey: .ImageUrl)
        Name = try values.decode(String.self, forKey: .Name)
//        TimeZone = try values.decode(String.self, forKey: .TimeZone)
        TimeFrom = try values.decode(String.self, forKey: .TimeFrom)
        TimeTo = try values.decode(String.self, forKey: .TimeTo)
        Views = try values.decode(String.self, forKey: .Views)
    }
}

struct VideoModel: Codable {
    let Id : Int?
    let Name : String?
    let CategoryId : String?
    let CategoryName : String?
    let Description : String?
    let ImageUrl : String?
    let VideoUrl : String?
    let Views : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let Id_Int = try? values.decode(Int.self, forKey: .Id)
        let Id_String = try? values.decode(String.self, forKey: .Id)
        Id = Id_Int ?? Int(Id_String ?? "-1")
        
        CategoryId = try values.decode(String.self, forKey: .CategoryId)
        CategoryName = try values.decode(String.self, forKey: .CategoryName)
        Description = try values.decode(String.self, forKey: .Description)
        ImageUrl = try values.decode(String.self, forKey: .ImageUrl)
        VideoUrl = try values.decode(String.self, forKey: .VideoUrl)
        Name = try? values.decode(String.self, forKey: .Name) 
        Views = try values.decode(String.self, forKey: .Views)
    }
}

struct Device: Codable {
    var Id: String?
    var City: String?
    var Country: String?
    var DeviceName: String?
    var DeviceType: DeviceType?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let Id_Int = try? values.decode(Int.self, forKey: .Id)
        let Id_String = try? values.decode(String.self, forKey: .Id)
        Id = Id_String ?? Id_Int?.description
        
        City = try values.decode(String.self, forKey: .City)
        Country = try values.decode(String.self, forKey: .Country)
        DeviceName = try values.decode(String.self, forKey: .DeviceName)
        let deviceType = try values.decode(String.self, forKey: .DeviceType)
        DeviceType = AVOTV.DeviceType(rawValue: deviceType)
    }
}

struct ContactUS: Codable {
    var Id: Int?
    var Email: String?
    var Facebook: String?
    var Instagram: String?
    var Youtube: String?
    var Address: String?
}

struct NotificationModel: Codable {
    var by_user_id: Int?
    var created, created_on_d, created_on_t, job_name, message, id, task_id, task_status : String?
    
    enum CodingKeys: String, CodingKey {
        case by_user_id, created, created_on_d, created_on_t, job_name, message, id, task_id, task_status
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let byUserId_String = try? values.decode(String.self, forKey: .by_user_id)
        let byUserId_Int = try? values.decode(Int.self, forKey: .by_user_id)
        by_user_id = byUserId_Int ?? Int(byUserId_String ?? "-1")
        
        created = try values.decode(String.self, forKey: .created)
        created_on_d = try values.decode(String.self, forKey: .created_on_d)
        created_on_t = try values.decode(String.self, forKey: .created_on_t)
        job_name = try values.decode(String.self, forKey: .job_name)
        message = try values.decode(String.self, forKey: .message)
        id = try values.decode(String.self, forKey: .id)
        task_id = try values.decode(String.self, forKey: .task_id)
        task_status = try values.decode(String.self, forKey: .task_status)
    }
}
