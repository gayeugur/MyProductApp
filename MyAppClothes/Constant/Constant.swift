//
//  Constant.swift
//  MyAppClothes
//
//  Created by gayeugur on 20.09.2023.
//

import Foundation

class Constant {
    
    enum API {
        static let productURL = "https://fakestoreapi.com/products"
    }
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}


