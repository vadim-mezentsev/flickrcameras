//
//  NetworkService.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 14/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import Foundation

class NetworkService {
    
    private let urlHelper = FlickrUrlHelper()
    
    func fetchCameraBrands(completion: @escaping (Result<FlickrCamerasBrandsResponse, NetworkError>) -> Void) {
        fetchModel(FlickrCamerasBrandsResponse.self,from: urlHelper.fetchCameraBrandsUrl()){ (result) in
            completion(result)
        }
    }
    
    func fetchCameraModels(for brand: String, completion: @escaping (Result<FlickrCamerasBrandModelsResponse, NetworkError>) -> Void) {
        fetchModel(FlickrCamerasBrandModelsResponse.self,from: urlHelper.fetchCameraModelsUrl(for: brand)){ (result) in
            completion(result)
        }
    }

    private func fetchModel<T: FlickrResponse>(_ modelType: T.Type,from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        request(url: url) { [weak self] (result) in
            
            switch result {
            case .success(let data):
                if let model = self?.decodeJSON(modelType, from: data) {
                    switch model.stat {
                    case .ok:
                        completion(.success(model))
                    case .fail:
                        let flickrError = NetworkError(message: model.message!, type: .invalidJSON)
                        completion(.failure(flickrError))
                        print(model.message!)
                    }
                } else {
                    let parsingError = NetworkError(message: "Error parsing JSON.", type: .flickrError)
                    completion(.failure(parsingError))
                }
            case .failure(let error):
                print(error.message)
                completion(.failure(error))
            }
            
        }
    }
    
    private func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch (let error) {
            print(error)
        }
        return nil
    }
    
    private func request(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                let requestError = NetworkError(message: error!.localizedDescription, type: .invalidRequest)
                completion(.failure(requestError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                let requestError = NetworkError(message: "Invalid response format.", type: .invalidResponse)
                completion(.failure(requestError))
                return
            }
            
            completion(.success(data))
        }
        dataTask.resume()
    }
}
