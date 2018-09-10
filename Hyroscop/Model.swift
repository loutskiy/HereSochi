//
//  Model.swift
//  Hyroscop
//
//  Created by Mikhail Lutskiy on 01.09.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Model: Object, Mappable {
    @objc dynamic var id = ""
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}

