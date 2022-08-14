//
//  CircleButtonWithAnimationView.swift
//  CryptoApp
//
//  Created by Lam  on 14/07/2022.
//

import SwiftUI

struct CircleButtonWithAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
            Circle()
                .stroke(lineWidth: 5.0)
                .scale(animate ? 1.0 : 0.0)
                .opacity(animate ? 0.0 : 1.0)
                .animation(animate ? .easeOut(duration: 1.0) : .none, value: animate)
    }
}

struct CircleButtonWithAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonWithAnimationView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
    }
}
