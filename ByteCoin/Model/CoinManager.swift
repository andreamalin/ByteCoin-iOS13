//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "b7f55de4-9a2c-479d-adce-2136bc0653bc"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(with: urlString, currencyLabel: currency)
    }
    
    func performRequest(with urlString: String, currencyLabel: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            // Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    print(safeData)
                    if let coin = parseJSON(safeData, currencyLabel: currencyLabel) {
                        delegate?.didUpdatePrice(self, coin: coin)
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data, currencyLabel: String) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            print(decodedData)
            let coin = CoinModel(rate: decodedData.rate, currencyLabel: currencyLabel)
            return coin
        } catch {
            print(error)
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
