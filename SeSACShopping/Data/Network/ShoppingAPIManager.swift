//
//  ShoppingAPIManager.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/23/24.
//

import UIKit
import Alamofire

class ShoppingAPIManager {
    // 한 공간에서 계속 꺼내서 사용할 수 있도록 타입 프로퍼티를 만들어줌
    static let shared = ShoppingAPIManager()
    
    // 초기화 구문 바깥에서 쓰지 못하게 처리
    private init() { }
    
    let headers: HTTPHeaders = [
        "X-Naver-Client-Id": APIKey.clientID,
        "X-Naver-Client-Secret": APIKey.clientSecret
    ]
    
    let baseURL = "https://openapi.naver.com/v1/search/"
    
    func callRequestBySim(text: String, start: Int, completionHandler: @escaping (Shopping) -> Void) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        let url = baseURL + "shop?query=\(query)&display=30&start=\(start)&sort=sim"

        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let success):
                    completionHandler(success)
                    
            case .failure(let failure):
                    print(failure)
            }
        }
    }
    
    func callRequestByDate(text: String, start: Int, completionHandler: @escaping (Shopping) -> Void) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        let url = baseURL + "shop?query=\(query)&display=30&start=\(start)&sort=date"

        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let success):
                    completionHandler(success)
                    
            case .failure(let failure):
                    print(failure)
            }
        }
    }
    
    func callRequestByAsc(text: String, start: Int, completionHandler: @escaping (Shopping) -> Void) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        let url = baseURL + "shop?query=\(query)&display=30&start=\(start)&sort=asc"

        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let success):
                    completionHandler(success)
                    
            case .failure(let failure):
                    print(failure)
            }
        }
    }
    
    func callRequestByDsc(text: String, start: Int, completionHandler: @escaping (Shopping) -> Void) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        let url = baseURL + "shop?query=\(query)&display=30&start=\(start)&sort=dsc"

        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let success):
                    completionHandler(success)
                    
            case .failure(let failure):
                    print(failure)
            }
        }
    }
    
    
}
