//
//  CoinModelDetail.swift
//  CryptoApp
//
//  Created by Lam  on 19/08/2022.
//

import Foundation

struct CoinModelDetail: Codable{
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, links, description
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hasing_algorithm"
    }
    
    var readableDescription: String? {
        return description?.en?.removingHTMLOccurances
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

struct Description: Codable {
    let en: String?
}
