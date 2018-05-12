//
//  SearchView.swift
//  CryptoHub
//
//  Created by Sean on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Foundation

struct Coin: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "rank", symbol, name, priceUSD = "price_usd"
    }
    let id: String
    let symbol : String
    let name : String
    let priceUSD : String
}

class CoinCell: UITableViewCell
{
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var symLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}

class SearchView: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var coins = [Coin]()
    
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    func getCoinData() {
        let jsonURL = "https://api.coinmarketcap.com/v1/ticker/"
        let url = URL(string: jsonURL)
        
        URLSession.shared.dataTask(with: url!) { [unowned self] (data, response, error) in
            guard let data = data else { return }
            do {
                self.coins = try JSONDecoder().decode([Coin].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch {
                print("Error is : \n\(error)")
            }
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        getCoinData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! CoinCell
        
        let coin = coins[indexPath.row]
        cell.idLabel.text = coin.id
        cell.symLabel.text = coin.symbol
        cell.nameLabel.text = coin.name
        cell.priceLabel.text = coin.priceUSD
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        coins = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }

}
