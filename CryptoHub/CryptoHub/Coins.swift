//
//  Coins.swift
//  CryptoHub
//
//  Created by Sean on 20/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Foundation

//This class is used throughout each screen, to allocate coinmarketcap's api data to relevent attributes. The addition of holdings, price converted and totalPrice are used within the holdings menu to calculate total portfolio value.
public class Coin: Decodable {
    
    var id: String = ""
    var rank: String = ""
    var symbol : String = ""
    var name : String = ""
    var price : String = ""
    var dayChange: String = ""
    var holdings: Int16 = 0
    var priceConverted : Double = 0
    var totalPrice : Double = 0
    
    private enum CodingKeys: String, CodingKey {
        case id, rank, symbol, name, price = "price_aud", dayChange = "percent_change_24h"
    }
    
}
