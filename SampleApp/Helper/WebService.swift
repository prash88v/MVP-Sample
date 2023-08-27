//
//  WebService.swift
//  Sample
//
//  Created by Prashant Bashishth on 27/08/23.
//

import Foundation

protocol WebServiceProtocol {
    func fetchJokes(completion: @escaping (Result<String, Error>) -> Void)
}

final class WebService: WebServiceProtocol {

  
    func fetchJokes(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: AppConstants.apiBaseURL) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let content = try JSONDecoder().decode(String.self, from: data ?? Data())
                completion(.success(content))
            } catch let err {
                completion(.failure(err))
            }
        }.resume()
    }
}
