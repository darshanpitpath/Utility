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
