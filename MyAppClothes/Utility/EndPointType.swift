//
//  EndPointType.swift
//  MyAppClothes
//
//  Created by gayeugur on 21.09.2023.
//

import Foundation

enum MethodType: String {
    case get = "GET"
    case delete = "DELETE"
    case add = "POST"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: MethodType { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

