//
//  Shared.swift
//  MyAppClothes
//
//  Created by gayeugur on 24.09.2023.
//

import Foundation

class SharedBasketArray {

    static let shared = SharedBasketArray()

    // Paylaşılan dizi
    var basketArray: [Product] = []

    func totalValue() -> Double {
        return basketArray.reduce(0) { $0 + $1.price }
    }
    
  //  private init() {}
}
