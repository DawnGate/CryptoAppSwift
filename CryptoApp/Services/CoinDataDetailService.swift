//
//  CoinDataDetailService.swift
//  CryptoApp
//
//  Created by Lam  on 19/08/2022.
//

import Foundation
import Combine

class CoinDataDetailService {
    
    @Published var coinDetail: CoinModelDetail? = nil
    
    var coinDetailSubcription: AnyCancellable?
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
   func getCoinDetails() {
       guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickets=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        
        coinDetailSubcription = NetworkingManager.download(url: url)
           .decode(type: CoinModelDetail.self ,decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self](returnedCoinDetails) in
                self?.coinDetail = returnedCoinDetails
                self?.coinDetailSubcription?.cancel()
            })
        
    }
}
