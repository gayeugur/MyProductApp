//
//  Product.swift
//  MyAppClothes
//
//  Created by gayeugur on 21.09.2023.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rate
    var stock: Int?
}

struct Rate: Codable {
    let rate: Double
    let count: Int
}
