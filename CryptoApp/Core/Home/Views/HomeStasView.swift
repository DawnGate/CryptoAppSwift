//
//  HomeStasView.swift
//  CryptoApp
//
//  Created by Lam  on 11/08/2022.
//

import SwiftUI

struct HomeStasView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack{
            ForEach(vm.statistics) {
                stat in
                StatisticView(state: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStasView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStasView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVm)
    }
}
