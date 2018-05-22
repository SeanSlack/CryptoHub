//
//  ViewController.swift
//  CryptoHub
//
//  Created by Sean on 23/4/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class FavCoinCell: UITableViewCell
{
    
    @IBOutlet weak var favRankLabel: UILabel!
    @IBOutlet weak var favSymLabel: UILabel!
    @IBOutlet weak var favNameLabel: UILabel!
    @IBOutlet weak var favPriceLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
}

class FavoritesView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var coins = [Coin]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getFavoriteCoins()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFavoriteCoins() {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")

        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for coin in result as! [NSManagedObject] {
                
                let favCoin = (coin.value(forKey: "saveCoinID") as! String)
                print(coin.value(forKey: "saveCoinID") as! String)
                
                let jsonURL = "https://api.coinmarketcap.com/v1/ticker/\(favCoin)/?convert=AUD"
                let url = URL(string: jsonURL)
                
                URLSession.shared.dataTask(with: url!) { [unowned self] (data, response, error) in
                    guard let data = data else { return }
                    do {
                        self.coins = try JSONDecoder().decode([Coin].self, from: data) + self.coins
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch {
                        print("Error is : \n\(error)")
                    }
                    }.resume()
                
            }

        } catch {

            print("Failed")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favViewCell", for: indexPath) as! FavCoinCell
        
        let coin = coins[indexPath.row]
        cell.favRankLabel.text = coin.rank
        cell.favSymLabel.text = coin.symbol
        cell.favNameLabel.text = coin.name
        cell.favPriceLabel.text = coin.price
        
        return cell
    }
 
    override var prefersStatusBarHidden: Bool
    {
            return true
    }

}

