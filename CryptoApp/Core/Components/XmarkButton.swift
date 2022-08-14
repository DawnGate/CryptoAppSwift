//
//  XmarkButton.swift
//  CryptoApp
//
//  Created by Lam  on 13/08/2022.
//

import SwiftUI

struct XmarkButton: View {
    
    
//    @Environment(\.dismiss) private var dismiss
    
    let dismiss: DismissAction
    
    var body: some View {
        Button(action: {
            dismiss()
        }, label: { Image(systemName: "xmark").font(.headline)})
    }
}

//struct XmarkButton_Previews: PreviewProvider {
//    static var previews: some View {
//
//        XmarkButton(dismiss: .constant(()->Void))
//    }
//}
