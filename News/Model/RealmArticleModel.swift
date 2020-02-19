//
//  RealmArticleModel.swift
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

class RealmArticleModel: Object, Mappable {
    @objc dynamic var title: String?
    @objc dynamic var website: String?
    @objc dynamic var author: String?
    @objc dynamic var date = Date(timeIntervalSince1970: 0)
    @objc dynamic var content: String?
    var tags = List<RealmTagsModel>()
    @objc dynamic var imageUrl: String?
    
    var acessoryType: UITableViewCell.AccessoryType?

    var readed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: self.hash.description)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.hash.description)
        }
    }

    required convenience init?(map: Map) {
        self.init()
    }

    override class func primaryKey() -> String? {
        return "title"
    }

    func mapping(map: Map) {
        title         <- map["title"]
        website       <- map["website"]
        author        <- map["authors"]
        date          <- (map["date"], DateTransform.custom)
        content       <- map["content"]
        tags          <- (map["tags"], ListTransform<RealmTagsModel>())
        imageUrl      <- map["image_url"]
    }
}
