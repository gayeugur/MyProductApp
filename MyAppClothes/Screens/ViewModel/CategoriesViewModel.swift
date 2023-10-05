//
//  CategoriesViewModel.swift
//  MyAppClothes
//
//  Created by gayeugur on 22.09.2023.
//

import Foundation

final class CategoriesViewModel {
    var categories: [String] = []
    
    var eventHandler: ((_ event: Constant.Event) -> Void)?
    
    func fetchCategories() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: [String].self,
            type: ProductEndPoint.categories) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let categories):
                    self.categories = categories
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
   
}


