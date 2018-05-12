//
//  Coins.swift
//  CryptoHub
//
//  Created by Sean on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import Foundation

class Coins : Decodable {
    
    var id: String
    var sym: String
    var name: String
    var price: String
    
    init(id: String, sym: String, name: String, price: String) {
        self.id = id
        self.sym = sym
        self.name = name
        self.price = price
    }

    
}
