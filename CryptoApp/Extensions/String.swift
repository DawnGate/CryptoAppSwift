//
//  String.swift
//  CryptoApp
//
//  Created by Lam  on 03/09/2022.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) 
    }
}
