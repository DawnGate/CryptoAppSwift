//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Lam  on 11/08/2022.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketSubcription: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        
        marketSubcription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self](returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketSubcription?.cancel()
            })
        
    }
}

