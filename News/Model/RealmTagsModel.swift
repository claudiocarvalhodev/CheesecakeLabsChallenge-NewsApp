//
//  RealmTagsModel.swift
//  News
//
//  Created by claudiocarvalho on 07/01/20.
//  Copyright © 2020 claudiocarvalho. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import ObjectMapperAdditions

class RealmTagsModel: Object, Mappable {
    @objc dynamic var id: Int = 0
    @objc dynamic var category: String?

    required convenience init?(map: Map) {
        self.init()
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    func mapping(map: Map) {
        id            <- map["id"]
        category      <- map["label"]
    }
}
