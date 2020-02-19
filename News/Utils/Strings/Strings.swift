//
//  Strings.swift
//  News
//
//  Created by claudiocarvalho on 08/01/20.
//  Copyright © 2020 claudiocarvalho. All rights reserved.
//

import Foundation

import Localize_Swift

struct Strings {
    
    // MARK: - Titles
    
    static let News = "News".localized()
    static let Details = "Details".localized()


    // MARK: -  Error messages

    static let ErrorNetwork = "No network connection".localized()
    static let ErrorNotEnoughData = "The api did not provide any data".localized()
    static let ErrorAPI = "The api is not working".localized()
    static let ErrorClient = "The request is not valid".localized()
    static let ErrorData = "The api sent invalid data".localized()
    static let ErrorResponse = "The api sent invalid response".localized()
}
