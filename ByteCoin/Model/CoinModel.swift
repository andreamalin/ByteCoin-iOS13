//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Andrea Amaya on 5/01/25.
//  Copyright © 2025 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let rate: Double
    let currencyLabel: String
    
    var rateString: String {
        return String(format: "%.1f", rate)
    }
}
