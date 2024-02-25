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
}

class ShoppingAPISessionManager {
    static let shared = ShoppingAPISessionManager()
    
    private init() { }
    
    typealias CompletionHandler = (Shopping?, SeSACError?) -> Void
    
    func callRequestBySim2(text: String, start: Int, completionHandler: @escaping CompletionHandler) {
        let query = text
        
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
          //  URLQueryItem(name: "start", value: "\(start)"),
        //    URLQueryItem(name: "sort", value: "sim")
        ]
        print("guard let composedURL = components.url else 이전")
        guard let composedURL = components.url else {
            completionHandler(nil, .invalidData)
            print("guard let composedURL = components.url else 실행")
            return
        }
        
        print("Composed URL: \(composedURL)")

        print("guard let composedURL = components.url else 이후")
        
        var url = URLRequest(url: composedURL)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("URLSession.shared.dataTask 이내")
            
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("통신 실패")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("통신은 성공했지만, 데이터가 안 옴")
                    completionHandler(nil, .noData)
                    return
                }
//                
//                print(String(data: data, encoding: .utf8))
//                
                guard let response = response as? HTTPURLResponse else {
                    print("응답값이 오지 않음")
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("통신은 성공했지만, 올바른 값이 오지 않은 상태")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Shopping.self, from: data)
                    completionHandler(result, nil)
                } catch {
                    print(error)
                    completionHandler(nil, SeSACError.invalidData)
                }
            }
            print("디스패치큐 이후")
            
        }.resume()
        print("리쥼 이후")
    }
    
    func callRequestByDate2(text: String, start: Int, completionHandler: @escaping CompletionHandler) {
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
            URLQueryItem(name: "sort", value: "date")
        ]
        
        var url = URLRequest(url: ShoppingAPI.search(text: text, start: start).endpoint)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("통신 실패")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("통신은 성공했지만, 데이터가 안 옴")
                    completionHandler(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("응답값이 오지 않음")
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("통신은 성공했지만, 올바른 값이 오지 않은 상태")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Shopping.self, from: data)
                    completionHandler(result, nil)
                } catch {
                    print(error)
                    completionHandler(nil, SeSACError.invalidData)
                }
            }
        }.resume()
    }
    
    func callRequestByAsc2(text: String, start: Int, completionHandler: @escaping CompletionHandler) {
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
            URLQueryItem(name: "sort", value: "asc")
        ]
        
        var url = URLRequest(url: ShoppingAPI.search(text: text, start: start).endpoint)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("========")
            DispatchQueue.main.async {
                guard error == nil else {
                    print("통신 실패")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("통신은 성공했지만, 데이터가 안 옴")
                    completionHandler(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("응답값이 오지 않음")
                    completionHandler(nil, .invalidResponse)
                    return
                }
                print("HTTP Status Code: \(response.statusCode)")
                
                guard response.statusCode == 200 else {
                    print("통신은 성공했지만, 올바른 값이 오지 않은 상태")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Shopping.self, from: data)
                    completionHandler(result, nil)
                } catch {
                    print(error)
                    completionHandler(nil, SeSACError.invalidData)
                }
                print("Received Data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
        
    }
    
    func callRequestByDsc2(text: String, start: Int, completionHandler: @escaping CompletionHandler) {
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
            URLQueryItem(name: "sort", value: "dsc")
        ]
        
        var url = URLRequest(url: ShoppingAPI.search(text: text, start: start).endpoint)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("통신 실패")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("통신은 성공했지만, 데이터가 안 옴")
                    completionHandler(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("응답값이 오지 않음")
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("통신은 성공했지만, 올바른 값이 오지 않은 상태")
                    completionHandler(nil, .failedRequest)
                    return
                }
               
                
                do {
                    let result = try JSONDecoder().decode(Shopping.self, from: data)
                    completionHandler(result, nil)
                } catch {
                    print(error)
                    completionHandler(nil, SeSACError.invalidData)
                }
                
            }
            
        }.resume()
        
    }
}
