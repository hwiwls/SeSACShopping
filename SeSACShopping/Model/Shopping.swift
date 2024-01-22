//
//  Shopping.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/21/24.
//

import Foundation

// MARK: - Shopping
struct Shopping: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    var items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, hprice, mallName, productID: String
    let productType, brand, maker, category1: String
    let category2, category3, category4: String

    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice, mallName
        case productID = "productId"
        case productType, brand, maker, category1, category2, category3, category4
    }
}
