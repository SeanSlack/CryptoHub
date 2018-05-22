//
//  Coins.swift
//  CryptoHub
//
//  Created by Sean on 20/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Foundation

public class Coin: Decodable {
    
    var id: String = ""
    var rank: String = ""
    var symbol : String = ""
    var name : String = ""
    var price : String = ""
    var dayChange: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case id, rank, symbol, name, price = "price_aud", dayChange = "percent_change_24h"
    }
    
}
