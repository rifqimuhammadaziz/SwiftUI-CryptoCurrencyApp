//
//  HomeViewModel.swift
//  SwiftUI-CryptoCurrencyApp
//
//  Created by Rifqi Muhammad Aziz on 09/02/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    
    init() {
        fetchCoinData()
    }
    
    func fetchCoinData() {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // show if error
            if let error = error {
                print("DEBUG: Error \(error.localizedDescription)")
                return
            }
            
            // get status code
            if let response = response as? HTTPURLResponse {
                print("DEBUG: Response Code \(response.statusCode)")
            }
            
            // get data
            guard let data = data else { return }
            
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                print("DEBUG: Coin \(coins)")
                self.coins = coins
            } catch let error {
                print("DEBUG: Failed to decode with error: \(error)")
            }
        }
        .resume()
    }
    
}
