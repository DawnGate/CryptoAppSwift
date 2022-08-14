//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Lam  on 19/07/2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var statistics : [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoin: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinService = CoinDataService()
    private let marketService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubcribers()
    }
    
    func addSubcribers() {
        //        dataService.$allCoins
        //            .sink{
        //                [weak self] (returnedCoins) in
        //                self?.allCoins = returnedCoins
        //            }
        //            .store(in: &cancellables)
        
        $searchText.combineLatest(coinService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink{
                [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketService.$marketData
            .map{(marketDataModel) -> [StatisticModel] in
                
                var stats: [StatisticModel] = []
                
                guard let data = marketDataModel else { return stats }
                
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: "24h Volume", value: data.volume)
                let btcDominace = StatisticModel(title: "Btc Dominance", value: data.btcDominate)
                let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
                
                stats.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominace,
                    portfolio
                ])
                return stats
            }
            .sink{[weak self] (returnStats) in
                self?.statistics = returnStats
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [
        CoinModel] {
            guard !text.isEmpty else { return coins}
            
            let lowercasedText = text.lowercased()
            
            return coins.filter{(coin) -> Bool in
                return coin.name.lowercased().contains(lowercasedText) ||
                coin.symbol.lowercased().contains(lowercasedText) ||
                coin.id.lowercased().contains(lowercasedText)
            }
        }
}
