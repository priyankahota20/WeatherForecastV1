//
//  ApiService.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

// MARK: ApiService
class ApiService {
    
    private var dataTask: URLSessionDataTask?

    
    func getApiData<T:Decodable>(requestURL: URL, resultType: T.Type, completionHandler: @escaping(_ result: T) -> Void) {
        
        URLSession.shared.dataTask(with: requestURL, completionHandler: { responseData, httpUrlResponse, error in
            
            if(error == nil && responseData != nil && responseData?.count != 0) {
                 
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    _ = completionHandler(result)
                }
                catch let error {
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                }
            }
        }).resume()
    }
}
