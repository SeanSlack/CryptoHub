//
//  CoinView.swift
//  CryptoHub
//
//  Created by Sean on 12/5/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit

class CoinView: UIViewController {

    var coinSymbol = String()
    

    @IBOutlet weak var coinViewName: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        coinViewName.text = coinSymbol
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinViewName.text = coinSymbol
        // Do any additional setup after loading the view.
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
