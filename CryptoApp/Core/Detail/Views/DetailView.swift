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
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)
                
                overviewTitle
                overviewGrid
                
                Divider()
                
                additionalTitle
                additionalGrid
                
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
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
