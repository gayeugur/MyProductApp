//
//  ProductEndPoint.swift
//  MyAppClothes
//
//  Created by gayeugur on 21.09.2023.
//

import Foundation

enum ProductEndPoint {
    case products
    case filterCategory
    case productsDelete
    case categories
    case addProduct

}

extension ProductEndPoint: EndPointType {
    
    var path: String {
        get {
            switch self {
            case .products, .addProduct:
                return "products"
            case .productsDelete:
                return "products/1"
            case .categories:
                return "products/categories"
            case .filterCategory:
                return "products/category/"
            }
        }
    }
    
    var baseURL: String {
        switch self {
        case .products, .productsDelete, .categories, .addProduct, .filterCategory:
            return "https://fakestoreapi.com/"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: MethodType {
        switch self {
        case .products, .categories, .filterCategory:
            return .get
        case .productsDelete:
            return .delete
        case .addProduct:
            return .add
        }
    }
    
    var body: Encodable? {
        switch self {
        case .products, .productsDelete, .categories, .filterCategory:
            return nil
        case .addProduct:
           return nil
        }
    }
    
    var headers: [String : String]? {
        return Helper.commonHeaders
    }
    
    
}
