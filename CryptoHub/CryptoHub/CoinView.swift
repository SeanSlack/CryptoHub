//
//  CoinView.swift
//  CryptoHub
//
//  Created by Sean on 12/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CoinView: UIViewController, UITextFieldDelegate {

    //variables
    var coin = [Coin]()
    var inFavorites = false
    var inHoldings = false
    var coinID = String()
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var qtyTextField: UITextField!
    
    @IBOutlet weak var addFavButton: UIButton!
    @IBOutlet weak var removeFavButton: UIButton!
    
    @IBOutlet weak var removeHoldingsLabel: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCoinData()
        checkFavorites()
        checkHoldings()
    
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    @IBAction func addToHoldings(_ sender: Any) {
        
        inHoldings = false
        let strAmount = qtyTextField.text
        let coinAmount:Int16? = Int16(strAmount!)
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        qtyTextField.resignFirstResponder()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Holdings")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for coin in result as! [NSManagedObject] {
                
                let holdCoin = (coin.value(forKey: "holdCoinID") as! String?)
                let holdQuantity = (coin.value(forKey: "holdAmount") as! Int16?)
                
                //checks if exists already, if so adds to holdings
                if holdCoin == coinID {
                    print("coin exists in holdings")
                    coin.setValue(holdQuantity! + coinAmount! , forKey: "holdAmount")
                    checkHoldings()
                }
        
            }
            
        } catch {
            print("Failed")
        }
        
        if inHoldings == false
        {
            let entity = NSEntityDescription.entity(forEntityName: "Holdings", in: context)!
            let newHold = NSManagedObject(entity: entity, insertInto: context)
            
            newHold.setValue(coinID, forKey: "holdCoinID")
            newHold.setValue(coinAmount, forKey: "holdAmount")
            print("Coin did not exist, adding new entry")
            checkHoldings()
        }
        
        
        
        do {
            try context.save()
            messageLabel.text = "Saved \(strAmount ?? "") \(coinID) to holdings."
            qtyTextField.text = ""
        } catch {
            print("Failed saving")
        }
        
    }
    
    @IBAction func removeAll(_ sender: Any) {
            
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Holdings")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for coin in result as! [NSManagedObject] {
                
                let holdCoin = (coin.value(forKey: "holdCoinID") as! String?)
                
                if holdCoin == coinID {
                    context.delete(coin)
                    removeHoldingsLabel.isEnabled = false
                }
            }
            
        } catch {
            print("Failed")
        }
        
    }
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)!
        let newCoin = NSManagedObject(entity: entity, insertInto: context)
        
        newCoin.setValue(coinID, forKey: "favCoinID")
        
        do {
            try context.save()
            print("Saved \(coinID)")
            addFavButton.isEnabled = false
            removeFavButton.isEnabled = true
        } catch {
            print("Failed saving")
        }
        
    }
    @IBAction func removeFavorite(_ sender: Any) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for coin in result as! [NSManagedObject] {
                
                let favCoin = (coin.value(forKey: "favCoinID") as! String?)
                
                if favCoin == coinID {
                    context.delete(coin)
                    removeFavButton.isEnabled = false
                    addFavButton.isEnabled = true
                }
            }
            
        } catch {
            print("Failed")
        }
    }
    
    func checkHoldings() {
        inHoldings = false
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Holdings")
    
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for coin in result as! [NSManagedObject] {
                
                let holdCoin = (coin.value(forKey: "holdCoinID") as! String?)
                
                if holdCoin == coinID
                {
                    print("coin exists in holdings")
                    removeHoldingsLabel.isEnabled = true
                    inHoldings = true
                }
                
            }
            
        } catch {
            print("Failed")
        }
        if inHoldings == false
        {
            removeHoldingsLabel.isEnabled = false
        }
        
    }
    
    func checkFavorites() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for coin in result as! [NSManagedObject] {
                
                let favCoin = (coin.value(forKey: "favCoinID") as! String?)
                
                if favCoin == coinID {
                    inFavorites = true
                    print("coin exists in favorites")
                }
            }
            
        } catch {
            print("Failed")
        }
        
        if inFavorites == true
        {
            addFavButton.isEnabled = false
            removeFavButton.isEnabled = true
        }
        else
        {
            addFavButton.isEnabled = true
            removeFavButton.isEnabled = false
        }
        
    }
    
    func getCoinData() {
        let jsonURL = "https://api.coinmarketcap.com/v1/ticker/\(coinID)/?convert=AUD"
        let url = URL(string: jsonURL)
        
        URLSession.shared.dataTask(with: url!) { [unowned self] (data, response, error) in
            guard let data = data else { return }
            do {
                self.coin = try JSONDecoder().decode([Coin].self, from: data)
                DispatchQueue.main.async {
                    self.symbolLabel.text = self.coin[0].symbol
                    self.nameLabel.text = self.coin[0].name
                    self.priceLabel.text = String(self.coin[0].price)
                    self.rankLabel.text = self.coin[0].rank
                    self.changeLabel.text = self.coin[0].dayChange
                }
            }
            catch {
                print("Error is : \n\(error)")
            }
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
