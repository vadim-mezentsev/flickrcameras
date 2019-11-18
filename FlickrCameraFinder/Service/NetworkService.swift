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
    
    func fetchBrands(completionQueue: DispatchQueue, completion: @escaping (Result<FlickrBrandsResponse, NetworkError>) -> Void) {
        fetchModel(FlickrBrandsResponse.self,from: urlHelper.fetchCameraBrandsUrl()){ (result) in
            completionQueue.async {
                completion(result)
            }
        }
    }
    
    func fetchCameras(completionQueue: DispatchQueue, for brands: [Brand], completion: @escaping (Result<[Camera], NetworkError>) -> Void) {
        
        var cameras = [Camera]()
        let fetchDispatchGroup = DispatchGroup()
        var error: NetworkError?
        
        brands.forEach { brand in
            fetchDispatchGroup.enter()
            fetchModel(FlickrCamerasResponse.self,from: urlHelper.fetchCameraModelsUrl(for: brand.id)) { result in
                switch result {
                case .success(let cameraModels):
                    cameras.append(contentsOf: cameraModels.cameras!.camera)
                case .failure(let currentError):
                    print(currentError.message)
                    error = currentError
                }
                fetchDispatchGroup.leave()
            }
        }
        
        fetchDispatchGroup.notify(queue: completionQueue) {
            if error == nil {
                completion(.success(cameras))
            } else {
                completion(.failure(error!))
            }
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
                        let errorMessage = model.message ?? "Unknown flickr error."
                        let flickrError = NetworkError(message: errorMessage, type: .flickrError)
                        completion(.failure(flickrError))
                        print(model.message!)
                    }
                } else {
                    let parsingError = NetworkError(message: "Error parsing JSON.", type: .invalidJSON)
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
