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

class HoldCoinCell: UITableViewCell
{
    
    @IBOutlet weak var holdSymLabel: UILabel!
    @IBOutlet weak var holdNameLabel: UILabel!
    @IBOutlet weak var holdPriceLabel: UILabel!
    @IBOutlet weak var holdAmountLabel: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
}

class HoldingsView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var coins = [Coin]()
    var totalHoldings = 0.00
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalHoldingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getHoldCoins()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tallyTotals()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getHoldCoins() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Holdings")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for coin in result as! [NSManagedObject] {
                
                if let holdCoin = (coin.value(forKey: "holdCoinID") as! String?)
                {
                    
                    let jsonURL = "https://api.coinmarketcap.com/v1/ticker/\(holdCoin)/?convert=AUD"
                    let url = URL(string: jsonURL)
                    
                    URLSession.shared.dataTask(with: url!)
                    { [unowned self] (data, response, error) in
                        guard let data = data else { return }
                        do {
                            self.coins = try JSONDecoder().decode([Coin].self, from: data) + self.coins
                            DispatchQueue.main.async {
                                self.getAmounts()
                                self.tableView.reloadData()
                            }
                        } catch {
                            print("Error is : \n\(error)")
                        }
                    }.resume()
                }
            }
            
        } catch {
            
            print("Failed")
        }
        
    }
    
    func getAmounts() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Holdings")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for coin in result as! [NSManagedObject] {
               
                let holdCoin = (coin.value(forKey: "holdCoinID") as! String?)
                let coinAmount = (coin.value(forKey: "holdAmount") as! Int16)
                    
                for c in coins
                {
                    if (c.id == holdCoin)
                    {
                        c.holdings = coinAmount
                        c.priceConverted = Double(c.price)!
                        c.totalPrice = Double(c.holdings) * c.priceConverted
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        } catch {
            print("Failed")
        }
        
    }
    
    func tallyTotals()
    {
        for c in coins
        {
            totalHoldings = totalHoldings + c.totalPrice
        }
        
        totalHoldingLabel.text = "$" + String(format: "%0.2f%", totalHoldings)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "holdViewCell", for: indexPath) as! HoldCoinCell
        let coin = coins[indexPath.row]
        
        cell.holdSymLabel.text = coin.symbol
        cell.holdNameLabel.text = coin.name
        cell.holdPriceLabel.text = String(format:"%.2f", coin.totalPrice)
        cell.holdAmountLabel.text = String(coin.holdings)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "holdViewSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! CoinView
                let value = coins[indexPath.row]
                controller.coinID = value.id
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }

}
