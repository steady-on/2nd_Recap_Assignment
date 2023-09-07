//
//  QueryResult.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/07.
//

import Foundation

struct QueryResult: Codable {
    let total, start: Int
    let items: [Item]
}

struct Item: Codable {
    let productID: String
    let title: String
    let mallName: String
    let priceString: String
    let link: String
    let image: String
    let priceInt: Int
    let isInWishList: Bool = false

    enum CodingKeys: String, CodingKey {
        case title, link, image, mallName
        case productID = "productId"
        case priceString = "lprice"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        title = try container.decode(String.self, forKey: .title)
        link = try container.decode(String.self, forKey: .link)
        image = try container.decode(String.self, forKey: .image)
        mallName = try container.decode(String.self, forKey: .mallName)
        productID = try container.decode(String.self, forKey: .productID)
        
        let lprice = try container.decode(String.self, forKey: .priceString)
        priceInt = Int(lprice) ?? 0
        priceString = numberFormatter.string(for: priceInt) ?? "0"
    }
}