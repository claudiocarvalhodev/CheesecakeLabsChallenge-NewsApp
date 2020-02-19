//
//  SortArticleService.swift
//  News
//
//  Created by claudiocarvalho on 07/01/20.
//  Copyright © 2020 claudiocarvalho. All rights reserved.
//

import Foundation
import UIKit

class SortArticleService {
    
    static func sortedByTitleAscending(articles: [RealmArticleModel]) -> [RealmArticleModel] {
        return articles.sorted(by: { (a:RealmArticleModel, b:RealmArticleModel) -> Bool in
            guard let aTitle = a.title, let bTitle = b.title else { return true }
            return aTitle < bTitle
        })
    }
    
    static func sortedByWebsiteAscending(articles: [RealmArticleModel]) -> [RealmArticleModel] {
        return articles.sorted(by: { (a:RealmArticleModel, b:RealmArticleModel) -> Bool in
            guard let aWebsite = a.website, let bWebsite = b.website else { return true }
            return aWebsite < bWebsite
        })
    }
    
    static func sortedByAuthorsAscending(articles: [RealmArticleModel]) -> [RealmArticleModel] {
        return articles.sorted(by: { (a:RealmArticleModel, b:RealmArticleModel) -> Bool in
            guard let aAuthor = a.author, let bAuthor = b.author else { return true }
            return aAuthor < bAuthor
        })
    }

    static func sortedByDateDescending (articles: [RealmArticleModel]) -> [RealmArticleModel] {
        return articles.sorted(by: { (a:RealmArticleModel?, b:RealmArticleModel?) -> Bool in
            guard let aDate = a?.date, let bDate = b?.date else { return true }
            return aDate < bDate
        })
    }
    
}
