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
    
    func callRequestBySim2(text: String, start: Int) async throws -> Shopping {
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
            URLQueryItem(name: "start", value: "\(start)"),
            URLQueryItem(name: "sort", value: "sim")
        ]
        
        guard let composedURL = components.url else {
            throw SeSACError.invalidData
        }
        
        var url = URLRequest(url: composedURL)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let (data, response) = try await URLSession.shared.data(for: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SeSACError.failedRequest
        }
        
        let shopping = try JSONDecoder().decode(Shopping.self, from: data)
        return shopping
    }

    func callRequestByDate2(text: String, start: Int) async throws -> Shopping {
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
            URLQueryItem(name: "start", value: "\(start)"),
            URLQueryItem(name: "sort", value: "date")
        ]
        
        guard let composedURL = components.url else {
            throw SeSACError.invalidData
        }
        
        var url = URLRequest(url: composedURL)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let (data, response) = try await URLSession.shared.data(for: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SeSACError.failedRequest
        }
        
        let shopping = try JSONDecoder().decode(Shopping.self, from: data)
        return shopping
    }

    
    func callRequestByAsc2(text: String, start: Int) async throws -> Shopping {
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
            URLQueryItem(name: "start", value: "\(start)"),
            URLQueryItem(name: "sort", value: "asc")
        ]
        
        guard let composedURL = components.url else {
            throw SeSACError.invalidData
        }
        
        var url = URLRequest(url: composedURL)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let (data, response) = try await URLSession.shared.data(for: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SeSACError.failedRequest
        }
        
        let shopping = try JSONDecoder().decode(Shopping.self, from: data)
        return shopping
    }

    
    func callRequestByDsc2(text: String, start: Int) async throws -> Shopping {
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
            URLQueryItem(name: "start", value: "\(start)"),
            URLQueryItem(name: "sort", value: "dsc")
        ]
        
        guard let composedURL = components.url else {
            throw SeSACError.invalidData
        }
        
        var url = URLRequest(url: composedURL)
        url.httpMethod = "GET"
        url.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let (data, response) = try await URLSession.shared.data(for: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SeSACError.failedRequest
        }
        
        let shopping = try JSONDecoder().decode(Shopping.self, from: data)
        return shopping
    }

}
