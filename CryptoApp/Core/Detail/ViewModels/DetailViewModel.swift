//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Lam  on 19/08/2022.
//

import Foundation
import Combine

class DetailModelView: ObservableObject{
    private let coinDetailServices: CoinDataDetailService
    private var cancellable = Set<AnyCancellable>()
    
    
    @Published var coin: CoinModel
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailServices = CoinDataDetailService(coin: coin)
        self.addSubcribers()
    }
    
    private func addSubcribers() {
        
        coinDetailServices.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink{
                [weak self](returnArrays) in
                self?.overviewStatistics = returnArrays.overview
                self?.additionalStatistics = returnArrays.additional
            }
            .store(in: &cancellable)
    }
    
    private func mapDataToStatistic(details: CoinModelDetail?, coin: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        let overviewArray = createOverviewArray(coinModel: coin)
        let additionalArray = createAdditionalArray(coinDetailModel: details, coinModel: coin)
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        // overview
                let price = coinModel.currentPrice.asCurrencyWith6Decimals()
                let priceChange = coinModel.priceChangePercentage24H
                let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: priceChange)
                
                let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreaviation() ?? "")
                let marketCapChange = coinModel.marketCapChangePercentage24H
                let marketCapStat = StatisticModel(title: "Market Captalization", value: marketCap, percentageChange: marketCapChange)
                
                let rank = "\(coinModel.rank)"
                let rankStat = StatisticModel(title: "Rank", value: rank)
                
                let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreaviation() ?? "")
                let volumeStat = StatisticModel(title: "Volume", value: volume)
                
                let overviewArray: [StatisticModel] = [priceStat, marketCapStat, rankStat, volumeStat]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coinDetailModel: CoinModelDetail?, coinModel: CoinModel) -> [StatisticModel] {
        // additonal
                let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
                let highStat = StatisticModel(title: "24h High", value: high )
                
                let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
                let lowStat = StatisticModel(title: "24h Low", value: low )
                
                let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
                let priceChangePercent = coinModel.priceChangePercentage24H
                let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: priceChangePercent)
                
                let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreaviation() ?? "")
                let marketCapChangePercent = coinModel.marketCapChangePercentage24H
                let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapChangePercent)
                
                let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
                let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
                let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
                
                let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
                let hashingStat = StatisticModel(title: "Hasing Algorithm", value: hashing)
                
                let additionalArray: [StatisticModel] = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat]
        
        return additionalArray
    }
}
