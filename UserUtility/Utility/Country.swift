//
//  Country.swift
//  UserUtility
//
//  Created by IPS on 14/10/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import Foundation

struct Country : Codable{
    
    let dialcode, name, code:String
    
    enum CodingKeys: String, CodingKey {
          case dialcode = "dial_code"
          case code
          case name
      }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.dialcode = try values.decodeIfPresent(String.self, forKey: .dialcode) ?? ""
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.code = try values.decodeIfPresent(String.self, forKey: .code) ?? ""
    }
}
