//
//  ShoppingAPI.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 2/7/24.
//

import Foundation

enum ShoppingAPI {
    case search(text: String, start: Int)
    
    var baseURL: String {
        return "https://openapi.naver.com/v1/"
    }
    
    var endpoint: URL {
        switch self {
        case .search:
            return URL(string: baseURL + "search/shop")!
        }
    }
}
