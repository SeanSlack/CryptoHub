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

class CoinView: UIViewController {

    var coin = [Coin]()
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    var coinID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCoinData()
    
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func removeAll(_ sender: Any) {
        
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            let context = appDelegate.persistentContainer.viewContext
            
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                print ("All Favorites Deleted")
            } catch {
                print ("There was an error")
            }
        
    }
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)!
        let newCoin = NSManagedObject(entity: entity, insertInto: context)
        
        newCoin.setValue(coinID, forKey: "saveCoinID")
        
        do {
            try context.save()
            print("Saved \(coinID)")
        } catch {
            print("Failed saving")
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
                    self.priceLabel.text = self.coin[0].price
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
