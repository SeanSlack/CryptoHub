//
//  SearchView.swift
//  CryptoHub
//
//  Created by Sean on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
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

class SearchView: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var coins = [Coin]()
    var coinSearchResults:Array<Coin>?
    
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
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Symbol", "Name"]
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
        if searchText == "" {
            getCoinData()
        }
        else {
            if searchBar.selectedScopeButtonIndex == 0 {
                coins = coins.filter({ (Coin) -> Bool in
                    return Coin.symbol.lowercased().contains(searchText.lowercased())
                })
            }
            else {
                coins = coins.filter({ (Coin) -> Bool in
                    return Coin.name.lowercased().contains(searchText.lowercased())
                })
            }
            
        }
        self.tableView.reloadData()
        
    }
    

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "CoinView") as! CoinView
        
        DvC.coinSymbol = coins[indexPath.row].symbol
        self.navigationController?.pushViewController(DvC, animated: true)
    }
}
