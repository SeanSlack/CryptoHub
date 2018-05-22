// To parse the JSON, add this file to your project and do:
//
//   let coinDictionary = try? JSONDecoder().decode(CoinDictionary.self, from: jsonData)
//
// To read values from URLs:
//
//   let task = URLSession.shared.coinDictionaryTask(with: url) { coinDictionary, response, error in
//     if let coinDictionary = coinDictionary {
//       ...
//     }
//   }
//   task.resume()

import Foundation

struct CoinDictionary: Codable {
    let data: [String: Datum]
}

struct Datum: Codable {
    let id: Int
    let name, symbol, websiteSlug: String
    let rank: Int
    let circulatingSupply, totalSupply: Double
    let maxSupply: Double?
    let quotes: [String: Quote]
    let lastUpdated: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case websiteSlug = "website_slug"
        case rank
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case quotes
        case lastUpdated = "last_updated"
    }
}

struct Quote: Codable {
    let price, volume24H, marketCap, percentChange1H: Double
    let percentChange24H: Double
    let percentChange7D: Double?
    
    enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume_24h"
        case marketCap = "market_cap"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func coinDictionaryTask(with url: URL, completionHandler: @escaping (CoinDictionary?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

