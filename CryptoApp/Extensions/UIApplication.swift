//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Lam  on 09/08/2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditting() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
