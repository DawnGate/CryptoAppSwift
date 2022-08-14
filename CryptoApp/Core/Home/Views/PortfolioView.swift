//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Lam  on 13/08/2022.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var animationNone: Bool = false
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading, spacing: 0)
                {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portFolioInputSection
                        
                    }
                }
            }
            .navigationTitle("Edit profile")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XmarkButton(dismiss: dismiss)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView().environmentObject(dev.homeVm)
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView (.horizontal, showsIndicators: true, content: {
            LazyHStack(spacing: 10){
                ForEach(vm.allCoins, content: { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture{
                            withAnimation(.easeIn){
                                selectedCoin = coin
                                animationNone = !animationNone
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1))
                })
            }
            .padding(.vertical, 4)
            .padding(.leading)
        })
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ??  0)
        }
        return 0
    }
    
    private var portFolioInputSection: some View {
        VStack (spacing: 20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ??  ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none, value: animationNone)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButton: some View {
        HStack(spacing: 10){
                        Image(systemName: "checkmark")
                            .opacity(showCheckMark ? 1.0 : 0.0)
                        Button(action: {
                            saveButtonPress()
                        }, label: {
                            Text("Save".uppercased())
                        })
                        .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)
                    }
                    .font(.headline)
    }
    
    private func saveButtonPress() {
        guard let coin = selectedCoin else { return }
        
        // save to portfolio
        
        //show checkmark
        withAnimation(.easeIn){
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //hide keyboard
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut){
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}

