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
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let coinService = CoinDataService()
    private let marketService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubcribers()
    }
    
    func addSubcribers() {
        
        // updates allCoins
        $searchText.combineLatest(coinService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink{
                [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins.combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoin) in
                self?.portfolioCoins = returnedCoin
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink{[weak self] (returnStats) in
                self?.statistics = returnStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    func updatePortfolio (coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinService.getCoins()
        marketService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { coin in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominace = StatisticModel(title: "Btc Dominance", value: data.btcDominate)
        
        let portfolioValue = portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +)
        let previousPortfolioValue = portfolioCoins.map{ (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H ?? 0 / 100
            let previousValue = currentValue / ( 1 + percentChange)
            return previousValue
        }.reduce(0, +)
        
        let percentageChange = ((portfolioValue / previousPortfolioValue) - 1 )
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals() ,percentageChange: percentageChange )
        
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominace,
            portfolio
        ])
        return stats
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
