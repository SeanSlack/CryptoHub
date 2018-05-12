//
//  Coin.swift
//  CryptoHub
//
//  Created by Sean on 12/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import Foundation

class Coin: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "rank", symbol, name, priceUSD = "price_usd"
    }
    var id: String
    var symbol : String
    var name : String
    var priceUSD : String

}
