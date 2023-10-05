//
//  APIManager.swift
//  MyAppClothes
//
//  Created by gayeugur on 21.09.2023.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}

typealias ResultHandler<T> = (Result<T, DataError>) -> Void

final class APIManager {
    
    static let shared = APIManager()
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler
    
    init(networkHandler: NetworkHandler = NetworkHandler(), responseHandler: ResponseHandler = ResponseHandler()) {
        self.networkHandler = networkHandler
        self.responseHandler = responseHandler
    }
    
    func request<T: Codable>(category:String? = nil, modelType: T.Type, type: EndPointType, completion: @escaping ResultHandler<T>) {
        
        
        guard var url = type.url else {
            completion(.failure(.invalidURL)) // I forgot to mention this in the video
            return
        }
        if let category =  category {
            url.append(path: category)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        
        if let parameters = type.body {
            request.httpBody = parameters as! Data
        }
        
        
        request.allHTTPHeaderFields = type.headers
        

        networkHandler.requestDataAPI(url: request) { result in
            switch result {
            case .success(let data):
                self.responseHandler.parseResonseDecode(
                    data: data,
                    modelType: modelType) { response in
                        switch response {
                        case .success(let mainResponse):
                            completion(.success(mainResponse)) 
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


class NetworkHandler {

    func requestDataAPI(url: URLRequest, completionHandler: @escaping (Result<Data, DataError>) -> Void) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completionHandler(.failure(.invalidResponse))
                return
            }

            guard let data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }

            completionHandler(.success(data))
        }
        session.resume()
    }

}

class ResponseHandler {

    func parseResonseDecode<T: Decodable>(data: Data, modelType: T.Type, completionHandler: ResultHandler<T>) {
        do {
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            completionHandler(.success(userResponse))
        }catch {
            completionHandler(.failure(.decoding(error)))
        }
    }

}
