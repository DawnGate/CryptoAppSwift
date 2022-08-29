//
//  DetailView.swift
//  CryptoApp
//
//  Created by Lam  on 17/08/2022.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    let coin: CoinModel
    
    @StateObject var vm: DetailModelView
    private let columns: [GridItem] = [GridItem(.flexible()),
                                       GridItem(.flexible())]
    
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailModelView(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    overviewTitle
                    overviewGrid
                    
                    Divider()
                    
                    additionalTitle
                    additionalGrid
                    
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(Color.theme.secondaryText)
                    CoinImageView(coin: vm.coin)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
        .preferredColorScheme(.dark)
    }
    
    
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    private var additionalTitle: some View {
        Text("Additional Detail")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: [], content: {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(state:stat)
            }
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: [], content: {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(state: stat)
            }
        })
    }
}
