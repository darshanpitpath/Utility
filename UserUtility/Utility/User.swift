//
//  User.swift
//  Live
//
//  Created by ITPATH on 4/5/18.
//  Copyright © 2018 ITPATH. All rights reserved.
//

import UIKit


let kUserDefault = UserDefaults.standard
let kUserDetail = "UserDetail"

struct ParentUser :Codable {
   var accessToken,countrycode,email,image,name,phone:String
    var id:Int
    
    enum CodingKeys:String, CodingKey {
        case id
        case accessToken = "access_token"
        case countrycode = "country_code"
        case email
        case image
        case name
        case phone
    }
    init(from decoder:Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken) ?? ""
        self.countrycode = try values.decodeIfPresent(String.self, forKey: .countrycode) ?? ""
        self.email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.phone = try values.decodeIfPresent(String.self, forKey: .phone) ?? ""
    }
}
extension ParentUser{
    
    static var isUserLoggedIn:Bool{
        if let userDetail  = kUserDefault.value(forKey: kUserDetail) as? Data{
            return self.isValiduserDetail(data: userDetail)
        }else{
          return false
        }
    }
    func setuserDetailToUserDefault(){
        do{
            let userDetail = try JSONEncoder().encode(self)
            kUserDefault.setValue(userDetail, forKey:kUserDetail)
            kUserDefault.synchronize()
        }catch{
            DispatchQueue.main.async {
                ShowToast.show(toatMessage: kCommonError)
            }
        }
    }
    static func isValiduserDetail(data:Data)->Bool{
        do {
            let _ = try JSONDecoder().decode(User.self, from: data)
            return true
        }catch{
            return false
        }
    }
    static func getUserFromUserDefault() -> User?{
        if let userDetail = kUserDefault.value(forKey: kUserDetail) as? Data{
            do {
                let user:User = try JSONDecoder().decode(User.self, from: userDetail)
                return user
            }catch{
                DispatchQueue.main.async {
                    ShowToast.show(toatMessage: kCommonError)
                }
                return nil
            }
        }
        DispatchQueue.main.async {
            //ShowToast.show(toatMessage: kCommonError)
        }
        return nil
    }
    static func removeUserFromUserDefault(){
        kUserDefault.removeObject(forKey:kUserDetail)
    }
    
}

class User: NSObject,Codable {
    
    var userDriverId: String = ""
    var userDriverName: String = ""
    var userAPIToken: String = ""
    var userPusher: String = ""
  
    
    init(userDetail:[String:Any]){
        super.init()
       
        if let driverID = userDetail["driver_id"]{
           self.userDriverId = "\(driverID)"
        }
        if let driver_name = userDetail["driver_name"]{
            self.userDriverName = "\(driver_name)"
        }
        if let api_token = userDetail["api_token"]{
            self.userAPIToken = "\(api_token)"
        }
        if let pusher_push_interest = userDetail["pusher_push_interest"]{
            self.userPusher = "\(pusher_push_interest)"
        }
       
    }
}
extension User{
    
    static var isUserLoggedIn:Bool{
        if let userDetail  = kUserDefault.value(forKey: kUserDetail) as? Data{
            return self.isValiduserDetail(data: userDetail)
        }else{
          return false
        }
    }
    func setuserDetailToUserDefault(){
        do{
            let userDetail = try JSONEncoder().encode(self)
            kUserDefault.setValue(userDetail, forKey:kUserDetail)
            kUserDefault.synchronize()
        }catch{
            DispatchQueue.main.async {
                ShowToast.show(toatMessage: kCommonError)
            }
        }
    }
    static func isValiduserDetail(data:Data)->Bool{
        do {
            let _ = try JSONDecoder().decode(User.self, from: data)
            return true
        }catch{
            return false
        }
    }
    static func getUserFromUserDefault() -> User?{
        if let userDetail = kUserDefault.value(forKey: kUserDetail) as? Data{
            do {
                let user:User = try JSONDecoder().decode(User.self, from: userDetail)
                return user
            }catch{
                DispatchQueue.main.async {
                    ShowToast.show(toatMessage: kCommonError)
                }
                return nil
            }
        }
        DispatchQueue.main.async {
            //ShowToast.show(toatMessage: kCommonError)
        }
        return nil
    }
    static func removeUserFromUserDefault(){
        kUserDefault.removeObject(forKey:kUserDetail)
    }
    
}
