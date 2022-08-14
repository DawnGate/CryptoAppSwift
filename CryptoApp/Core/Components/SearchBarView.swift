//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Lam  on 09/08/2022.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ?  Color.theme.secondaryText : Color.theme.accent)
            TextField("Search by name or symbol", text:
            $searchText)
            .keyboardType(.alphabet)
            .disableAutocorrection(true)
            .foregroundColor(Color.theme.accent)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(Color.theme.accent)
                    .opacity( searchText.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditting() 
                        searchText = ""
                    }
                , alignment: .trailing
            )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.15), radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
        }
    }
        
}
