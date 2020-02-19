//
//  FetchData.swift
//  News
//
//  Created by claudiocarvalho on 07/01/20.
//  Copyright © 2020 claudiocarvalho. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class FetchData {
    static func get <T: Object> (type: T.Type, success:@escaping () -> Void, fail:@escaping (_ error:NSError)->Void)->Void where T:Mappable {
        
        let url = URL(string: "https://cheesecakelabs.com/challenge/")!
        Alamofire.request(url, method: .get).responseArray { (response: DataResponse<[RealmArticleModel]>) in
            switch response.result {
            case .success:
                do {
                    guard let listResult = response.result.value else{
                        return
                    }
                    let realm = try Realm()
                    try realm.write {
                        for item in listResult {
                            realm.add(item, update: .all)
                        }
                    }
                } catch let error as NSError {
                    print(Strings.ErrorData)
                    print(error.localizedDescription)
                    fail(error)
                }
                success()
            case .failure(let error as NSError):
                print(Strings.ErrorResponse)
                print(error.localizedDescription)
                fail(error)
            }
        }
    }
}
