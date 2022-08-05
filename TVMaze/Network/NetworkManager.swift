//
//  Service.swift
//  TVMaze
//
//  Created by Youssef on 8/3/22.
//

import Foundation

class NetworkManager {
    
    class func request<T: Codable>(_ router: Router, completion: @escaping (Result<T, Error>) -> ()) {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let componentsURL = components.url else { return }
        
        var request = URLRequest(url: componentsURL)
        request.httpMethod = router.method
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, serverResponse, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard serverResponse != nil, let data = data else {
                return
            }
     
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(response))
                }

            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        
        dataTask.resume()
    }
}
