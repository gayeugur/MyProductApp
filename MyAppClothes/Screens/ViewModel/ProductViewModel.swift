//
//  ProductViewModel.swift
//  MyAppClothes
//
//  Created by gayeugur on 21.09.2023.
//

import Foundation

final class ProductViewModel {
    var products: [Product] = []

    var eventHandler: ((_ event: Constant.Event) -> Void)? // Data Binding Closure

    func fetchProducts() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: [Product].self,
            type: ProductEndPoint.products) { response in
                self.eventHandler?(.stopLoading) 
                switch response {
                case .success(let products):
                    self.products = products
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    func filterCategory(_ category: String) {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            category: category,
            modelType: [Product].self,
            type: ProductEndPoint.filterCategory) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let products):
                    self.products = products
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    

}



