//
//  SearchView.swift
//  CryptoHub
//
//  Created by Sean on 2/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import Foundation

class CoinCell: UITableViewCell
{
    

    @IBOutlet weak var rankLabel: UILabel!
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
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    func getCoinList() {
        let jsonURL = "https://api.coinmarketcap.com/v1/ticker/?convert=AUD"
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
        getCoinList()
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
        cell.rankLabel.text = coin.rank
        cell.symLabel.text = coin.symbol
        cell.nameLabel.text = coin.name
        cell.priceLabel.text = coin.price
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coinViewSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! CoinView
                let value = coins[indexPath.row]
                controller.coinID = value.id
            }
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            getCoinList()
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
    


}
