//
//  ShoppingAPISessionManager.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 2/7/24.
//

import Foundation

enum SeSACError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    case networkError(Error)
    case decodingError(Error)
}

class ShoppingAPISessionManager {
    static let shared = ShoppingAPISessionManager()
    
    private init() { }
    
    typealias CompletionHandler = (Shopping?, SeSACError?) -> Void
    
    func callRequestBySim2(text: String, start: Int, completionHandler: @escaping CompletionHandler) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let scheme = "https"
        let host = "openapi.naver.com"
        let path = "/v1/search/shop"
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "30"),
            URLQueryItem(name: "start", value: "\(start)"),
            URLQueryItem(name: "sort", value: "sim")
        ]
        
        var url = URLRequest(url: ShoppingAPI.search(text: text, start: start).endpoint)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(nil, .networkError(error))
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Shopping.self, from: data)
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, .decodingError(error))
                }
            }
        }.resume()
    }
}
