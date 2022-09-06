//
//  LaunchView.swift
//  CryptoApp
//
//  Created by Lam  on 06/09/2022.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map{String($0)}
    @State private var showLoadingText: Bool = false
    private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    
    @Binding var showLaunchView: Bool
    
    init(showLaunchView: Binding<Bool>) {
        self._showLaunchView = showLaunchView
    }
    
    
    var body: some View {
        ZStack {
            Color.launchTheme.background.ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            
            ZStack {
                if(showLoadingText)
                {
                    HStack(spacing: 0){
                        ForEach(loadingText.indices, id: \.self) { index in
                        Text(loadingText[index])
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.launchTheme.accent)
                            .offset(y: counter == index ? -5 : 0)
                        }
                    }
                }
            }
            .offset(y: 70)
        }
        .onAppear{
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        })
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}