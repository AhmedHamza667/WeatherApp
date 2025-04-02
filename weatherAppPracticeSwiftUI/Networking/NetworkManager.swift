//
//  NetworkManager.swift
//  weatherAppPracticeSwiftUI
//
//  Created by Ahmed Hamza on 3/6/25.
//

import Foundation
import Combine


protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(from url: String, modelType: T.Type) -> AnyPublisher<T, Error>
}


enum APIErrors: Error{
    case invalidURLError
    case parsingError
    case noDataError
    case responseError(Int)
}


class NetworkManager: NetworkManagerProtocol{
    func fetchData<T>(from url: String, modelType: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        guard let urlObject = URL(string: url) else{
            return Fail(error: APIErrors.invalidURLError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: urlObject)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else{
                    throw APIErrors.noDataError
                }
                guard (200...299).contains(httpResponse.statusCode) else{
                    throw APIErrors.responseError(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
}
