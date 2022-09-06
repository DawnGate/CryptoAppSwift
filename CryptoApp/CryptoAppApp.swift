//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Lam  on 12/07/2022.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject private var vm =  HomeViewModel()
    @State private var showLauchView: Bool = true
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView{
                    HomeView().navigationBarHidden(true)
                }
                .environmentObject(vm)
                ZStack {
                    if(showLauchView) {
                        LaunchView(showLaunchView: $showLauchView)
                    }
                }
            }
            
        }
    }
}
